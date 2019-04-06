#!/bin/bash

#./upload-distributed-torcdb-image-files.sh 4servers.txt /local/rcbackup/remote/ldbc-snb/ldbc_snb_sf0001/torcdb_ramcloud_image_files/tablets-4/ $(rccoordip rc16) ~/RAMCloudUtils/
./upload-distributed-torcdb-image-files.sh 8servers.txt /local/rcbackup/remote/ldbc-snb/ldbc_snb_sf0100/torcdb_ramcloud_image_files/tablets-8/ $(rccoordip rc16) ~/RAMCloudUtils/
