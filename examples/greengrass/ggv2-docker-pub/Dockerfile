# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
FROM public.ecr.aws/amazonlinux/amazonlinux:latest

# Install dependencies
RUN yum update -y && \
    yum install -y python3 && \
    yum install -y python3-pip && \
    yum install -y socat && \
    pip3 install awsiotsdk 

# run selected files
RUN mkdir /pyfiles
COPY ./app.py /pyfiles/app.py

CMD ["python3","-u", "/pyfiles/app.py"]
