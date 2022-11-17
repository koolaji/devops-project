salt 'Nnode04' state.sls  sls_files/remove_container pillar='{"nodename":"Nnode04-mysql"}'
salt 'master' state.sls  sls_files/deactivate_minion pillar='{"nodename":"Nnode04-mysql"}'
