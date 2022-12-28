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

```shell
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

```shell
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
  and run it. This will save us (in our case) every `docker build` and
  `docker pull` command.

- `docker ps` lists the active containers and some information about them.

- `docker image ls` will list all locally saved images. You can remove them to
  save some memory space.

There are a ton of commands, and some of them will be explained along this
document, but if you wish to have a cheatsheet you can check the official
documentation.

### Exercises and tasks

Now that you have some knowleadge about Docker, let's play a little bit with it.

---

**EXERCISE 4** Run `docker run -it ubuntu`. The container's bash prompt will be
displayed over the current terminal. In another terminal run `docker ps` to
check the state of that terminal.

---

As you can see, the `ubuntu` image ([_/ubuntu](https://hub.docker.com/_/ubuntu))
contains a basic ubuntu distribution (the version could be speficied i.e.
`docker run -it ubuntu:18.04`), **with the most basic commands**. Having only
the essential programs permits a lightweigth image and faster boot times.

You can see that we are in another machine because the terminal prompt cas a
different host machine (remember: `user_name@computer_name`).

---

**TASK 1** In that container, check which commands do work properly:
- `emacs test.txt`
- `echo hola`
- `nano test.txt`
- `vi test.txt`
- `ping google.com`
- `ip a`
- `sudo echo hola`

Did some of the results surprised you? Will it be able to perform tasks with
these applications?

---

As you may imagine, we need to install some packages to run our applications.
For example, if we want to virtualize our Python script, we will need to install
it.

---

**EXERCISE 5** Run `apt list` and check if the nano package is listed blow.
Remember that this list contains all the installable and installed packages.

---

The basic Ubuntu image comes with the smallest package list possible, again, to
use less resources. But in order to install a package, we need to add that entry
to the package list. Do you remember how we update the package list?

---

**TASK 2** Try to install nano (`apt install nano`). Did it work? Update the
package list with `apt update`. Once this done, check `apt list`. Do you see it
now?

Install it and try the nano command. Did it work?

---

Now we will verify the persistance of a container.

---

**TASK 3** Stop the current container by exiting its bash terminal. Check
that nothing appears in `docker ps`, but the *Ubuntu* image still appears in
`docker image ls`.

Run the container again, and check if `nano` is still installed. Did you expect
that to happen? Why?

---

It will be painful to install everything everytime we restart our container.
That's why we can create *Dockerfiles* that build an Ubuntu (or whatever) image
but with added applications. In fact, `ubuntu` is an image that sits on top of
the Docker's kernel (a *special* Linux kernel).

To make your life easier, an image has been already prepared for you. It's
called
[royalmo/docker-networks](https://hub.docker.com/r/royalmo/docker-networks).
You can find it's Dockerfile
[in this repository](https://github.com/royalmo/docker-networks), and it may be
recommended to read it in order to understand what contains the image, but it
isn't not mandatory.

---

**TASK 4** Run the `royalmo/docker-networks` image, and check which of the
commands that didn't work in the first task now work. Do you have all the needed
tools to configure the network?

---

## What is docker-compose?

Docker-compose is an extension to the docker environment that makes it easier to
manage multiple containers at once, and the connections between them. In our
case, we will use it to create multiple containers at once, and to connect them
as we wish.

### Basic commands

The `docker-compose` command will work *only* if it's executed in a folder where
a file named `docker-compose.yml` exists. We will not talk too much on what does
this file need, but rather on how to use it.

- `docker-compose up [-d]` will build images and run all containers. Use `-d`
  if some containers are interactive. This way it will run in background and you
  will be able to attatch to the terminals later.

- `docker-compose down` will stop and delete all containers.

- `docker-compose ps` will show the state of the containers created. Please note
  that this command does a different thing than `docker ps`: *docker-compose*
  displays the services of the current `docker-compose.yml` (if they're up), and
  *docker* will show only the running containers.

- `docker attach <container_name>` will attach to the terminal, if possible, of
  the given container name. `<container_name>` must exist in `docker ps`.

- `docker-compose restart <service_name>` will restart a single service that may
  be stopped in `docker-compose ps`. A service can be stopped due to an error,
  the user exiting the shell, or with `docker stop`.

- If you found a *image not found error* when you run `docker-compose up`, it
  will probably be because you didn't run `docker-compose down`.
  **A docker-compose file can not be run multiple times.** If nothing is
  displayed in `docker-compose ps`, you're good to run *up*.

### Practical example

To sum up this section, let's practice a little bit. We will work with a basic
(but not minimal) `docker-compose.yml` that will contain this text:

```yml
version: "3.5"

services:
  node1:
    image: royalmo/docker-networks
    hostname: node1
    tty: true
    stdin_open: true
  node2:
    image: ubuntu:22.04
    hostname: node2
    tty: true
    stdin_open: true
```

---

**EXERCISE 6** Create a folder `test` and a file inside of it
`docker-compose.yml` with the text provided above.

---

This is all the setup we need to do. Now, let's play with it!



> **TASK 7**
>
> do this and that



## Docker networking

<!--
- check ip a and ip route for docker0 interface.

docker network inspect
-->

## A complete exercise

## More information
