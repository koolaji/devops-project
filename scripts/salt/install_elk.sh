salt 'Nnode01' state.sls  sls_files/install_nspawn 
salt 'Nnode01' state.sls  sls_files/create_container pillar='{"nodename":"Nnode01-elk"}'
salt 'Nnode01' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode01-elk"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode01-elk"}'
salt 'Nnode01' state.sls  sls_files/install_elk pillar='{"nodename":"Nnode01-elk"}'

salt 'Nnode02' state.sls  sls_files/install_nspawn 
salt 'Nnode02' state.sls  sls_files/create_container pillar='{"nodename":"Nnode02-elk"}'
salt 'Nnode02' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode02-elk"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode02-elk"}'
salt 'Nnode02' state.sls  sls_files/install_elk pillar='{"nodename":"Nnode02-elk"}'

salt 'Nnode03' state.sls  sls_files/install_nspawn 
salt 'Nnode03' state.sls  sls_files/create_container pillar='{"nodename":"Nnode03-elk"}'
salt 'Nnode03' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode03-elk"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode03-elk"}'
salt 'Nnode03' state.sls  sls_files/install_elk pillar='{"nodename":"Nnode03-elk"}'
