This includes code for running experiments on top of an implementation of Hsiao, Chung, Shen, and Chao, "Load Rebalancing for Distributed File Systems in Clouds" (IEEE Transcations on Parallel and Distributed Systems, May 2013) available from https://github.com/UVA-PCL/hadoop-cloud-rebalance .

These scripts were created by Zeitan Liu and Charles Reiss, under the supervision of Haiying Shen.

# Usage steps (for local testing)

These are instructions for performing single machine experiments, for debugging. In this
configuration all nodes will be located on localhost instead of actually being distributed.

1.  Produce a .tar.gz distribution of the modified version of hadoop using a command like

        mvn -DskipTests -Pnative,dist -Dtar package

    from the a checkout of the [modified Hadoop](https://github.com/UVA-PCL/hadoop-cloud-rebalance)
    repository. This will create a .tar.gz file named something like
    `hadoop-dist/target/hadoop-2.8.5.tar.gz`

2.  Modify `scripts/config.sh` so it sets
    *  `EXPERIMENT_NUM_DATANODES` to the number of datanodes to use
    *  `EXPERIMENT_HADOOP_TGZ` to point to the .tar.gz file created earlier
    *  `EXPERIMENT_DIRS[$i]` to point to unique local directory for each node number `$i` from 0 to 
       the number of datanodes to use

3.  Run `scripts/setup-local` to extract several copies of the hadoop archive and create the
    experiment directory.

    This uses configuration file templates in `hadoop-config-single-template`. Note
    that this assumes EXPERIMENT_DIRS[$i]/hadoop_tmp is the hadoop temporary directory.

    If you want to use another location you may need to modify `scripts/replace`.
    
4.  Then something like `scripts/small-experiment` from the experiment directory for node 0.
    Note that this script assumes 4 datanodes.

    This script does the following:
    *  generates an unbalanced load distribution by loading 2000 MB into a partial cluster,
       (only two datanodes running) then starting up the remaining two datanodes, then
       loading 1000MB onto the complete cluster.
    *  sends the start balancing command
    *  copies the namenode log file to log/ex1

    The namenode log will contain information useful for producing graphs of load balancer
    results.

# Usage steps (multi-node experiment)

For a multi-node experiment, modify `scripts/config.sh` to using the commented out
"example remote configuration". Place the modified hadoop directory
(extracted from the .tar.gz as in the local testing instructions above) 
in EXPERIMENT_DIR/hadoop on each machine, and modify etc/hadoop/core-site.xml and
etc/hadoop/hdfs-site.xml appropriately. Minimally, you will need to set fs.defaultFS.

Then, run an experiment using a script like `scripts/small-experiment`, possibly modifying
the script to use more datanodes.

In the original paper, some experiments were run with artificial load applied to the namenode.
You can generate similar load using the `scripts/loadgen` script, which you can run using
something like
    
    timeout 1500s ./loadgen 

# Script files

*  `replace`: deletes hadoop-tmp on all nodes
*  `start-namenode`, `start-dn`: start namenode or datanode on all nodes
*  `start-alldn X Y`: start datanode on node number X to Y inclusive. Scripts expect node number 0
    to be the namenode only and node numbers 1 through N to be datanodes.
*  `upload N`: upload an N megabyte file
*  `start-balancing`: trigger the balancer to start working; it will not run before this
*  `loadgen`: create and delete files rapidly on the master to create synthetic load. Runs until killed.


