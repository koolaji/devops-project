redis_app_version: 
       redis-sentinel: 3:3.2.6-3+deb9u3
       redis-server: 3:3.2.6-3+deb9u3
redis_default_ip: 192.168.160.11
redis_default_master: Nnode01-redis

sentinel_config:
        daemonize: "yes"
        pidfile: "\"/var/run/redis/redis-sentinel.pid\""
        logfile: "\"/var/log/redis/redis-sentinel.log\""
        bind: "0.0.0.0"
        port: 26379
        dir: "\"/var/lib/redis\""
        "sentinel monitor mymaster": "192.168.160.11 6379 2"
        "sentinel down-after-milliseconds": "mymaster 5000"
        "sentinel auth-pass": "mymaster 123456"
        "sentinel config-epoch": "mymaster 0"
        "sentinel leader-epoch": "mymaster 0"
        "sentinel current-epoch": 0
        "sentinel failover-timeout": "mymaster 60001"
delete_config:
