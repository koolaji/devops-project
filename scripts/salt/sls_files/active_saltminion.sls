{%- set nodename = pillar['nodename'] %}

{% if salt['file.directory_exists' ]( "/opt/salt-"+nodename ) != True   %}

/var/lib/machines/{{ nodename }}/etc/salt/minion:
 file.append:
  - text:
     - "master: {{ pillar['master_config']['master_ip'] }}"
     - "id: {{ nodename }}"

enable_network:
 cmd.run: 
   - name: "machinectl shell root@{{ nodename }} /bin/systemctl enable systemd-networkd"

start_network:
 cmd.run: 
   - name: "machinectl shell root@{{ nodename }} /bin/systemctl start systemd-networkd"

enable_salt_minion:
 cmd.run: 
   - name: "machinectl shell root@{{ nodename }} /bin/systemctl enable salt-minion"

start_salt_minion:
 cmd.run: 
   - name: "machinectl shell root@{{ nodename }} /bin/systemctl restart salt-minion"

{% endif %}

/opt/salt-{{nodename}}:
  file.directory:
    - makedirs: True
