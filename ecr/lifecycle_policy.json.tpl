{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than ${count} days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": ${count}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
