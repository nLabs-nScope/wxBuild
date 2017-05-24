# wxBuild
This is a multi-container Docker setup for building cross-platform wxWidgets applications in Docker containers. It is intended to enable repeatable bring-up of build machines.

This repository is a work-in-progress.

## Configuration
Docker compose creates seven build containers from one single dockerfile by passing different arguments to the build.
