#!/bin/bash

export job_name="build-hadoop-cluster"

. /home/$USER/myHadoop-palmetto/bin/setenv.sh

#### Set this to the directory where Hadoop configs should be generated
# Don't change the name of this variable (HADOOP_CONF_DIR) as it is
# required by Hadoop - all config files will be picked up from here
#
# Make sure that this is accessible to all nodes
export HADOOP_CONF_DIR="$MY_HADOOP_HOME/config/$PBS_JOBID"

#### Set up the configuration
# Make sure number of nodes is the same as what you have requested from PBS
# usage: $MY_HADOOP_HOME/bin/pbs-configure.sh -h
echo "Set up the configurations for myHadoop"
# this is the non-persistent mode
$MY_HADOOP_HOME/bin/pbs-configure-interactive.sh -n 2 -c $HADOOP_CONF_DIR

# this is the persistent mode
# $MY_HADOOP_HOME/bin/pbs-configure.sh -n 4 -c $HADOOP_CONF_DIR -p -d /oasis/cloudstor-group/HDFS
echo

#### Stop the Hadoop cluster
        echo "Stop all Hadoop daemons"
        $HADOOP_PREFIX/bin/stop-all.sh --config $HADOOP_CONF_DIR
        echo


#number of iterations and delay
#### Format HDFS, if this is the first time or not a persistent instance
	echo "Format HDFS"
	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR namenode -format
	echo
#### Start the Hadoop cluster
	echo "Start all Hadoop daemons"
	$HADOOP_PREFIX/bin/start-all.sh --config $HADOOP_CONF_DIR
	#$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave
	echo

#### Run your jobs here
	echo "Run some test Hadoop jobs"
#copy files to HDFS
	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -mkdir /user/$USER/Data


export node_file="/home/$USER/node_file"
PBS_NODES=`awk 'END { print NR }' $node_file`

#for ((j=1; j<=$PBS_NODES; j++))
#do
 #   node=`awk 'NR=='"$j"'{print;exit}' $node_file`
  #  echo "copy data to $node"   
   # cmd="$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -copyFromLocal /newscratch/user/zhuozhl/Data/$i/lda_wiki1w_{$((($j-1)*896/5+1))..$(($j*896/5))} /user/zhuozhl/Data"
    #echo $cmd
   # fi
    #ssh $node $cmd 
#done

#sleep $(($i*1))
	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -copyFromLocal /newscratch/user/$USER/Data/$i/lda* /user/$USER/Data
	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -lsr /
	echo
#create usage monitoring directories

#start the monitor program at backgroud
#PBS_NODES=`awk 'END { print NR }' $PBS_NODEFILE`


#run wordcount jobs
	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR jar $HADOOP_PREFIX/hadoop-examples-1.2.1.jar wordcount /user/${USER}/Data/ /user/${USER}/Outputs-wordcount

#kill backgroud monitor program

#copy hadoop logs to local directory
	$HADOOP_PREFIX/bin/hadoop fs -copyToLocal /user/${USER}/Outputs-wordcount/* /home/$USER/result-inter
#remove all the data
	$HADOOP_PREFIX/bin/hadoop fs -rmr /user/${USER}/*
	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -lsr /
	echo

#### Stop the Hadoop cluster
	echo "Stop all Hadoop daemons"
	$HADOOP_PREFIX/bin/stop-all.sh --config $HADOOP_CONF_DIR
	echo
	
	sleep 15

#### Clean up the working directories after job completion
