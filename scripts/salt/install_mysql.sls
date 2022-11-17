{%- set config = salt['pillar.get']('node_def')['mysql']%}
{% for nodename in  config   %}
install_nspawn_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.install_nspawn

create_mysql_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.create_container
      - pillar: { 'nodename' : '{{ nodename }}-mysql'}
      - require:
         - salt: 'install_nspawn_{{ nodename }}'

start_salt_minion_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.active_saltminion
      - pillar: { 'nodename' : '{{ nodename }}-mysql'}
      - require:
         - salt: 'create_mysql_container_{{ nodename }}'

accept_key_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.accept_key
      - pillar: { 'nodename' : '{{ nodename }}-mysql'}
      - require:
         - salt: 'start_salt_minion_{{ nodename }}'

install_mysql_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}-mysql'
      - sls:
         - sls_files.install_mysql
      - pillar: { 'nodename' : '{{ nodename }}-mysql'}
      - require:
         - salt: 'accept_key_{{ nodename }}'

{% endfor %}
