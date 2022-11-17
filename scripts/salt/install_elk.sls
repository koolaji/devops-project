{%- set config = salt['pillar.get']('node_def')['elk']%}
{% for nodename in  config  %}
install_nspawn_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.install_nspawn

create_elk_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.create_container
      - pillar: { 'nodename' : {{ nodename }}-elk}
      - require:
        - salt: 'install_nspawn_{{ nodename }}'

start_salt_minion_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.active_saltminion
      - pillar: { 'nodename' : {{ nodename }}-elk}
      - require:
        - salt: 'create_elk_container_{{ nodename }}'

accept_key_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.accept_key
      - pillar: { 'nodename' : {{ nodename }}-elk}
      - require:
        - salt: 'start_salt_minion_{{ nodename }}'

install_elk_{{ nodename }}:
   salt.state:
      - tgt: {{ nodename }}-elk
      - sls:
         - sls_files.install_elk
      - pillar: { 'nodename' : {{ nodename }}-elk}
      - require:
        - salt: 'accept_key_{{ nodename }}'
{% endfor %}

