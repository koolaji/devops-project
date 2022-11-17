{%- set nodename = pillar['nodename'] %}
remove_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - pillar: { 'nodename' : '{{ nodename }}-memcache'}
      - sls:
         - sls_files.remove_container

deactivate_minion_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.deactivate_minion
      - pillar: { 'nodename' : '{{ nodename }}-memcache'}
      - require:
         - salt: 'remove_container_{{ nodename }}'
{%- set config = salt['pillar.get']('node_def')['mcrouter']%}
{% for nodename in  config   %}
install_mcrouter_{{ nodename }}:
   salt.state:
      - tgt: {{ nodename }}-mcrouter
      - sls:
         - sls_files.install_mcrouter
{% endfor %}
