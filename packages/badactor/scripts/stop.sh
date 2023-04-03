#!/bin/bash

if [ -f process_pid.txt ]; then
	PID=$(cat process_pid.txt)
	kill -9 $PID
	rm process_pid.txt
	echo "Proceso detenido, pid: $PID."
else
	echo 'Nada para detener.'
fi