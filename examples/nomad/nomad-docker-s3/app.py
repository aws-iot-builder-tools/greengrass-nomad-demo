# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
import boto3
import os
import time


try:
    print("Creating boto3 S3 client...")
    s3 = boto3.client('s3')
    print("Successfully created boto3 S3 client")
except Exception as e:
    print("Failed to create boto3 s3 client. Error: " + str(e))
    exit(1)

while True:
    try:
        print("Listing S3 buckets...")
        response = s3.list_buckets()
        for bucket in response['Buckets']:
            print(f'\t{bucket["Name"]}')
        print("Successfully listed S3 buckets")
    except Exception as e:
        print("Failed to list S3 buckets. Error: " + str(e))
        exit(1)

    time.sleep(5)