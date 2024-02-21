{
  "name": "${name}",
  "image": "${image}",
  "cpu": ${cpu},
  "memory": ${memory},
  "essential": true,
  "user": "${uid}:${gid}",
  "stopTimeout": ${stop_timeout},
  "disableNetworking": false,
  "privileged": false,
  "readonlyRootFilesystem": true,
  "interactive": false,
  "pseudoTerminal": false,
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "${log_group}",
      "awslogs-region": "${region}",
      "awslogs-stream-prefix": "${name}"
    }
  },
  "healthCheck": {
    "command": [
      "CMD-SHELL",
      "${health_check_cmd}"
    ],
    "startPeriod": 30,
    "interval": 30,
    "retries": 5,
    "timeout": 60
  },
  "environment": ${jsonencode(environment)},
  "secrets": ${jsonencode(secrets)}
}
