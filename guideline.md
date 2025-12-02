# Terraform Style Guideline

This document outlines the conventions to follow when writing Terraform code in this project.

## File Structure

- Each Terraform file should represent a logical component of the infrastructure.
- Resources should be grouped by their primary function. For example:
  - `loadbalancer.tf`: Contains all `aws_lb`, `aws_lb_listener`, and `aws_lb_target_group` resources.
  - `security_group.tf`: Contains all `aws_security_group` resources.
  - `iam_role.tf`: Contains all `aws_iam_role` and `aws_iam_policy` resources.
  - `ecs.tf`: Contains all `aws_ecs_cluster`, `aws_ecs_service`, and `aws_ecs_task_definition` resources.
  - `ecr.tf`: Contains all `aws_ecr_repository` resources.
- `main.tf`: Should contain the provider configuration and data sources that are used across multiple files.
- `variables.tf`: Should contain all variable definitions.
- `outputs.tf`: Should contain all output definitions.
