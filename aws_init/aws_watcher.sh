#!/bin/bash

output_file="status_instancias.txt"
status=$(aws ec2 describe-instance-status --query "InstanceStatuses[*].{ID:InstanceId,Status:InstanceState.Name}" --output text)
if [ $? -eq 0 ];
then
    echo "$status" > "$output_file"
    echo "Saved at $output_file"
else
    echo "Error to get info about instances"
fi
