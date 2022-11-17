{%- set nodename = pillar['nodename'] %}
{%- set mysql_config = salt['pillar.get']('mysql_config')%}
{%- set master_ip = mysql_config['node_selector']['master_ip'] %}
{%- set mysql_root_pass = salt['pillar.get']('mysql_root_pass')%}

/tmp:
  file.directory:
    - mode: 1777

update_host_file:
  file.append:
    - name: /etc/hosts
    - text:
      - {{ pillar['master_config']['master_ip'] }} master

{% if  salt['file.directory_exists' ]( '/opt/'+nodename ) != True   %}

copy_deb_file:
  file.managed:
    - source: salt://files/pxc.tar.gz
    - name: /opt/pxc.tar.gz

install_mysql_deb:
  cmd.run:
    - name: |
       echo "
       export DEBIAN_FRONTEND=noninteractive
       /usr/bin/debconf-set-selections <<< \"percona-xtradb-cluster-common percona-xtradb-cluster-common/root_password password $password\"
       debconf-set-selections <<< \"percona-xtradb-cluster-common percona-xtradb-cluster-common/root_password_again password $password\"
       cd /opt/
       tar xvzf pxc.tar.gz
       cd pxc
       dpkg -i  debsums_2.2.2_all.deb  perl_5.24.1-3+deb9u7_amd64.deb ucf_3.0036_all.deb libfile-fnmatch-perl_0.02-2+b3_amd64.deb libdpkg-perl_1.18.25_all.deb  libperl5.24_5.24.1-3+deb9u7_amd64.deb  perl-modules-5.24_5.24.1-3+deb9u7_all.deb
       dpkg -i percona-xtradb-cluster-common_8.0.26-16-1.stretch_amd64.deb
       dpkg -i libdbd-mysql-perl_4.041-2_amd64.deb libdbi-perl_1.636-1+b1_amd64.deb  libmariadbclient18_10.1.45-0+deb9u1_amd64.deb
       dpkg -i *.deb
       rm -r /opt/pxc.tar.gz /opt/pxc" > /tmp/install_mysql.sh
       bash /tmp/install_mysql.sh && rm /tmp/install_mysql.sh
       sleep 5 
    - env:
        - password: {{ mysql_root_pass }}

mysql_start:
  service.running:
    - enable: True
    - restart: True
    - name: mysql

change_bind_address:
  cmd.run:
    - name: |
        sleep 5
        mysql -uroot -p$password << EOF_MYSQL
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        CREATE USER 'root'@'%' IDENTIFIED BY "$password";
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
        FLUSH PRIVILEGES;
        EOF_MYSQL
    - env:
        - password: {{ mysql_root_pass }}


/var/lib/mysql:
  file.directory:
    - group: mysql
    - user: mysql

{% endif %}

/etc/mysql/mysql.conf.d/mysqld.cnf:
    file.managed:
        - source: salt://configs/mysqld.cnf
        - template: jinja

mysql:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file: /etc/mysql/mysql.conf.d/mysqld.cnf

{%- for node_name in mysql_config['node_selector']['slave'] %}
{% if  mysql_config['node_selector']['master']  ==  nodename  and  salt['file.directory_exists']("/opt/replication-"+node_name ) != True  %}
{{ node_name }}:
  cmd.run:
    - name: |
        mysql -uroot -p$password<< EOF_MYSQL
        create user '{{ node_name }}'@'%' identified WITH mysql_native_password  by '{{ node_name }}';
        GRANT REPLICATION SLAVE ON *.*  TO '{{  node_name }}'@'%';
        EOF_MYSQL
    - env:
        - password: {{ mysql_root_pass }}

/opt/replication-{{node_name}}:
  file.directory:
    - makedirs: True

{% endif %}

{% endfor %}


/opt/{{nodename}}:
  file.directory:
    - makedirs: True


{% if ( mysql_config['node_selector']['master'] != grains['nodename'] ) and  ( salt['file.directory_exists']("/opt/replication-"+nodename ) != True )   %}

replication-cofig:
  cmd.run:
    - name: |
        echo "password = $password, check_password = {{ mysql_root_pass }}"
        mysql_query=`mysql -uroot -p$password -s -N -h {{ master_ip }} -e 'show master status;'`
        mysql_file=`echo $mysql_query | awk '{print $1}'`
        mysql_file_point=`echo $mysql_query | awk '{print $2}'`
        mysql -u root -p$password<< EOF_MYSQL
        CHANGE MASTER TO MASTER_HOST='{{ master_ip }}', MASTER_USER='{{ grains['nodename'] }}', MASTER_PASSWORD='{{ grains['nodename'] }}', MASTER_LOG_FILE='$mysql_file';
        START SLAVE;
        SHOW SLAVE STATUS;
        EOF_MYSQL
    - env:
        - password: {{ mysql_root_pass }}

/opt/replication-{{nodename}}:
  file.directory:
    - makedirs: True

{% endif %}
