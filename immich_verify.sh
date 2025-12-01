#!/bin/bash
# Immich Storage Verification Script
# Checks file counts and sizes between old and new Immich storage.
# Author: Community contribution

OLD_POOL="/mnt/lake/media/photo"
NEW_POOL="/mnt/lake/media/immich"

check_dir () {
  local src=$1
  local dst=$2

  local count_src=$(find "$src" -type f | wc -l)
  local count_dst=$(find "$dst" -type f | wc -l)

  local size_src=$(du -sb "$src" | awk '{print $1}')
  local size_dst=$(du -sb "$dst" | awk '{print $1}')

  local size_src_h=$(du -sh "$src" | awk '{print $1}')
  local size_dst_h=$(du -sh "$dst" | awk '{print $1}')

  echo "Checking $src → $dst"
  echo "  Old count: $count_src   |   New count: $count_dst"
  echo "  Old size : $size_src_h  |   New size : $size_dst_h"

  if [ "$count_src" -eq "$count_dst" ] && [ "$size_src" -eq "$size_dst" ]; then
    echo "  ✅ OK (counts and sizes match)"
  else
    echo "  ⚠️ WARNING: mismatch detected!"
  fi
  echo
}

check_dir ${OLD_POOL}/uploads   ${NEW_POOL}/data/upload
check_dir ${OLD_POOL}/thumbs    ${NEW_POOL}/data/thumbs
check_dir ${OLD_POOL}/library   ${NEW_POOL}/data/library
check_dir ${OLD_POOL}/profile   ${NEW_POOL}/data/profile
check_dir ${OLD_POOL}/backups   ${NEW_POOL}/data/backups
check_dir ${OLD_POOL}/video     ${NEW_POOL}/data/encoded-video
check_dir ${OLD_POOL}/pgData    ${NEW_POOL}/postgres-data

if [ -d "${OLD_POOL}/pgBackup" ]; then
  check_dir ${OLD_POOL}/pgBackup ${NEW_POOL}/postgres-backup
fi

echo ">>> Verification complete. Check warnings above."
