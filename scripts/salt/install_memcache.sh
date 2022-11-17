salt 'Nnode01' state.sls  sls_files/install_nspawn 
salt 'Nnode01' state.sls  sls_files/create_container pillar='{"nodename":"Nnode01-memcache"}'
salt 'Nnode01' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode01-memcache"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode01-memcache"}'
salt 'Nnode01' state.sls  sls_files/install_memcache pillar='{"nodename":"Nnode01-memcache"}'

salt 'Nnode02' state.sls  sls_files/install_nspawn 
salt 'Nnode02' state.sls  sls_files/create_container pillar='{"nodename":"Nnode02-memcache"}'
salt 'Nnode02' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode02-memcache"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode02-memcache"}'
salt 'Nnode02' state.sls  sls_files/install_memcache pillar='{"nodename":"Nnode02-memcache"}'

salt 'Nnode03' state.sls  sls_files/install_nspawn 
salt 'Nnode03' state.sls  sls_files/create_container pillar='{"nodename":"Nnode03-memcache"}'
salt 'Nnode03' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode03-memcache"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode03-memcache"}'
salt 'Nnode03' state.sls  sls_files/install_memcache pillar='{"nodename":"Nnode03-memcache"}'
