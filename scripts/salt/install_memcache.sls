{%- set config = salt['pillar.get']('node_def')['memcache']%}
{% for nodename in  config  %}
install_nspawn_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.install_nspawn

create_memcache_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.create_container
      - pillar: { 'nodename' : '{{ nodename }}-memcache'}
      - require:
        - salt: 'install_nspawn_{{ nodename }}'

start_salt_minion_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.active_saltminion
      - pillar: { 'nodename' : '{{ nodename }}-memcache'}
      - require:
        - salt: 'create_memcache_container_{{ nodename }}'

accept_key_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.accept_key
      - pillar: { 'nodename' : '{{ nodename }}-memcache'}
      - require:
        - salt: 'start_salt_minion_{{ nodename }}'

install_memcache_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}-memcache'
      - sls:
         - sls_files.install_memcache
      - require:
        - salt: 'accept_key_{{ nodename }}'

{% endfor %}
