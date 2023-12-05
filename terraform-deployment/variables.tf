variable "https_port" {
   default     = 443
}

variable "http_port" {
   default     = 8000
}

variable "ssh_port" {
  default = 22
}

variable "evaluation_periods" {
  default = 2
}

variable "period" {
  default = 300
}

variable "key_pair" {
  default = "aws-key" # Change depending on deployement
}

data "archive_file" "redirect_zip" {
  type        = "zip"
  source_file = "redirector.py"
  output_path = "redirector.zip"
}