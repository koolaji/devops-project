{%- set nodename = pillar['nodename'] %}
remove_container_{{ nodename }}:
   salt.state:
      - tgt: '{{ nodename }}'
      - pillar: { 'nodename' : '{{ nodename }}-redis'}
      - sls:
         - sls_files.remove_container

deactivate_minion_{{ nodename }}:
   salt.state:
      - tgt: 'master'
      - sls:
         - sls_files.deactivate_minion
      - pillar: { 'nodename' : '{{ nodename }}-redis'}
      - require:
         - salt: 'remove_container_{{ nodename }}'

