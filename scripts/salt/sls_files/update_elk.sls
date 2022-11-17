{% for nodename in  salt['pillar.get']('node_def')['elk']   %}
install_elk_{{ nodename }}:
   salt.state:
      - tgt: {{ nodename }}-elk
      - sls:
         - sls_files.install_elk
{% endfor %}
