#!/bin/bash

nohup ./badactor.cjs >> "$(date +'%F').log" 2>&1 & disown
echo $! > process_pid.txt
echo "Ejecutando process con pid: $(cat process_pid.txt)."