#!/usr/bin/env bash

dataset_repo_path=$1

if [ -z "$dataset_repo_path" ]; then
    echo "Usage: $0 <dataset-repo-path>"
    exit 1
fi

rm -rf $dataset_repo_path/detect.yaml
rm -rf $dataset_repo_path/images
rm -rf $dataset_repo_path/labels

mv dataset/detect.yaml $dataset_repo_path/detect.yaml
mv dataset/images $dataset_repo_path/images
mv dataset/labels $dataset_repo_path/labels
