{
  "name": "xray-daemon",
  "image": "amazon/aws-xray-daemon",
  "cpu": ${cpu},
  "memoryReservation": ${memory},
  "portMappings": [
    {
      "containerPort": 2000
    }
  ]
}
