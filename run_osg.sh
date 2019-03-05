#!/bin/csh

set script_start  = `date`

echo " ==== PWD"
pwd

echo " ==== ./"
ls -lhrt ./

echo " ==== /etc/profile.d/"
ls -lhrt /etc/profile.d/

echo " ==== ENV"
env

set ClusterId = ` awk -F '=' '/^ClusterId/ {print $2}' $PWD/.job.ad`
echo ClusterId $ClusterId


set ProcId = ` awk -F '=' '/^ProcId/ {print $2}' $PWD/.job.ad`
echo ProcId $ProcId

mkdir out_dir$ClusterId

# using official gcard
rm -f gemc.log
gemc -USE_GUI=0 -N=100 -BEAM_P="e-, 4*GeV, 20*deg, 5*deg" /jlab/work/clas12.gcard > gemc.log

echo after gemc
ls -l
echo

rm -f e2h.log
evio2hipo -r 11 -t -1.0 -s -1.0 -i out.ev -o gemc.hipo > e2h.log

echo after evio2hipo
ls -l
echo

notsouseful-util -i gemc.hipo -o out_gemc.hipo -c 2

echo after cooking
ls -l
echo


# final job log
printf "Job finished time: "; /bin/date
