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
with open("abs.csv", "w") as file_abs, open("rate.csv", "w") as file_rate:
    while(1):
        # Interate Through Each PCP Disk IO Metric Desired
        dateStr = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        pminfoOutput = subprocess.check_output(['pminfo', '-f'] + pcpmetrics)
        deviceLines = pminfoOutput.split('\n')
        for x in range(0, len(pcpmetrics)):
            currSample[x] = int(deviceLines[2 + x*3][10:])

        if not firstread:
            file_abs.write(dateStr + ",")
            file_rate.write(dateStr + ",")
            for x in range(0, len(pcpmetrics)):
                file_abs.write(str(currSample[x]) + ",") 
                file_rate.write(str(currSample[x] - lastSample[x]) + ",") 
            file_abs.write("\n")
            file_abs.flush()
            file_rate.write("\n")
            file_rate.flush()

        lastSample = currSample
        time.sleep(samplingInterval)
        firstread = False
