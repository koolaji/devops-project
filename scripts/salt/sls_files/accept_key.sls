{%- set nodename = pillar['nodename'] %}
{% set check = salt['cmd.shell']("sudo salt-key -L | grep -x  {{ pillar['nodename'] }}" ) %}

{% if salt['file.directory_exists' ]( "/opt/salt-"+nodename ) != true  %}

accept_key:
  cmd.run:
    - name:  "sleep 10 ; salt-key -A -y  {{ pillar['nodename'] }}   ; sleep 10"

{% endif %}

/opt/salt-{{nodename}}:
  file.directory:
    - makedirs: True
