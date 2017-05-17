#!/usr/bin/env bash
echo "########################################################################"
echo "######          single process training script"
echo "######  usage: cd ytk-learn & sh bin/local_optimizer.sh"
echo "######  attention : '???' means the value must be filled by user himself"
echo "#########################################################################"

# thread number
thread_num=10

# use current machine as master
master_host=$(hostname)

# if you run more than one training tasks on the same host at the same time,
# different tasks must have different ports!
master_port=???
echo "master host:${master_host}, master port:${master_port}"

# model name(linear, fm, ffm, gbdt, gbmlr, gbsdt, gbhmlr, gbhsdt, multiclass_linear)
model_name=???
echo "model name:${model_name}"

# model config
properties_path="config/model/${model_name}.conf"
echo "config:${properties_path}"

# train/test line python transform switch & script
transform="false"
transform_script_path="bin/transform.py"

echo "kill old task..."
kill $(cat master_${master_port}.pid)
kill $(cat slave_${master_port}.pid)

# start ytk-mp4j master, application pid will be saved in master_${master_port}.pid file,
# default max memory is 1000m, master log saved in log/master.log
echo "start master..."
nohup java -server -Xmx1000m -classpath .:lib/*:config -Dlog4j.configuration=file:config/log4j_master.properties com.fenbi.mp4j.comm.CommMaster 1 "${master_port}" >> log/master.log 2>&1 & echo $! > master_${master_port}.pid

# start local train worker, application pid will be saved in slave_${master_port}.pid,
# defaul max memory is 60000m, slave log slaved in log/slave.log
echo "start slave..."
nohup java -server -Xmx60000m -XX:-OmitStackTraceInFastThrow -classpath .:lib/*:config -Dlog4j.configuration=file:config/log4j_slave.properties com.fenbi.ytklearn.worker.LocalTrainWorker  \
    "${model_name}" "${properties_path}" "${transform_script_path}" "${transform}" user "${master_host}" "${master_port}" "${thread_num}" >> log/slave.log 2>&1 & echo $! > slave_${master_port}.pid




