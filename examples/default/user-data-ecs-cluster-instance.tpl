#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'installing additional software'
# installing in a loop to ensure the cli is intalled.
for i in {1..5}
do
  yum install -y aws-cli && break || sleep 60
done

echo 'setting info for ECS cluster configuration'
echo ECS_CLUSTER="${ecs_cluster_name}" >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"syslog\",\"awslogs\"] >> /etc/ecs/ecs.config
