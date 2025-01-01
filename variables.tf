variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}

variable "use_waf" {
  description = "Whether or not to enable the simplest, cheapest AWS WAF offering for security/ddos protection."
  default     = false
  type        = bool
}

variable "admin_email" {
  description = "admin email to send usage traffic alerts to"
  default     = ""
  type        = string
}

variable "request_limit" {
  description = "Number of requests per minute that should trigger an alert. "
  default     = 100
  type        = number
}
