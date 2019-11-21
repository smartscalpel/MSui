#!/bin/bash

check_exit_code() {
  code=$1
  if [ $code != 0 ]; then
    echo "last command code = $code. Stopping now..."
    trap 'rm -rf "$lockdir"' 0
    exit $code
  fi  
}

timestamp() {
  date +"%Y_%m_%d_%H_%M"
}

R_HOME_DIR=/usr/local/lib/R
cur_time_stamp=$(timestamp)
wd=`pwd`
dbdir=/var/workspaceR/dataloading

echo "started at $(timestamp)"

echo $dbdir
cd $dbdir
echo $PWD
lockdir=$dbdir/dbUpdate.lock
if mkdir "$lockdir"
  then
    echo >&2 "successfully acquired lock"
    # Optionally create temporary files in this directory, because
    # they will be removed automatically:
    tmpPrep=$lockdir/dbprep
    tmpLoad=$lockdir/dbload
    tmpClean=$lockdir/dbclean
    cd "$dbdir/Burdenko" 
    touch $tmpPrep
    ./prep4db.R >> dbprep.out 2>&1
    check_exit_code $?
    touch $tmpLoad
    ./load2db.R >> dbload.out 2>&1
    touch $tmpClean
    ./cleanAfter.R >> dbclean.out 2>&1
    check_exit_code $?
    cd "$dbdir/Neurosurgery"
    touch $tmpPrep
    ./prep4db.R >> dbprep.out 2>&1
    check_exit_code $?
    touch $tmpLoad
    ./load2db.R >> dbload.out 2>&1
    touch $tmpClean
    ./cleanAfter.R >> dbclean.out 2>&1
    check_exit_code $?
    cd $dbdir
    ./makeReport.R >> dbreport.out 2>&1
    # Remove lockdir when the script finishes, or when it receives a signal
    trap 'rm -rf "$lockdir"' 0    # remove directory when script finishes
    sudo -u monetdb monetdb lock msinvent
    tar cvf msinvent.$cur_time_stamp.backup.tar /var/monetdb5/dbfarm/msinvent
    sudo -u monetdb monetdb release msinvent
    gzip msinvent.$cur_time_stamp.backup.tar
    check_exit_code $?
    ./move_archives.sh >> move_archives.out 2>&1
    ./send_report.R >> send.out 2>&1
  else
    echo >&2 "cannot acquire lock, giving up on $lockdir"
    exit 0
fi
cd $wd
echo "finished at $(timestamp)"
