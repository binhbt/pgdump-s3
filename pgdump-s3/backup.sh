#!/usr/bin/env sh

PGDUMP_CMD=`python /usr/local/bin/pguri`
BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"

# Run backup
eval $PGDUMP_CMD
# Compress backup
cd /backup/ && tar -cvzf "${BACKUP_NAME}" latest.dump
# Upload backup
aws s3 cp "/backup/${BACKUP_NAME}" "s3://${S3_BUCKET}/${DUMP_OBJECT_PREFIX}${BACKUP_NAME}"
# Delete temp files
# rm -rf /backup/latest.dump
rm -rf /backup/*

echo "${BACKUP_NAME}" >> /bk/log.txt

#Create tmp file in bk
echo "s3://${S3_BUCKET}/${DUMP_OBJECT_PREFIX}${BACKUP_NAME}" >> "/bk/${BACKUP_NAME}"

# Delete backup files local
# if [ -n "${MAX_BACKUPS}" ]; then
#   while [ $(ls /backup -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
#   do
#     BACKUP_TO_BE_DELETED=$(ls /backup -w 1 | sort | head -n 1)
#     rm -rf /backup/${BACKUP_TO_BE_DELETED}
#   done
# else
#   rm -rf /backup/*
# fi

# Delete backup files on tmp and S3
if [ -n "${MAX_BACKUPS}" ]; then
  while [ $(ls /bk -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
  do
    BACKUP_TO_BE_DELETED=$(ls /bk -w 1 | sort | head -n 1)
    aws s3 rm $(cat "/bk/${BACKUP_TO_BE_DELETED}") 
    rm -rf /bk/${BACKUP_TO_BE_DELETED}
  done
else
  rm -rf /bk/*
fi
