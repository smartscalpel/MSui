#!/bin/bash
 lockdir=./dbUpdate.lock
 if mkdir "$lockdir"
 then
     echo >&2 "successfully acquired lock"
     # Optionally create temporary files in this directory, because
     # they will be removed automatically:
     tmpPrep=$lockdir/dbprep
     tmpLoad=$lockdir/dbload
     tmpClean=$lockdir/dbclean
     
     touch $tmpPrep
     ./prep4db.R >& dbprep.out
    touch $tmpLoad
     ./load2db.R >& dbload.out
     touch $tmpClean
     ./cleanAfter.R >& dbclean.out
     # Remove lockdir when the script finishes, or when it receives a signal
     trap 'rm -rf "$lockdir"' 0    # remove directory when script finishes


 else
     echo >&2 "cannot acquire lock, giving up on $lockdir"
     exit 0
 fi
