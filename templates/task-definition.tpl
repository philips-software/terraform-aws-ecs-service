[
  {
    "name": "${service_name}",
    "essential": true,
    "image": "${docker_repository}/${docker_image}:${docker_image_tag}",
    "memory": ${container_memory},
    ${container_cpu}
    "portMappings": ${container_portmappings},
    "environment": [
      ${environment_vars}
    ]
    ${logging_config}
    ${mount_points}
  }
]
