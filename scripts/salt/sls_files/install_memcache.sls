{%- set app_version = salt['pillar.get']('memcached_app_version')%}
/tmp:
  file.directory:
    - mode: 1777

update_host_file:
  file.append:
    - name: /etc/hosts
    - text:
      - {{ pillar['master_config']['master_ip'] }} master

mcrouter_install:
  pkg.installed:
    - allow_updates: True
    - skip_verify: True
    - pkgs:
      - memcached: {{ app_version['memcached'] }} 
      - libmemcached-tools: {{ app_version['libmemcached-tools'] }}

copy_conf_file:
  file.managed:
    - source: salt://configs/memcached.conf
    - name: /etc/memcached.conf

memcached:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file: /etc/memcached.conf

