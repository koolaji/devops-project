{%- set app_version = salt['pillar.get']('web_app_version')%}

/tmp:
  file.directory:
    - mode: 1777

update_host_file:
  file.append:
    - name: /etc/hosts
    - text:
      - {{ pillar['master_config']['master_ip'] }} master

nginx_install:
  pkg.installed:
    - allow_updates: True
    - skip_verify: True
    - pkgs:
        - nginx: {{ app_version['nginx'] }}
        - php-fpm: {{ app_version['php-fpm'] }}

php_install:
  pkg.installed:
    - allow_updates: True
    - skip_verify: True
    - pkgs:
        - php: {{ app_version['php'] }}

copy_conf_file:
  file.managed:
    - source: salt://configs/example.com.conf
    - name: /etc/nginx/conf.d/example.com.conf
    - makedirs: True

copy_php_file:
  file.managed:
    - source: salt://configs/test.php
    - name: /var/www/example.com/test.php
    - makedirs: True

restart_php_fpm:
  service.running:
    - name: php7.0-fpm
    - enable: True
    - reload: True

nginx_enable:
  service.running:
    - enable: True
    - reload: True
    - name: nginx

delete_default_file:
  file.absent:
     - name:  /etc/nginx/sites-enabled/default

nginx:
  service.running:
    - enable: True
    - restart: True
    - watch:
        - file: /etc/nginx/conf.d/example.com.conf
        - file: /var/www/example.com/test.php
