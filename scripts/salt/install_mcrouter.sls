{%- set config = salt['pillar.get']('node_def')['mcrouter']%}
{% for nodename in  config   %}
install_nspawn_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.install_nspawn

create_mcrouter_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.create_container
      - pillar: { 'nodename' : {{ nodename }}-mcrouter}
      - require:
        - salt: 'install_nspawn_{{ nodename }}'

start_salt_minion_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - sls:
         - sls_files.active_saltminion
      - pillar: { 'nodename' : {{ nodename }}-mcrouter}
      - require:
        - salt: 'create_mcrouter_container_{{ nodename }}'

accept_key_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.accept_key
      - pillar: { 'nodename' : {{ nodename }}-mcrouter}
      - require:
        - salt: 'start_salt_minion_{{ nodename }}'

install_mcrouter_{{ nodename }}:
   salt.state:
      - tgt: {{ nodename }}-mcrouter
      - sls:
         - sls_files.install_mcrouter
      - require:
        - salt: 'accept_key_{{ nodename }}'
{% endfor %}

