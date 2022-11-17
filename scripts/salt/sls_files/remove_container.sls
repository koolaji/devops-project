{%- set nodename = pillar['nodename'] %}
{%- set master_mysql = pillar['mysql_config']['node_selector']['master'] %}
{% if salt['file.directory_exists' ]( "/opt/salt-"+nodename )  and nodename != pillar['redis_default_master'] and nodename != master_mysql  %}

stop_remove:
 cmd.run:
   - name: 'machinectl kill {{ nodename }}  ; machinectl kill {{ nodename }}   && rm -rf /opt/salt-{{nodename}} && rm -rf /var/lib/machines/{{nodename}} '
{% elif nodename == pillar['redis_default_master']   %}
redis_master_warning:
 cmd.run:
   - name: 'Please change defautl Redis Master sever befor remove node'
{% elif nodename == master_mysql  %}
mysql_master_warning:
 cmd.run:
   - name: 'Please change defautl Mysql Master sever befor remove node'

{% endif %}
