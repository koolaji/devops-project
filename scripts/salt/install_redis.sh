salt 'Nnode01' state.sls  sls_files/install_nspawn 
salt 'Nnode01' state.sls  sls_files/create_container pillar='{"nodename":"Nnode01-redis"}'
salt 'Nnode01' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode01-redis"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode01-redis"}'
salt 'Nnode01' state.sls  sls_files/install_redis pillar='{"nodename":"Nnode01-redis"}'

salt 'Nnode02' state.sls  sls_files/install_nspawn 
salt 'Nnode02' state.sls  sls_files/create_container pillar='{"nodename":"Nnode02-redis"}'
salt 'Nnode02' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode02-redis"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode02-redis"}'
salt 'Nnode02' state.sls  sls_files/install_redis pillar='{"nodename":"Nnode02-redis"}'

salt 'Nnode03' state.sls  sls_files/install_nspawn 
salt 'Nnode03' state.sls  sls_files/create_container pillar='{"nodename":"Nnode03-redis"}'
salt 'Nnode03' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode03-redis"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode03-redis"}'
salt 'Nnode03' state.sls  sls_files/install_redis pillar='{"nodename":"Nnode03-redis"}'
