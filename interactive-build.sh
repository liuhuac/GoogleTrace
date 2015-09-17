#!/bin/bash

export job_name="GoogleTrace"

. myHadoop/bin/setenv.sh

#### Set this to the directory where Hadoop configs should be generated
# Don't change the name of this variable (HADOOP_CONF_DIR) as it is
# required by Hadoop - all config files will be picked up from here
#
# Make sure that this is accessible to all nodes
export HADOOP_CONF_DIR="$MY_HADOOP_HOME/config"

#### Set up the configuration
# Make sure number of nodes is the same as what you have requested from PBS
# usage: $MY_HADOOP_HOME/bin/pbs-configure.sh -h
echo "Set up the configurations for myHadoop"
# this is the non-persistent mode
$MY_HADOOP_HOME/bin/pbs-configure.sh -n 32 -c $HADOOP_CONF_DIR

# this is the persistent mode
# $MY_HADOOP_HOME/bin/pbs-configure.sh -n 4 -c $HADOOP_CONF_DIR -p -d /oasis/cloudstor-group/HDFS
echo

#### Stop the Hadoop cluster
echo "Stop all Hadoop daemons"
$HADOOP_PREFIX/sbin/stop-all.sh --config $HADOOP_CONF_DIR
echo


#number of iterations and delay
#### Format HDFS, if this is the first time or not a persistent instance
echo "Format HDFS"
$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR namenode -format
echo
#### Start the Hadoop cluster
echo "Start all Hadoop daemons"
$HADOOP_PREFIX/sbin/start-all.sh --config $HADOOP_CONF_DIR
#$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave
echo

#### Run your jobs here
#echo "Run some test Hadoop jobs"
#copy files to HDFS
$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -mkdir -p /user/$USER/Data


$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -copyFromLocal /home/$USER/clusterdata-2011-2/task_usage /user/$USER/Data
#	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -ls -R /
#	echo

#run wordcount jobs
#	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar wordcount /user/${USER}/Data/ /user/${USER}/Outputs-wordcount

#copy hadoop logs to local directory
#	$HADOOP_PREFIX/bin/hadoop fs -copyToLocal /user/${USER}/Outputs-wordcount/* /home/$USER/GoogleTrace/result-inter
#remove all the data
#	$HADOOP_PREFIX/bin/hadoop fs -rmr /user/${USER}/*
#	$HADOOP_PREFIX/bin/hadoop --config $HADOOP_CONF_DIR fs -lsr /
#	echo

#### Stop the Hadoop cluster
#	echo "Stop all Hadoop daemons"
#	$HADOOP_PREFIX/bin/stop-all.sh --config $HADOOP_CONF_DIR
#	echo

#### Clean up the working directories after job completion
