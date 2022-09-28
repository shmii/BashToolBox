#! /bin/bash

set -x
set -o pipefail
set -e

dirName=/app
echo "Entrez le Quadrigramme de votre application"
read option
    case $option in
        a)
            AAAA=$1
            ;;
        b)
            BBBB=$1
            ;;
        c)
            CCCC=$1
            ;;
        d)
            DDDD=$1
            ;;
        e)
            EEEE=$1
            ;;
        f)
            FFF=$1
            ;;
        g)
            GGGG=$1
            ;;
        h)
            HHHH=$1
            ;;
        i)
            IIII=$1
            ;;
        j)
            JJJJ=$1
            ;;
        k)
            KKKK=$1
            ;;
        l)
            LLLL=$1
            ;;

esac

###### recherche du repertoire cible ############################

datadir=$dirName/$option/data/mysql.d
LogErrorDir=$dirName/$option/log
TmpDir=$dirName/$option/tmp/mysqld.tmp.d
MariadbConfDir=/etc/my.cnf.d
sudo chmod 777 $datadir
sudo chmod 777 $LogErrorDir
sudo chmod 777 $TmpDir
cd $dirNameDir

if [ ! -d "$datadir" ]
    then
        echo "le reperoire cible est inexistant"
        exit 1
else
    echo "le repertoire cible existe, nous allons commencer la creation des dossiers de travail:"

    sudo mkdir -p $datadir/mysql

fi
[ ! -d $LogErrorDir ] && sudo mkdir -p $LogErrorDir/mariadb

[ ! -d $TmpDir ] && sudo mkdir -p $TmpDir


######### changer les parametres par defauts de mariadb ##########################

if [[ -d $MariadbConfDir ]]

    then
        sudo cp  ${MariadbConfDir}/mariadb-server.cnf ${MariadbConfDir}/mariadb-server.cnf.ori
	sudo cp /etc/my.cnf /etc/my.cnf.ori
       find ${MariadbConfDir}/mariadb-server.cnf -type f -exec sudo sed -i "s|/var/lib/mysql|${datadir}|g" {} \;
       find ${MariadbConfDir}/mariadb-server.cnf -type f -exec  sudo sed -i "s|/var/lib/mysql/mysql.sock|${datadir}/mysql/mysql.sock|g" {} \;
       find ${MariadbConfDir}/mariadb-server.cnf -type f -exec  sudo sed -i "s|/var/log/mariadb/mariadb.log|${LogErrorDir}/mariadb.log|g" {} \;
       find ${MariadbConfDir}/mariadb-server.cnf -type f -exec sudo sed -i  "/^pid-file=.*/a tmpdir=${TmpDir}\ninnodb_strict_mode=0" {} \;
       find /etc/my.cnf -type f -exec sudo sed -i "s/client-server/client/g" {} \;
       find /etc/my.cnf -type f  -exec sudo sed -i "/client/a port=3306\nsocket=$datadir/mysql/mysql.sock" {} \;

fi
################ configuration du selinux ######################################

sudo cp -Rp /var/lib/mysql/* $datadir
find ${TmpDir} -type d -exec sudo chown mysql:mysql {} \;
sudo find ${datadir}/mysql -type d -exec sudo chown mysql:mysql {} \;
find ${TmpDir} -type d -exec sudo chmod 755 {} \;

sudo semanage fcontext -a  -e /var/log/mariadb ${LogErrorDir}
sudo semanage fcontext -a  -e /var/lib/mysql ${datadir}
sudo restorecon -vvRF ${LogErrorDir}
sudo restorecon -vvRF ${datadir}
sudo semanage fcontext -a -t mysqld_db_t "${datadir}"
sudo restorecon -v "$datadir"
sudo semanage fcontext -a -t mysqld_log_t "$LogErrorDir"
sudo restorecon -v "$LogErrorDir"
exit 0;
