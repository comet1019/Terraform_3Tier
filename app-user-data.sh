#!/bin/bash

echo ECS_CLUSTER="${ecs-cluster-name}" >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
