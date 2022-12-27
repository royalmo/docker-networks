<!--
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
  -->

# Docker Networking Lab Session

Written by [royalmo](https://github.com/royalmo) (Eric Roy).

---

*This lab session is part of the ICT Systems Engineering program at 
EPSEM (UPC Manresa). You can check more content
[here](https://ocwitic.epsem.upc.edu).*

---

## Table of contents

- [Introduction](#introduction)
- [Docker installation](#docker-installation)
- [What is Docker?](#what-is-docker)
- [What is docker-compose?](#what-is-docker-compose)
- [Basic Docker commands](#basic-docker-commands)
- [Docker networking](#docker-networking)
- [More information](#more-information)

## Introduction

This Lab Session will introduce you into the Docker environment, so that by the
end of it you have been able to configure the network as your will in some
Docker containers, as well as understanding basic Docker concepts.

**You don't need to know anything about Docker, nor read any
documentation**, as everything needed is provided here (and the work you did in
the previous lab sessions). However, to achieve a complete understanding, it is
recommended to extend your knowledge by reading some documentation and
understanding the source code that we will be using.

### Submission details

You need to deliver a PDF document containing an explanation of all the
**tasks** of this document. Note that **you don't need to document the
exercises**, as they're normally steps from the tutorial. Nevertheless, if you
don't complete them, you won't be able to follow this tutorial and the tasks.

## Docker installation

Docker can be installed in any machine, regarding of its OS. However, it's
recommended to use a GNU/Linux based OS, as this lab session has not been fully
tested on other Systems.

You can follow the updated installation tutorial at
[https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/).
Follow the steps to install Docker Desktop on your machine. If you use
GNU/Linux, you simply need to install it as every aplication:

```sh
$ sudo apt-get install docker docker-compose
```

If you installed it via *apt*, you may not have the Desktop interface, but
**in this tutorial we will only use the CLI** (*Command-Line Interface*).

---

**EXERCISE 1** Install docker and docker-compose in your system. Note that
docker-compose is included in the Docker Desktop application.

---

Once installed, and before you continue with this lab session, check that you
have everything installed. Here is what you should look for (Note that docker needs the client and the server packages to work correctly).

```sh
$ docker version
Client: [...]
 Version: 20.10.22
 [...]
Server: [...]
 Engine:
  Version: 10.10.22
  [...]
$ docker-compose version
docker-compose version 1.17.1, build unknown
[...]
```

Versions may change as time goes by, but as long as the CLI APIs don't change,
this tutorial should work correctly.

---

**EXERCISE 2** Check that your Docker installation was sucessful.

---

### Docker Hub Account

[Docker Hub](https://hub.docker.com/) is where Docker images are stored (as
public or private images). In this lab session we will need to pull some public
images from there. You should need to create an account in order to pull them,
but Docker policies could vary in the future.

Creating a Docker Hub account is the first step for getting more into Docker.
It's free, and will let you access more features (that aren't needed for this
lab session).

---

**EXERCISE 3** (*Optional*) Create a Docker Hub profile and log in to your CLI
using `docker login -u <username>`.

---

## What is Docker?

The best way to define what is Docker, is to present the reason why it exists.

### The initial problem

Let's supose the case of a computer that needs to run 5 different applications.

Each application needs its dependencies, and there may be incompatibilities
between the versions required for each app. One solution, using only one
physical machine, is to create 5 **virtual machines** and run one applicaction
in every machine. That way, they run in a *isolated* world, where they have
their own dependencies and (maybe) different Kernel and OS.

However, it's hard to maintain a virtual machine: we would need to treat it as
a personal computer: update all the OS, long boot and shutdown times. But
mostly, **the resources of the physical machine would need to be shared out in
a fixed size**, meaning that at some point application 1 wouldn't need all its
resources and application 2 wouldn't keep up with the given resources.

### Virtualising aplications

Here's where Docker comes into our rescue. There're a lot of features that the
application doesn't need to run (i.e. a Desktop environment). It is possible to
create a "virtual machine" with just the necessary libraries for a desired
application. This will reduce resources and boot and shutdown times.

But that's not all: instead of booking some physicall resources, let's run each
application in a host kernel's process. That way, resources can be shared by
the host machine. And this is what does Docker.

### Terminology

There are some words that are constantly repeated among Docker documentation
and this document. Let's define them in a few words:

- **Host machine**: The physical computer that will be running the containers.

- **Dockerfile**: The file that describes an image. Using an analogy, we could
  say that the Dockerfile is the Makefile of a project and the image is the
  executable file. It contains the instructions needed to recreate the image.

  You have an example of a `Dockerfile` in the repository of the lab session.

- **Image**: As said before, this can be compared to an executable file. When
  an image is runned, a container is created.

- **Container**: A container is a kernel process that runs an image. As you can
  imagine, a container can be executed multiple times at once. **The changes made in a container will not affect the image.** This means that you can mess arround with a container, that other containers or the image will remain intact, and **once you stop that container you will loose all changes**.

### Basic commands

Here is a list of the most basic commands that you may need in the first tasks:

- `docker build -t <image_name> <Dockerfile_folder>` will run the `Dockerfile`
  that's in the given folder, and save the image with the given name.

- `docker run [-it] <image_name>` will create a container of the image given.
  If the image runs an interactive application (i.e. bash), you will need to
  spefify it with the `-it` flags.

  Docker implemented a feature that, if the image specified doesn't exist in the
  host machine, it will look for it in the Docker Hub repositories, download it
  and run it. This will save us (in our case) every `docker build` command.

- `docker ps` lists the active containers and some information about them.

- `docker image ls` will list all locally saved images. You can remove them to
  save some memory space.

There are a ton of commands, and some of them will be explained along this
document, but if you wish to have a cheatsheet you can check the official
documentation.

### Practical example

Now that you have some knowleadge about Docker, let's make some



## What is docker-compose?

## Basic Docker commands

## Docker networking

<!--
- check ip a and ip route for docker0 interface.

docker network inspect
-->

## More information
