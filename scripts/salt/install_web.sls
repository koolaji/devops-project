{%- set config = salt['pillar.get']('node_def')['web']%}
{% for nodename in  config %}
install_nspawn_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.install_nspawn

create_web_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.create_container
      - pillar: { 'nodename' : '{{ nodename }}-web'}
      - require:
         - salt: 'install_nspawn_{{ nodename }}'

start_salt_minion_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.active_saltminion
      - pillar: { 'nodename' : '{{ nodename }}-web'}
      - require:
         - salt: 'create_web_container_{{ nodename }}'

accept_key_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.accept_key
      - pillar: { 'nodename' : '{{ nodename }}-web'}
      - require:
         - salt: 'start_salt_minion_{{ nodename }}'

install_web_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}-web'
      - sls:
         - sls_files.install_web
      - require:
         - salt: 'accept_key_{{ nodename }}'

{% endfor %}
