{%- set nodename = pillar['nodename'] %}
{%- set master_mysql = pillar['mysql_config']['node_selector']['master'] %}
{% if salt['file.directory_exists' ]( "/opt/salt-"+nodename )  and nodename != pillar['redis_default_master'] and nodename != master_mysql  %}
stop_remove:
 cmd.run:
   - name: 'rm -rf /opt/salt-{{nodename}} && salt-key -y -d {{nodename}}'
remove_nodes_defenition:
 cmd.run:
   - name: yq -e  'del( .*.{{nodename.split('-')[1]}}.[] | select(. == "{{ nodename.split('-')[0] }}") )' < /srv/salt/pillar/all/nodes_defenation.sls > /tmp/{{nodename}}.tmp && cp /tmp/{{nodename}}.tmp  /srv/salt/pillar/all/nodes_defenation.sls && salt '*' saltutil.refresh_pillar -t 30
{% elif nodename == pillar['redis_default_master']   %}
redis_master_warning:
 cmd.run:
   - name: 'Please change defautl Master redis sever befor remove node'
{% elif nodename == master_mysql  %}
mysql_master_warning:
 cmd.run:
   - name: 'Please change defautl Mysql Master sever befor remove node'
{% endif %}

{% if salt['file.directory_exists' ]( "/opt/salt-"+nodename )   and nodename.split('-')[1] == 'mysql' %}
remove_mysql_config:
 cmd.run:
   - name: echo "if node removed permanently please uncomment this line"
   #- name: yq -e  'del( .mysql_config.node_selector.*.[] | select(. == "Nnode04-mysql"),.mysql_config.root_password.Nnode04-mysql, .mysql_config.node_id.Nnode04-mysql )' < /srv/salt/pillar/all/mysql.sls > /tmp/{{nodename}}.tmp && cp /tmp/{{nodename}}.tmp   /srv/salt/pillar/all/mysql.sls  && salt '*' saltutil.refresh_pillar

{% endif %}
