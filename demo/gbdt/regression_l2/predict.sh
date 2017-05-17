#!/usr/bin/env bash

# make sure you are in path "ytk-learn"
# cd ../../..

# model name(linear, fm, ffm, gbdt, gbmlr, gbsdt, gbhmlr, gbhsdt)
model_name=gbdt

config_path="demo/gbdt/regression_l2/local_gbdt.conf"

# data file for predicting
file_dir="demo/data/libsvm/machine.test.libsvm"

# train/test line python transform switch & script
transform="true"
transform_script_path="demo/gbdt/regression_l2/transform.py"

# result save mode: PREDICT_RESULT_ONLY, LABEL_AND_PREDICT, PREDICT_AS_FEATURE
resultSaveMode="LABEL_AND_PREDICT"
resultFileSuffix="_"${model_name}"_"${resultSaveMode}

# max error data format tolerate number
max_error_tol=0
eval_metric="mae,rmse"
# value or leafid
predict_type="value"

nohup java -server -Xmx1000m -XX:-OmitStackTraceInFastThrow -classpath .:lib/*:config -Dlog4j.configuration=file:config/log4j.properties com.fenbi.ytklearn.predictor.Predicts  \
    "${config_path}" "${model_name}" "${file_dir}" "${transform}" "${transform_script_path}" "${resultSaveMode}" "${resultFileSuffix}" "${max_error_tol}" "${eval_metric}" "${predict_type}" >> log/info.log 2>&1 &
wait