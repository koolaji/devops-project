{%- set config = salt['pillar.get']('node_def')['redis']%}
{% for nodename in  config  %}
install_nspawn_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.install_nspawn

create_redis_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.create_container
      - pillar: { 'nodename' : {{ nodename }}-redis}
      - require:
         - salt: 'install_nspawn_{{ nodename }}'

start_salt_minion_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.active_saltminion
      - pillar: { 'nodename' : {{ nodename }}-redis}
      - require:
         - salt: 'create_redis_container_{{ nodename }}'

accept_key_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.accept_key
      - pillar: { 'nodename' : {{ nodename }}-redis}
      - require:
         - salt: 'start_salt_minion_{{ nodename }}'

install_redis_{{ nodename }}:
   salt.state:
      - tgt: {{ nodename }}-redis
      - sls:
         - sls_files.install_redis
      - require:
         - salt: 'accept_key_{{ nodename }}'

{% endfor %}
