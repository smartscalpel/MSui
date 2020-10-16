#!/bin/bash

echo "Move archives is started"

TARGET_DIR=/var/workspaceR/scalpelData/archive/loaded_data
FOLDER_TO_MONITOR=( Burdenko Neurosurgery )
LIMP_STORAGE=/mnt/limpstorage

wd=$(pwd)

do_rsync() {
  echo "Synchronization of DataBase backup"
  rsync -avhcEt --remove-source-files --include="msinvent.*.tar" --include="msinvent.*.tar.gz" --exclude="*" "$wd/" "$LIMP_STORAGE/monetdb5"
}

if [ "$1" = "monthly" ]
then
  tar -cvjf /var/backups/monetdb/msinvent/monthly/$(date +%Y_%m_%d).tar.bz2 /var/backups/monetdb/msinvent/daily/
  if [ ! -d $LIMP_STORAGE/monetdb5 ]
  then
    echo "$LIMP_STORAGE is not mounted! We'll try to mount it"

    mount "${LIMP_STORAGE}"

    if [ $? -gt 0 ]
    then
	echo "Something goes wrong. Second try..."
        mount "${LIMP_STORAGE}"
    fi
  fi
  rsync -rltDvhcEt --remove-source-files --include="*.tar.bz2" --exclude="*" "/var/backups/monetdb/msinvent/monthly/" "$LIMP_STORAGE/monetdb5"
  
  echo "Moving monthly backup has been finished at $(date +%Y_%m_%d)"
  exit 0
fi

# shellcheck disable=SC2068
for m_dir in ${FOLDER_TO_MONITOR[@]}; do
  cur_target_dir=$TARGET_DIR/$m_dir
  cur_source_dir=$wd/$m_dir
  echo "Processing $cur_source_dir"
  if [ ! -d "${cur_target_dir}" ]; then
    if mkdir "$cur_target_dir"; then
      echo "Target directory ${cur_target_dir} was created"
    fi
  fi
  rsync -avhcEt --remove-source-files --include="*.tbz2" --exclude="*" "$cur_source_dir/" "$cur_target_dir"

done

rsync -avhcEt --remove-source-files --include="*.pdf" --exclude="*" "$wd/" "$TARGET_DIR"

echo "Archive moving is finished"
exit 0
