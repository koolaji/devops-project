salt 'Nnode01' state.sls  sls_files/install_nspawn 
salt 'Nnode01' state.sls  sls_files/create_container pillar='{"nodename":"Nnode01-mysql"}'
salt 'Nnode01' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode01-mysql"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode01-mysql"}'
salt 'Nnode01' state.sls  sls_files/install_mysql pillar='{"nodename":"Nnode01-mysql"}'

salt 'Nnode02' state.sls  sls_files/install_nspawn 
salt 'Nnode02' state.sls  sls_files/create_container pillar='{"nodename":"Nnode02-mysql"}'
salt 'Nnode02' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode02-mysql"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode02-mysql"}'
salt 'Nnode02' state.sls  sls_files/install_mysql pillar='{"nodename":"Nnode02-mysql"}'

salt 'Nnode03' state.sls  sls_files/install_nspawn 
salt 'Nnode03' state.sls  sls_files/create_container pillar='{"nodename":"Nnode03-mysql"}'
salt 'Nnode03' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode03-mysql"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode03-mysql"}'
salt 'Nnode03' state.sls  sls_files/install_mysql pillar='{"nodename":"Nnode03-mysql"}'
