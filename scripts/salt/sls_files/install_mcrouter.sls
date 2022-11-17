{%- set app_version = salt['pillar.get']('mcrouter_app_version')%}
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
      - libevent-2.0-5: {{ app_version['libevent-2.0-5'] }}
      - libgflags2v5: {{ app_version['libgflags2v5'] }}
      - libgoogle-glog0v5: {{ app_version['libgoogle-glog0v5'] }}
      - libboost-context1.62.0: {{ app_version['libboost-context1.62.0'] }}
      - libboost-filesystem1.62.0: {{ app_version['libboost-filesystem1.62.0'] }}
      - libboost-program-options1.62.0: {{ app_version['libboost-program-options1.62.0'] }}
      - libboost-system1.62.0: {{ app_version['libboost-system1.62.0'] }}
      - libboost-regex1.62.0: {{ app_version['libboost-regex1.62.0'] }}
      - libboost-thread1.62.0: {{ app_version['libboost-thread1.62.0'] }}
      - libdouble-conversion1: {{ app_version['libdouble-conversion1'] }}
      - libsnappy-dev: {{ app_version['libsnappy-dev'] }}
      - libjemalloc-dev: {{ app_version['libjemalloc-dev'] }}


{% if  salt['file.directory_exists' ]( "/etc/mcrouter/config/" ) != true   %}

copy_mcrouter_deb_file:
  file.managed:
    - source: salt://files/mcrouter_0.38.00_amd64_all.deb
    - name: /opt/mcrouter_0.38.00_amd64_all.deb
    - makedirs: True

install_deb_mcrouter:
  cmd.run:
    - name: 'cd /opt/; dpkg -i mcrouter_0.38.00_amd64_all.deb && rm /opt/mcrouter_0.38.00_amd64_all.deb; ldconfig'

{% endif %}

copy_mcrouter_config_file:
  file.managed:
    - source: salt://configs/mcrouter.json
    - name: /etc/mcrouter/config/mcrouter.json
    - template: jinja

mcrouter:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file: /etc/mcrouter/config/mcrouter.json
