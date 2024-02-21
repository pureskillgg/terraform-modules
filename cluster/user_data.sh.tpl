#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
  echo "ECS_IMAGE_PULL_BEHAVIOR=once"
} >> /etc/ecs/ecs.config

start ecs

echo "Done"
