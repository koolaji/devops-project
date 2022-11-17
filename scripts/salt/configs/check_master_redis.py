#!/usr/bin/env python
import sys
import telnetlib
import time
def run_telnet_session(host):
 port = 26379
 session = telnetlib.Telnet(host,port)
 session.write(b"sentinel get-master-addr-by-name mymaster\n")
 time.sleep(1)
 session.write(b"quit\n")
 data=session.read_very_eager()
 for result in data.decode('ascii').splitlines():
     if str(result).startswith('192.168'): 
         print(result)
if __name__ == '__main__':
 ip_list=['192.168.160.11','192.168.160.12','192.168.160.13']
 for ip in ip_list: 
   ip_address=''
   try:
    ip_address=run_telnet_session(ip)
    break
   except :
       continue
 if (ip_address == ''  ) :
      print('192.168.160.11')

