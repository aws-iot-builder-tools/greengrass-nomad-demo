# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
FROM public.ecr.aws/amazonlinux/amazonlinux:latest

# Install dependencies
RUN yum update -y && \
    yum install -y python3 && \
    yum install -y python3-pip && \
    pip3 install boto3 

# run selected files
RUN mkdir /pyfiles
COPY ./app.py /pyfiles/app.py

CMD ["python3","-u", "/pyfiles/app.py"]
