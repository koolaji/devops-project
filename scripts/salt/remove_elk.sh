
salt 'Nnode04' state.sls  sls_files/remove_container pillar='{"nodename":"Nnode04-elk"}'
salt 'master' state.sls  sls_files/deactivate_minion pillar='{"nodename":"Nnode04-elk"}'
salt 'Nnode01-elk' state.sls  sls_files/install_elk
salt 'Nnode02-elk' state.sls  sls_files/install_elk
salt 'Nnode03-elk' state.sls  sls_files/install_elk
