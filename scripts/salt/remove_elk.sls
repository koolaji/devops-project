{%- set nodename = pillar['nodename'] %}
remove_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - pillar: { 'nodename' : '{{ nodename }}-elk'}
      - sls:
         - sls_files.remove_container

deactivate_minion_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.deactivate_minion
      - pillar: { 'nodename' : '{{ nodename }}-elk'}
      - require:
         - salt: 'remove_container_{{ nodename }}'
{% for old_nodename in  salt['pillar.get']('node_def')['elk']   %}
{% if nodename !=  old_nodename %}
install_elk_{{ old_nodename }}:
   salt.state:
      - tgt: {{ old_nodename }}-elk
      - pillar: { 'nodename' : {{ nodename }}-elk}
      - sls:
         - sls_files.install_elk
{% endif %}
{% endfor %}

