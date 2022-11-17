{%- set app_version = salt['pillar.get']('redis_app_version')%}
/tmp:
  file.directory:
    - mode: 1777

update_host_file:
  file.append:
    - name: /etc/hosts
    - text:
      - {{ pillar['master_config']['master_ip'] }} master

redis_install:
  pkg.installed:
    - allow_updates: True
    - skip_verify: True
    - pkgs:
      - redis-sentinel: {{ app_version['redis-sentinel'] }}
      - redis-server: {{ app_version['redis-server'] }}

/etc/redis/redis.conf:
  file.managed:
        - source: salt://configs/redis.conf
        - template: jinja

{%- set check = salt['cmd.shell']("python /opt/check_master_redis.py" ) %}
change_master_redis:
    file.replace:
    - name: /etc/redis/redis.conf
    - pattern: ^slaveof {{ pillar['redis_default_ip'] }} 6379
    - repl: slaveof {{ check }} 6379

redis:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file: /etc/redis/redis.conf

{% if salt['file.directory_exists' ]('/opt/redis-ok') != true  %}
copy_sentinel_conf_file:
  file.managed:
    - name: /etc/redis/sentinel.conf
    - source: salt://configs/sentinel.conf
{% endif %}

{%- set configs = salt['pillar.get']('sentinel_config')%}
{%- for config  in configs%}
{{ config | replace(" ", "_") }}:
    file.replace:
    - name: /etc/redis/sentinel.conf
    - pattern: ^{{ config }}.*
    - repl: {{config }} {{ configs[config] }}
    - append_if_not_found: True
{% endfor  %}

{%- set check = salt['cmd.shell']("python /opt/check_master_redis.py" ) %}
change_master_sentinel:
    file.replace:
    - name: /etc/redis/sentinel.conf
    - pattern: ^sentinel monitor mymaster {{ pillar['redis_default_ip']  }} 6379 2
    - repl: sentinel monitor mymaster {{ check }} 6379 2

{%- if pillar['delete_config'] !=  None %}
delete_master_sentinel:
    file.replace:
    - name: /etc/redis/sentinel.conf
    - pattern: ^{{ pillar['delete_config'] }}$
    - repl: "#{{ pillar['delete_config'] }}"
{% endif %}

redis-sentinel:
  service.running:
    - enable: True
    - restart: True
    - watch:
        -  file: /etc/redis/sentinel.conf

/opt/redis-ok:
  file.directory:
    - makedirs: True
