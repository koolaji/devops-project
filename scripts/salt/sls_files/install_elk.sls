{%- set nodename = pillar['nodename'] %}
add_group:
  group.present:
     - name: elasticsearch

add_user:
  user.present:
     - name: elasticsearch
     - groups: 
         - elasticsearch

/var/lib/elasticsearch:
  file.directory:
    - mode: 1755
    - group: elasticsearch
    - user: elasticsearch

update_host_file:
  file.append:
    - name: /etc/hosts
    - text:
      - {{ pillar['master_config']['master_ip'] }} Nmaster

{% for node in pillar['node_def']['elk']  %}
{{node}}_host_file:
  file.append:
    - name: /etc/hosts
    - text:
       - {{ pillar['ip_address'][node] }}  {{ node }}-elk 
{% endfor %}

{% if  salt['file.directory_exists' ]( '/etc/elasticsearch' ) != True   %}
copy_elk_deb_file:
  file.managed:
    - source: salt://files/elasticsearch-7.17.7-amd64.deb
    - name: /opt/elasticsearch-7.17.7-amd64.deb

install_elk:
  cmd.run:
    - name: "dpkg -i  /opt/elasticsearch-7.17.7-amd64.deb 2>/dev/null"
{% endif %}

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://configs/elasticsearch.yml
    - template: jinja

copy_elk_jvm:
  file.managed:
    - source: salt://configs/jvm.options
    - name: /etc/elasticsearch/jvm.options

elasticsearch:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file:  /etc/elasticsearch/elasticsearch.yml


{% if  salt['file.directory_exists' ]( '/etc/kibana' ) != True  and  pillar['elk_master_config']['master_nodename']+"-elk" == grains['nodename']   %}

copy_kibana_deb_file:
  file.managed:
    - source: salt://files/kibana-7.17.7-amd64.deb
    - name: /opt/kibana-7.17.7-amd64.deb

install_kibana:
  cmd.run:
    - name: "dpkg -i  /opt/kibana-7.17.7-amd64.deb 2>/dev/null && sleep 15"

{% endif  %}

{% if  pillar['elk_master_config']['master_nodename']+"-elk" == grains['nodename'] %}
/etc/kibana/kibana.yml:
  file.managed:
    - source: salt://configs/kibana.yml
    - template: jinja
kibana:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file:  /etc/kibana/kibana.yml
{% endif  %}

