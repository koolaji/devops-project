{%- set app_version = salt['pillar.get']('nspawn_app_version')%}

nspawn-systemd_install:
  pkg.installed:
    - allow_updates: True
    - pkgs:
        - debootstrap: {{ app_version['debootstrap'] }}
        - systemd-container: {{ app_version['systemd-container'] }}
        - bridge-utils: {{ app_version['bridge-utils'] }}

{% if salt['file.directory_exists' ]('/var/lib/machines/debian') != true  %}
#create_container:
#  cmd.run:
#    - name: "[ ! -d /var/lib/machines/debian/ ] && debootstrap --include=systemd-container,salt-minion,vim,sudo  --arch amd64 stretch  /var/lib/machines/debian/    https://deb.debian.org/debian || exit 0"

#copy_file_nspawn_sources.list:
#  file.managed:
#    - source: salt://configs/sources.list
#    - name: /var/lib/machines/debian/etc/apt/sources.list

#copy_file_nspawn_resolv.conf:
#  file.managed:
#    - source: salt://configs/resolv.conf
#    - name: /var/lib/machines/debian/etc/resolv.conf

copy_file_nspawn_debian:
  file.managed:
    - source: salt://files/debian.tar.gz
    - name: /var/lib/machines/debian.tar.gz

tar_file_nspwan_debian:
  cmd.run:
    - name: 'cd /var/lib/machines/;  tar xvzf debian.tar.gz &&  rm -rf  debian.tar.gz'

{% endif %}

