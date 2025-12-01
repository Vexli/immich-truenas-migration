#!/bin/bash
# Immich Storage Migration Script (TrueNAS SCALE)
# Author: Community contribution
# Usage: ./immich_migrate.sh
# Description:
#   Migrates Immich storage from old pool to new pool
#   preserving media and database files.

# Change these paths for your environment
OLD_POOL="/mnt/lake/media/photo"
NEW_POOL="/mnt/lake/media/immich"

echo ">>> Creating target directories..."
mkdir -p ${NEW_POOL}/data/{upload,thumbs,library,profile,backups,encoded-video}
mkdir -p ${NEW_POOL}/postgres-data

echo ">>> Syncing Immich media..."
rsync -avh --progress ${OLD_POOL}/uploads/   ${NEW_POOL}/data/upload/
rsync -avh --progress ${OLD_POOL}/thumbs/    ${NEW_POOL}/data/thumbs/
rsync -avh --progress ${OLD_POOL}/library/   ${NEW_POOL}/data/library/
rsync -avh --progress ${OLD_POOL}/profile/   ${NEW_POOL}/data/profile/
rsync -avh --progress ${OLD_POOL}/backups/   ${NEW_POOL}/data/backups/
rsync -avh --progress ${OLD_POOL}/video/     ${NEW_POOL}/data/encoded-video/

echo ">>> Syncing Postgres data..."
rsync -avh --progress ${OLD_POOL}/pgData/    ${NEW_POOL}/postgres-data/

if [ -d "${OLD_POOL}/pgBackup" ]; then
  echo ">>> Syncing Postgres backups..."
  mkdir -p ${NEW_POOL}/postgres-backup
  rsync -avh --progress ${OLD_POOL}/pgBackup/ ${NEW_POOL}/postgres-backup/
fi

echo ">>> Migration finished!"
echo "Run verify.sh to confirm integrity before redeploying Immich."
