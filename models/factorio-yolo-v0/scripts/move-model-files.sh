#!/usr/bin/env bash

model_repo_path=$1

if [ -z "$model_repo_path" ]; then
    echo "Usage: $0 <model-repo-path>"
    exit 1
fi

mv ./results/weights/best.pt $model_repo_path/best.pt
mv ./results/weights/best.onnx $model_repo_path/best.onnx
cp -f ./notebooks/notebook.ipynb $model_repo_path/notebook.ipynb
cp -f ./results/results.png $model_repo_path/results.png
cp -f ./results/val_batch0_pred.jpg $model_repo_path/val_batch0_pred.jpg
