# package-snapshot

This repository contains a set of tools and pipelines designed to create and manage snapshots of Debian APT repositories. The snapshots are used by Garden Linux build processes to ensure consistent and reproducible package builds.

## Scope
This tooling is designed for internal use, as the APT snapshots created implement only a subset of a typical APT repository's features. While they are compatible with the APT package manager, an APT client not aware of these specific implementations and limitations may not be able to correctly consume these snapshot repositories. For the public-facing APT repository, we use the tool `aptly`, which is part of a different repository (`gardenlinux/package-publish`) and is out of scope for this project.

## Usage
This package-snapshot tooling is designed to run only in github actions. 
