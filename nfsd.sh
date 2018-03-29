#!/bin/bash

trap "stop; exit 0;" SIGTERM SIGINT 
stop()
{
  echo "SIGTERM caught, terminating NFS process(es)..."
  /usr/sbin/exportfs -ua 
  pid1=$(pidof rpc.nfsd)
  pid2=$(pidof rpc.mountd)
  kill -TERM $pid1 $pid2 > /dev/null 2>&1
  echo "Terminated."
  exit
}

while true; do
  pid=$(pidof rpc.mountd)
  while [ -z "$pid" ]; do
    echo "Displaying /etc/exports contents..."
    cat /etc/exports
    echo ""

    #echo "Starting rpcbind..."
    #/sbin/rpcbind -w
    #echo "Displaying rpcbind status..."
    #/sbin/rpcinfo
    #/usr/sbin/rpc.idmapd
    #/usr/sbin/rpc.gssd -v

    echo "Starting NFS in the background..."
    rpc.nfsd -d 8 -N 2 -N 3 -V 4 -U
    echo "Exporting File System..."
    /usr/sbin/exportfs -rv 
    
    echo "Starting Mountd in the background..."
    /usr/sbin/rpc.mountd -d all -N 2 -N 3 -V 4 -u

    pid=$(pidof rpc.mountd)
    if [ -z "$pid" ]; then
      echo "Startup of NFS failed, sleeping for 2s, then retrying..."
      sleep 2
    fi
  done
done

while true; do
  pid=$(pidof rpc.mountd)
  if [ -z "$pid" ]; then
    echo "NFS has failed, exiting, so Docker can restart the container..."
    break
  fi
  sleep 1
done
sleep 1
exit 1
