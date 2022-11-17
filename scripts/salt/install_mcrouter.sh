salt 'Nnode04' state.sls  sls_files/install_nspawn 
salt 'Nnode04' state.sls  sls_files/create_container pillar='{"nodename":"Nnode04-mcrouter"}'
salt 'Nnode04' state.sls  sls_files/active_saltminion pillar='{"nodename":"Nnode04-mcrouter"}'
salt 'master' state.sls  sls_files/accept_key pillar='{"nodename":"Nnode04-mcrouter"}'
salt 'Nnode04' state.sls  sls_files/install_mcrouter pillar='{"nodename":"Nnode04-mcrouter"}'
