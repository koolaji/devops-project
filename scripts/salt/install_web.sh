salt 'Nnode04' state.sls  sls_files/install_nspawn 
salt 'Nnode04' state.sls  sls_files/create_container pillar='{"nodename":"Nnode04-web"}'
salt 'Nnode04' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode04-web"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode04-web"}'
salt 'Nnode04' state.sls  sls_files/install_web pillar='{"nodename":"Nnode04-web"}'
