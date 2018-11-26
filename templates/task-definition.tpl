[
  {
    "name": "${service_name}",
    "essential": true,
    "image": "${docker_repository}/${docker_image}:${docker_image_tag}",
    "memory": ${container_memory},
    ${container_cpu}
    "portMappings": [
      { "HostPort": 0, "ContainerPort": ${container_port} }
    ],
    "environment": [
      ${environment_vars}
    ]
    ${logging_config}
    ${mount_points}
    ${extra_properties}
  }
]
