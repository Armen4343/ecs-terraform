variable "image_name" {
  type    = string
  default = "docker.io/armen220/the_ninth_wave:latest"
}

variable "task_execution_role" {
  type    = string
  default = "arn:aws:iam::944453362080:role/ecsTaskExecutionRole"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}