# syntax=docker/dockerfile:1

##########################################################################
# This file is part of the Docker-Networks' Lab session support files.
# Copyright (C) 2022-2023 Eric Roy <eric@ericroy.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##########################################################################

# Builds an Ubuntu image with some very basic tools to configure and test
# network connectivity.
#
# Build image with: `docker build -t docker-networks-img .`
# Note: You don't need to build this image manually.

# This file is overcommented for educational purposes

# All images start from some base image, in our case a fresh (and empty) Ubuntu.
FROM ubuntu:22.04
# It is a good practice to tell who the maintainer is. Before it was done
# with `MANTAINER <name> <email>` but it's now depreceated.
LABEL maintainer="Eric Roy Almonacid <eric@ericroy.net>"
LABEL version="1.1"

# Here come the commands nedded to install everything we need.
# As each line can be cached, it's preferable to install one package per line.
RUN apt-get update -y
RUN apt-get install -y apt-utils iproute2 iputils-ping iptables

# This is the command that will be run AFTER the installation:
# - Commands starting with RUN are executed in `docker build`
# - The command (only one!) starting with CMD is executed at `docker run`.
CMD bash
# Stop (but not remove) the container by exiting bash.
