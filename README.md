# Dockerfile Library

## Overview

The Dockerfile Library is a collection of Dockerfiles for various applications and services. Each Dockerfile is organized in a directory structure that reflects its purpose.

## How it Works

Dockerfiles are organized in directories based on the application or service they are intended for. The naming convention for Dockerfiles is as follows:
- Each Dockerfile should be named as `<image-name>.Dockerfile`.
- The directory structure should be `<image-directory>/<image-name>.Dockerfile`.

To build and push a Docker image from the library, you can use the provided GitHub Actions workflow. The workflow allows you to specify the image you want to build and optionally push it to DockerHub.
