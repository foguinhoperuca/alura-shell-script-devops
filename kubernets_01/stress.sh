#!/bin/bash

# TODO use siage to stress it 
ADDRESS_SERVER=http://192.168.99.100:31595
for i in {1..100000}; do
  curl $ADDRESS_SERVER > output_stress/test.txt
  # In seconds. Pass something like 0.001 to really stress it
  sleep $1
done

