mysql_config:
  node_selector:
    master: 
       Nnode01-mysql 
    master_ip:
       192.168.160.11
    slave:
      - Nnode02-mysql
      - Nnode03-mysql
      - Nnode04-mysql
  root_password:
     Nnode01-mysql: root
     Nnode02-mysql: root
     Nnode03-mysql: root
     Nnode04-mysql: root
  node_id:
     Nnode01-mysql: 1
     Nnode02-mysql: 2
     Nnode03-mysql: 3
     Nnode04-mysql: 4

  
