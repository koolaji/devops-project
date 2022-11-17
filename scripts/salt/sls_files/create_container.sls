{%- set nodename = pillar['nodename'] %}

{% if nodename.endswith('-elk') %}
vm.max_map_count:
   sysctl.present:
    - value: 262144

elasticsearch:
  lvm.lv_present:
    - vgname: ubuntu-vg
    - size: 5G

disk_format:
  file.directory:  
    - name: /var/lib/elasticsearch
    - makedirs: True
  blockdev.formatted:
    - name: /dev/ubuntu-vg/elasticsearch
    - fs_type: xfs
  mount.mounted:
    - name: /var/lib/elasticsearch
    - device: /dev/ubuntu-vg/elasticsearch
    - fstype: xfs

{% endif %}

{% if nodename.endswith('-mysql') %}
mysql:
  lvm.lv_present:
    - vgname: ubuntu-vg
    - size: 5G

disk_format:
  file.directory:  
    - name: /var/lib/mysql
    - makedirs: True
  blockdev.formatted:
    - name: /dev/ubuntu-vg/mysql
    - fs_type: xfs
  mount.mounted:
    - name: /var/lib/mysql
    - device: /dev/ubuntu-vg/mysql
    - fstype: xfs

{% endif %}

{% if salt['file.directory_exists' ]( "/var/lib/machines/"+nodename ) != True  %}
create_base_container:
  cmd.run:
    - name: "cp -r  /var/lib/machines/debian/  /var/lib/machines/{{ nodename }}"

create_nspawn_directory:
  cmd.run:
    - name: "[ ! -d /etc/systemd/nspawn ] &&  mkdir -p /etc/systemd/nspawn || exit 0 "

sethostname:
  cmd.run:
    - name: echo  {{ nodename }} > /var/lib/machines/{{ nodename }}/etc/hostname

{% endif %}

{% if nodename.endswith('-redis') %}
/var/lib/machines/{{ nodename }}/opt/check_master_redis.py:
  file.managed:
    - source: salt://configs/check_master_redis.py
{% endif %}

/etc/systemd/nspawn/{{ nodename }}.nspawn:
    file.managed:
        - source: salt://configs/config.nspawn
        - template: jinja

{% if salt['file.directory_exists' ]( "/var/lib/machines/"+nodename ) != True %}
enable_nspawn_service:
  cmd.run: 
    - name: "machinectl enable {{ nodename }}"

start_container:
  cmd.run:
    - name: "machinectl start {{ nodename }} && sleep 10"

{% endif %}


