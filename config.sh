EXPERIMENT_DIR=$(realpath $(dirname $0)/..)
EXPERIMENT_TEMPLATE_DIR=$EXPERIMENT_DIR/templates
EXPERIMENT_LOG_DIR=$EXPERIMENT_DIR/log
EXPERIMENT_SCRIPT_DIR=$EXPERIMENT_DIR/scripts
EXPERIMENT_SSH="ssh -l zl4dc"
EXPERIMENT_MACHINES=(shen-51 shen-49 shen-47 shen-44 shen-43 shen-41 shen-39 shen-38 shen-37 shen-35 shen-33 shen-31 shen-29 shen-27 shen-25 shen-24 shen-23 shen-19 shen-18 shen-17 shen-15 shen-14 shen-13 shen-11 shen-9)
EXPERIMENT_CHORD_SRC=XXX # FIXME

EXPERIMNET_NODE_COUNTS=(10 10 10 10 9 9 9 9 7 7 7 7 4 4 4 4 1 1 1 1)
