#!/usr/bin/python

import os, re, time, sys
import datetime
import subprocess

samplingInterval = 1

pcpmetrics = [  "disk.all.read_bytes", 
                "disk.all.write_bytes", 
                "mem.vmstat.pgpgin", 
                "mem.vmstat.pgpgout", 
                "mem.vmstat.pgfault", 
                "mem.vmstat.pgmajfault", 
                "mem.vmstat.pgfree"]

lastSample = [0] * len(pcpmetrics)
currSample = [0] * len(pcpmetrics)

firstread = True
with open("machine_stats.csv", "w") as statsfile:
    while(1):
        # Interate Through Each PCP Disk IO Metric Desired
        dateStr = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        pminfoOutput = subprocess.check_output(['pminfo', '-f'] + pcpmetrics)
        deviceLines = pminfoOutput.split('\n')
        for x in range(0, len(pcpmetrics)):
            currSample[x] = int(deviceLines[2 + x*3][10:])

        if not firstread:
            statsfile.write(dateStr + ",")
            for x in range(0, len(pcpmetrics)-1):
                statsfile.write(str(currSample[x]) + ",") 
                statsfile.write(str(currSample[x] - lastSample[x]) + ",") 
            statsfile.write(str(currSample[len(pcpmetrics)-1]) + ",") 
            statsfile.write(str(currSample[len(pcpmetrics)-1] - lastSample[len(pcpmetrics)-1]) + '\n') 
            statsfile.flush()
        
        for x in range(0, len(pcpmetrics)):
            lastSample[x] = currSample[x]
        time.sleep(samplingInterval)
        firstread = False
