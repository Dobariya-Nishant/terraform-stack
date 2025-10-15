variable "github_org" {
  description = "GitHub organization or user name"
  type        = string
}

variable "github_repos" {
  description = "List of GitHub repositories allowed to assume this role"
  type        = list(string)
}

variable "name" {
  description = "GitHub iam role name"
  type        = string
}