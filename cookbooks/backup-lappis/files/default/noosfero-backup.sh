#!/bin/bash
BKP_DIR_NOOSFERO=/var/backups/portal

#Apaga os backups com mais de 3 dias
cd $BKP_DIR_NOOSFERO
for i in `find $BKP_DIR_NOOSFERO/ -maxdepth 1 -type d -mtime +3 -print`; do rm -rf $i; done

