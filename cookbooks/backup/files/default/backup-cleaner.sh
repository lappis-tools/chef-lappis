#!/bin/bash
BKP_DIR_NOOSFERO=/var/backups/portal
BKP_DIR_CODESCHOOL=/var/backups/codeschool
BKP_DIR_UNBGAMES=/var/backups/unbgames
BKP_DIR_NOOSFERO_FS=/var/backups/portal_fs

#Apaga os backups com mais de 3 dias
cd $BKP_DIR_NOOSFERO
for i in `find $BKP_DIR_NOOSFERO/ -maxdepth 1 -type f -mtime +1 -print`; do rm -rf $i; done

cd $BKP_DIR_CODESCHOOL
for i in `find $BKP_DIR_CODESCHOOL/ -maxdepth 1 -type f -mtime +1 -print`; do rm -rf $i; done

cd $BKP_DIR_UNBGAMES
for i in `find $BKP_DIR_UNBGAMES/ -maxdepth 1 -type f -mtime +1 -print`; do rm -rf $i; done
