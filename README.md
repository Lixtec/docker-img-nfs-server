# docker-img-nfs-server

Ce dépôt contient une image de server nfs version 4 pour docker basé sur alpine.

Cette image repose sur:
- [Alpine Linux](http://www.alpinelinux.org/) v3.7.0. Alpine Linux is a security-oriented, lightweight Linux distribution based on [musl libc](https://www.musl-libc.org/) (v1.1.18) and [BusyBox](https://www.busybox.net/).
- NFS v4 only, over TCP on port 2049. Rpcbind is enabled.

The /etc/exports file contains these parameters:

`*(rw,fsid=0,async,no_subtree_check,no_auth_nlm,insecure,no_root_squash)`


## How to run
`docker run -d --name nfs-server --privileged -v /some/where/fileshare:/share  lixtec/nfs-server:latest`

Ajouter `--net=host` or `-p 2049:2049` pour vous assurer que le partage soit effectif depuis l'hote. 

## How to mount
A cause du paramètre `fsid=0` dans le fichier **/etc/exports file**, il ne faut pas mettre le nom du répertoire dans quand vous montez le répertoire.

`sudo mount -v 10.42.112.1:/ /mnt/ici`

## How to unmount

`sudo umount /some/where/here`
