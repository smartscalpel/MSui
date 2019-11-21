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

if [ ! -d "${LIMP_STORAGE}/monetdb5" ]; then
  if [ ! $(mount "${LIMP_STORAGE}") ]; then
    echo "Failed to mount ${LIMP_STORAGE}"
    exit 1
  else
    do_rsync
  fi
else
  do_rsync
fi
echo "Archive moving is finished"
exit 0
