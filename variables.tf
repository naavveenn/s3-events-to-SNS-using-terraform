variable "sns_topic_name" {
  description = "SNS Topic Name"
  type        = string
  default     = "test-topic"
}

variable "bucket-name" {
  description = "S3 Bucket Name"
  type        = string
  default     = "myterraformbucket2025Feb"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to add to resources"
}

# declare a variable to define the region name
variable "aws_region" {
    description = "Mention the region name"
    type = string
    default = "us-east-1"
}
