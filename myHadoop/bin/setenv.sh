#!/bin/bash

# Set this to location of myHadoop 
export MY_HADOOP_HOME="/home/$USER/GoogleTrace/myHadoop"

# Set this to the location of the Hadoop installation
export HADOOP_PREFIX="/home/$USER/Softwares/hadoop-2.6.0"
export HADOOP_MAPRED_HOME=$HADOOP_PREFIX
export HADOOP_COMMON_HOME=$HADOOP_PREFIX
export HADOOP_HDFS_HOME=$HADOOP_PREFIX
export YARN_HOME=$HADOOP_PREFIX
export HADOOP_YARN_HOME=$YARN_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR="$HADOOP_PREFIX/lib/native"
export HADOOP_OPTS="-Djava.library.path=$HADOOP_PREFIX/lib"
export HADOOP_CONF_DIR="$MY_HADOOP_HOME/config"
export YARN_CONF_DIR=$HADOOP_CONF_DIR

# Set HIVE_HOME
export HIVE_HOME="/home/$USER/Softwares/apache-hive-1.2.1-bin"

export PATH=$HADOOP_PREFIX/bin:$HIVE_HOME/bin:$PATH

# Set this to the location you want to use for HDFS
# Note that this path should point to a LOCAL directory, and
# that the path should exist on all slave nodes
export HADOOP_DATA_DIR="/tmp/hadoop-$USER/data"

# Set this to the location where you want the Hadoop logfies
export HADOOP_LOG_DIR="/tmp/hadoop-$USER/log"

