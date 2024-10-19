#!/bin/bash


LOG_DIR=~/log
BACKUP_DIR=~/backup

MAX_PERCENTAGE=$2  
NUM_OLD_FILES=$3  

MAX_FOLDER_SIZE=$((1024 * 1024))  # 1 ГБ = 1024 * 1024 КБ = 1048576 


if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

LOG_DIR_SIZE=$(du -s "$LOG_DIR" | awk '{print $1}')

PERCENTAGE_USED=$(( LOG_DIR_SIZE * 100 / MAX_FOLDER_SIZE ))


echo "LOG_DIR_SIZE: $LOG_DIR_SIZE KB"
echo "MAX_FOLDER_SIZE: $MAX_FOLDER_SIZE KB"
echo "PERCENTAGE_USED: $PERCENTAGE_USED%"


if [ "$PERCENTAGE_USED" -gt "$MAX_PERCENTAGE" ]; then
    echo "Directory $LOG_DIR is more than $MAX_PERCENTAGE% full. Archiving old files..."


    FILES_TO_ARCHIVE=$(find "$LOG_DIR" -type f -printf '%T+ %p\n' | sort | head -n "$NUM_OLD_FILES" | awk '{print $2}')

 
    ARCHIVE_NAME="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$ARCHIVE_NAME" $FILES_TO_ARCHIVE > /dev/null 2>&1

    for FILE in $FILES_TO_ARCHIVE; do
        rm "$FILE"
    done

    echo "Archived files and cleaned up log directory."
else
    echo "Directory $LOG_DIR is less than $MAX_PERCENTAGE% full. No action required."
fi

