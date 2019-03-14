#!/usr/bin/python
###############################################################
# gmetric For Disk IO 
###############################################################
# REQs: pminfo, gmetric
# DATE: 21 December 2004
# (C)2004 DigiTar, All Rights  Reserved
###############################################################

import os, re, time

### Set Sampling Interval (in secs)
interval = 1

### Set PCP Config Parameters
cmdPminfo = "/usr/bin/pminfo -f "
reSimpleStat = re.compile(r'value (\d+)\n')	# RegEx To Compute Value

### Set Ganglia Config Parameters
### NOTE: To add a new PCP disk metric, add the appropriate entry to each dictionary item of gangliaMetrics
###       Each "vertical" column of the dictionary is a different metric entry group.
gangliaMetrics = { "pcpmetric": ["disk.all.read_bytes", "disk.all.write_bytes", "mem.vmstat.pgpgin", 	"mem.vmstat.pgpgout", 	"mem.vmstat.pgfault", 		"mem.vmstat.pgmajfault", 	"mem.vmstat.pgfree"], \
		   "name": 	["Disk\ Read\ Bytes",  	"Disk\ Write\ Bytes",   "Page\ Ins", 		"Page\ Outs", 		"Page\ Min+Maj\ Faults",	"Page\ Major\ Faults", 		"Page\ Frees"], \
		   "unit": 	["bytes/s", 		"bytes/s", 		"Pages/s", 		"Pages/s", 		"Faults/s",			"Faults/s",			"Frees/s"], \
	   	   "type": 	["uint32", 		"uint32", 		"uint32", 		"uint32", 		"uint32",			"uint32",			"uint32"]}
cmdGmetric = "/usr/bin/gmetric"

### Zero Sample Lists
lastSample = [0] * len(gangliaMetrics["pcpmetric"])
currSample = [0] * len(gangliaMetrics["pcpmetric"])

### Read PCP Metrics
while(1):
    # Interate Through Each PCP Disk IO Metric Desired
    for x in range(0, len(gangliaMetrics["pcpmetric"])):
        pminfoInput, pminfoOutput = os.popen2(cmdPminfo + gangliaMetrics["pcpmetric"][x], 't')
        deviceLines = pminfoOutput.readlines()
        pminfoInput.close()
        pminfoOutput.close()

	result = reSimpleStat.search(deviceLines[2])
	if (result):
	    currSample[x] = int(result.group(1))
	    cmdExec = cmdGmetric + \
			" --name=" + gangliaMetrics["name"][x] + \
			" --value=" + str((currSample[x] - lastSample[x])) + \
			" --type=" + gangliaMetrics["type"][x] + \
			" --units=\"" + gangliaMetrics["unit"][x] + "\""
	    gmetricResult = os.system(cmdExec)
	    lastSample[x] = currSample[x]

    time.sleep(interval)
