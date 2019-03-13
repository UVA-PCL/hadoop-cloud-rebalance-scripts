## set $EXPERIMENT_DIR to be the parent directory of this file
EXPERIMENT_DIR=$(realpath $(dirname ${BASH_SOURCE[0]})/..)

declare -a EXPERIMENT_DIRS EXPERIMENT_MACHINES EXPERIMENT_IDS

## JAVA_HOME for Hadoop; might be omitted if already set 
## in your environment or hadoop-env.sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

## set to number of datanodes
EXPERIMENT_NUM_DATANODES=4
## ssh command to use
EXPERIMENT_SSH="ssh"
## directory for logs and experiment results
EXPERIMENT_LOG_DIR=$EXPERIMENT_DIR/log
## directory for these scripts
EXPERIMENT_SCRIPT_DIR=$EXPERIMENT_DIR/scripts
## directory where extracted hadoop .tar.gz is (only used by setup-local script)
EXPERIMENT_HADOOP_TGZ=$EXPERIMENT_DIR/hadoop-2.4.5.tar.gz
## directory created by extracting $EXPERIMENT_HADOOP_TGZ
EXPERIMENT_HADOOP_TGZ_DIR=hadoop-2.4.5

## probably do not modify this loop
for i in $(seq 0 $EXPERIMENT_DATANODES); do
    EXPERIMENT_IDS[$i]=$i
done

####### example local-only configuration ########

## EXPERIMENT_DIRS[i] is the base directory for node i
## node 0 is always the namenode
## node 1-N are datanodes
for i in ${EXPERIMENT_IDS[@]}; do
    EXPERIMENT_DIRS[$i]=/localtmp/balancing-local/node-$i
    EXPERIMENT_MACHINES[$i]=localhost
done
## port 22222 matches balancer.nameNodePort in hdfs-site.xml
EXPERIMENT_CHORD_HOSTS=(localhost:22222)
for i in $(seq 1 $EXPERIMENT_NUM_DATANODES); do
    ## port 23333 matches balancer.firstDataNodePort in hdfs-site.xml
    ## 2 matches balancer.dataNodePortIncrement in hdfs-site.xml
    EXPERIMENT_CHORD_HOSTS[$i]="localhost:$((23333 + ($i - 1) * 2))"
done

###### example remote configuration (disabled) ######

## EXPERIMENT_DIRS[i] is the base directory of node i
## here, assume all node have same directory for experimental stuff
#for i in ${EXPERIMENT_IDS[@]}; do
#   EXPERIMENT_DIRS[$i]=/localtmp/balancing-local
#done
#EXPERIMENT_MACHINES=(cluster-1 cluster-2 cluster-3 cluster-4 cluster-5)
## port 22222 matches balancer.nameNodePort in hdfs-site.xml (the default)
## port 23333 matches balancer.firstDataNodePort in hdfs-site.xml
## for multi-host experiments balancer.dataNodePortIncrement in hdfs-site.xml should be 0
#EXPERIMENT_CHORD_HOSTS=(cluster-1:22222 cluster-2:23333 cluster-3:23333 cluster-4:23333 cluster-5:23333)

ssh_into_id() {
    local i=$1
    shift
    $EXPERIMENT_SSH ${EXPERIMENT_MACHINES[$i]} ". ${EXPERIMENT_DIRS[$i]-$EXPERIMENT_DIR}/scripts/config.sh; ${@}" 
}
