# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
import json
import time
import os

import awsiot.greengrasscoreipc
import awsiot.greengrasscoreipc.model as model


NOMAD_SHORT_ALLOC_ID = os.getenv('NOMAD_SHORT_ALLOC_ID')

def get_used_mem():
    with open('/proc/meminfo', 'r') as f:
        for line in f:
            if line.startswith('MemTotal:'):
                total_mem = int(line.split()[1]) * 1024  # convert to bytes
            elif line.startswith('MemAvailable:'):
                available_mem = int(line.split()[1]) * 1024  # convert to bytes
                break

    return total_mem - available_mem

def get_cpu_usage():
    with open('/proc/stat', 'r') as f:
        line = f.readline()
        cpu_time = sum(map(int, line.split()[1:]))
        idle_time = int(line.split()[4])

    return (cpu_time - idle_time) / cpu_time

if __name__ == '__main__':
    ipc_client = awsiot.greengrasscoreipc.connect()

    while True:
        telemetry_data = {
            "timestamp": int(round(time.time() * 1000)),
            "used_memory": get_used_mem(),
            "cpu_usage": get_cpu_usage()
        }

        op = ipc_client.new_publish_to_iot_core()
        op.activate(model.PublishToIoTCoreRequest(
            topic_name=f"{NOMAD_SHORT_ALLOC_ID}/iot/telemetry",
            qos=model.QOS.AT_LEAST_ONCE,
            payload=json.dumps(telemetry_data).encode(),
        ))
        try:
            result = op.get_response().result(timeout=5.0)
            print("successfully published message:", result)
        except Exception as e:
            print("failed to publish message:", e)

        time.sleep(5)