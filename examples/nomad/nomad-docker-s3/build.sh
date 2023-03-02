#!/usr/bin/env bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

set -e
AWS_ACCOUNT_ID=$(aws sts get-caller-identity |  jq -r '.Account')
AWS_REGION=$(jq -r '.component | to_entries[0] | .value.publish.region' gdk-config.json)
COMPONENT_NAME=$(jq -r '.component | keys | .[0]' gdk-config.json)
COMPONENT_AUTHOR=$(jq -r '.component | to_entries[0] | .value.author' gdk-config.json)
COMPONENT_NAME_DIR=$(echo $COMPONENT_NAME | tr '.' '-')

rm -rf greengrass-build
mkdir -p greengrass-build/artifacts/$COMPONENT_NAME/NEXT_PATCH
mkdir -p greengrass-build/recipes
cp recipe.yaml greengrass-build/recipes/recipe.yaml
sed -i "s/{COMPONENT_NAME}/$COMPONENT_NAME/" greengrass-build/recipes/recipe.yaml
sed -i "s/{COMPONENT_AUTHOR}/$COMPONENT_AUTHOR/" greengrass-build/recipes/recipe.yaml
sed -i "s/{AWS_ACCOUNT_ID}/$AWS_ACCOUNT_ID/" greengrass-build/recipes/recipe.yaml
sed -i "s/{AWS_REGION}/$AWS_REGION/" greengrass-build/recipes/recipe.yaml
sed -i "s/{COMPONENT_NAME_DIR}/$COMPONENT_NAME_DIR/" greengrass-build/recipes/recipe.yaml

docker build -t $COMPONENT_NAME_DIR .
docker tag $COMPONENT_NAME_DIR:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME_DIR:latest

if aws ecr describe-repositories --region $AWS_REGION --repository-names $COMPONENT_NAME_DIR > /dev/null 2>&1
then
    echo "Repository $COMPONENT_NAME_DIR already exists."
else
    # Create the repository if it does not exist
    aws ecr create-repository --region $AWS_REGION --repository-name $COMPONENT_NAME_DIR
    echo "Repository $COMPONENT_NAME_DIR created."
fi

docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$COMPONENT_NAME_DIR:latest