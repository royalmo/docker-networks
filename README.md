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
  - [Submission details](#submission-details)
- [Docker installation](#docker-installation)
  - [Docker Hub account](#docker-hub-account)
  - [Post-installation advices](#post-installation-advices)
- [What is Docker?](#what-is-docker)
  - [The initial problem](#the-initial-problem)
  - [Virtualizing applications](#virtualizing-applications)
  - [Terminology](#terminology)
  - [Basic commands 1](#basic-commands-1)
  - [Exercises and tasks](#exercises-and-tasks)
- [What is docker-compose?](#what-is-docker-compose)
  - [Basic commands 2](#basic-commands-2)
  - [Extra: docker attach VS docker exec](#extra-docker-attach-vs-docker-exec)
  - [Practical example](#practical-example)
- [Docker networking](#docker-networking)
  - [Network types](#network-types)
  - [Extra: docker swarm](#extra-docker-swarm)
  - [Default network setup](#default-network-setup)
  - [Managing docker networks](#managing-docker-networks)
- [A complete exercise](#a-complete-exercise)
  - [Getting familiarized with the network](#getting-familiarized-with-the-network)
  - [Extending docker's NAT](#extending-dockers-nat)
  - [To be continued ...](#to-be-continued)
- [More information](#more-information)
  - [Copyright notice](#copyright-notice)

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
GNU/Linux, you simply need to install it as every application:

```shell
$ sudo apt-get install docker docker-compose
```

If you installed it via *apt*, you may not have the Desktop interface, but
**in this tutorial we will only use the CLI** (*Command-Line Interface*).

> **EXERCISE 1**
> 
> Install docker and docker-compose in your system. Note that
> docker-compose is included in the Docker Desktop application.

Once installed, and before you continue with this lab session, check that you
have everything installed. Here is what you should look for (Note that docker
needs the client and the server packages to work correctly).

```shell
$ docker version
Client: [...]
 Version: 20.10.22
 [...]
Server: [...]
 Engine:
  Version: 20.10.22
  [...]
$ docker-compose version
docker-compose version 1.17.1, build unknown
[...]
```

Versions may change as time goes by, but as long as the CLI APIs don't change,
this tutorial should work correctly.

> **EXERCISE 2**
> 
> Check that your Docker installation was successful.

### Docker Hub Account

[Docker Hub](https://hub.docker.com/) is where Docker images are stored (as
public or private images). In this lab session we will need to pull some public
images from there. You shouldn't need to create an account in order to pull
them, but Docker policies could vary in the future.

Creating a Docker Hub account is the first step for getting more into Docker.
It's free, and will let you access more features (that aren't needed for this
lab session).

> **EXERCISE 3** (*Optional*)
> 
> Create a Docker Hub profile and log in to your CLI
> using `docker login -u <username>`.

### Post-installation advices

Once everything is installed, you may have encountered a problem:
**every docker and docker-compose command requires superuser permissions**
(i.e. `sudo`). Now, you can choose between 3 alternatives:

- You can still use `sudo` in every command. It isn't recommended as it will
  be painful, but if you're lazy or in a hurry it's still possible.

- You can run a **root terminal** with `sudo -i`, and there, any docker
  commands won't require that privilege escalation.

- Last but best, you can **add your user into the docker group**. Once this is
  done, you won't need to run anything with sudo anymore. There's an official
  tutorial on how to achieve this in
  [this link](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

  It's highly recommended to follow the tutorial: you will only need to run 3
  commands and everything will be much easier.

> **EXERCISE 4** (*Optional*)
> 
> Set up your docker environment so you don't need to run every command with
> `sudo`.
> 
> If you followed the tutorial but get an error with some `docker.sock` file,
> run `sudo chmod 666 /var/run/docker.sock`
> ([+ info](https://adamtheautomator.com/docker-permission-denied/)).

## What is Docker?

The best way to define what is Docker, is to present the reason why it exists.

### The initial problem

Let's suppose the case of a computer that needs to run 5 different applications.

Each application needs its dependencies, and there may be incompatibilities
between the versions required for each app. One solution, using only one
physical machine, is to create 5 **virtual machines** and run one application
in every machine. That way, they run in a *isolated* world, where they have
their own dependencies and (maybe) different Kernel and OS.

However, it's hard to maintain a virtual machine: we would need to treat it as
a personal computer: update all the OS, long boot and shutdown times. But
mostly, **the resources of the physical machine would need to be shared out in
a fixed size**, meaning that at some point application 1 wouldn't need all its
resources and application 2 wouldn't keep up with the given resources.

### Virtualizing applications

Here's where Docker comes into our rescue. There're a lot of features that the
application doesn't need to run (i.e. a Desktop environment). It is possible to
create a "virtual machine" with just the necessary libraries for a desired
application. This will reduce resources and boot and shutdown times.

But that's not all: instead of booking some physical resources, let's run each
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
  an image is run, a container is created.

- **Container**: A container is a kernel process that runs an image. As you can
  imagine, an image can be executed multiple times at once. **The changes
  made in a container will not affect the image.** This means that you can mess
  around with a container, that other containers or the image will remain
  intact, and **once you stop that container you will loose all changes**.

### Basic commands 1

Here is a list of the most basic commands that you may need in the first tasks:

- `docker build -t <image_name> <Dockerfile_folder>` will run the `Dockerfile`
  that's in the given folder, and save the image with the given name.

- `docker run [-it] <image_name>` will create a container of the image given.
  If the image runs an interactive application (i.e. bash), you will need to
  specify it with the `-it` flags.

  Docker implemented a feature that, if the image specified doesn't exist in the
  host machine, it will look for it in the Docker Hub repositories, download it
  and run it. This will save us (in our case) every `docker build` and
  `docker pull` command.

- `docker ps` lists the active containers and some information about them.

- `docker image ls` will list all locally saved images. You can remove them to
  save some disk space.

- `docker system prune -a` will delete **everything** you created using docker
  commands: networks, images, rules... this can be a good idea if you don't know
  what you just did. There are less heavy ways to fix things, but this will
  work every time.

There are a ton of commands, and some of them will be explained along this
document, but if you wish to have a cheat sheet you can check the official
documentation.

### Exercises and tasks

Now that you have some knowledge about Docker, let's play a little bit with it.

> **EXERCISE 5**
> 
> Run `docker run -it ubuntu`. The container's bash prompt will be
> displayed over the current terminal. In another terminal run `docker ps` to
> check the state of that terminal.

As you can see, the `ubuntu` image ([_/ubuntu](https://hub.docker.com/_/ubuntu))
contains a basic ubuntu distribution (the version could be specified i.e.
`docker run -it ubuntu:18.04`), **with the most basic commands**. Having only
the essential programs permits a lightweight image and faster boot times.

You can see that we are in another machine because the terminal prompt has a
different host machine (remember: `user_name@computer_name`).

> **TASK 1**
> 
> In that container, check which commands do work properly:
> - `emacs test.txt`
> - `echo hola`
> - `nano test.txt`
> - `vi test.txt`
> - `ping google.com`
> - `ip a`
> - `sudo echo hola`
> 
> Did some of the results surprised you? Will it be able to perform tasks with
> these applications?

As you may imagine, we need to install some packages to run our applications.
For example, if we want to virtualize our Python script, we will need to install
it.

> **EXERCISE 6**
> 
> Run `apt list` and check if the `nano` package is listed blow.
> Remember that this list contains all the installable and installed packages.
> 
> *Hint: use `grep` to find the nano package faster.*
> 
> *Hint 2: using a pipeline you may get a warning. It should affect anything,
> but you can hide it by suppressing apt's stderr output (`2> /dev/null`).*
> 
> To compare, you can check if the `apt` package appears in that list.

The basic Ubuntu image comes with the smallest package list possible, again, to
use less resources. But in order to install a package, we need to add that entry
to the package list. Do you remember how we update the package list?

> **TASK 2**
> 
> Try to install nano (`apt install nano`). Did it work? Update the
> package list with `apt update`. Once this done, check `apt list`. Do you see
> it now?
> 
> Install it and try the nano command. Did it work?

Now we will verify the persistance of a container.

> **TASK 3**
> 
> Stop the current container by exiting its bash terminal. Check
> that nothing appears in `docker ps`, but the *Ubuntu* image still appears in
> `docker image ls`.
> 
> Run the container again, and check if `nano` is still installed. Did you expect
> that to happen? Why?

It will be painful to install everything every time we restart our container.
That's why we can create *Dockerfiles* that build an Ubuntu (or whatever) image
but with added applications. In fact, `ubuntu` is an image that sits on top of
the Docker's kernel (a *special* Linux kernel).

To make your life easier, an image has been already prepared for you. It's
called
[royalmo/docker-networks](https://hub.docker.com/r/royalmo/docker-networks).
You can find it's Dockerfile
[in this repository](https://github.com/royalmo/docker-networks). It may be
recommended to read it in order to understand what contains the image, but it
isn't mandatory.

> **TASK 4**
> 
> Run the `royalmo/docker-networks` image, and check which of the
> commands that didn't work in the first task now work. Do you have all the
> needed tools to configure the network?

## What is docker-compose?

Docker-compose is an extension to the docker environment that makes it easier to
manage multiple containers at once, and the connections between them. In our
case, we will use it to create multiple containers at once, and to connect them
as we wish.

### Basic commands 2

The `docker-compose` command will work *only* if it's executed in a folder where
a file named `docker-compose.yml` exists. We will not talk too much on what
needs this file, but rather on how to use it. Here you have a continuation of
the previous command list.

- `docker-compose up [-d]` will build images and run all containers. Use `-d`
  if some containers are interactive. This way it will run in background and you
  will be able to attach to the terminals later.

- `docker-compose down` will stop and delete all containers.

- `docker-compose ps` will show the state of the containers created. Please note
  that this command does a different thing than `docker ps`: *docker-compose*
  displays the services of the current `docker-compose.yml` (if they're up), and
  *docker* will show only the running containers.

- `docker attach <container_name>` will attach to the terminal, if possible, of
  the given container name. `<container_name>` must exist in `docker ps`.

- `docker exec <container_name> <command>` will execute a command in a given
  container. `<container_name>` must exist in `docker ps`.
  
  Although not used in this document, it's important to understand the
  difference with `docker attach`.

- `docker-compose restart <service_name>` will restart a single service that may
  be stopped in `docker-compose ps`. A service can be stopped due to an error,
  the user exiting the shell, or with `docker stop`.

- If you found an *image not found error* when you run `docker-compose up`, it
  will probably be because you didn't run `docker-compose down`.
  **A docker-compose file can not be run multiple times.** If nothing is
  displayed in `docker-compose ps`, you're good to run *up*.

### Extra: docker attach VS docker exec

In this document we will always use `docker attach`, but let's introduce
ourselves to the typical _Docker scenario_.

A Docker container will (almost) always be an application doing something. These
types of applications will normally be servers: web servers, databases, ...
something that will return a response after an input (normally sent via
network) is received.

The main application of those containers will be a daemon of that server (a
process that runs infinitely). In this case, we will clearly see the difference
between `docker attach` and `docker exec`:

- Imagine we need to access the server console (e.j. a Minecraft server) to
  ban a player. With `docker attach`, we will attach to the java executable,
  and communicate with the server. In other words, with `docker attach` we
  **communicate with the main process**. Note that not all main processes are
  interactive, thus `docker attach` may not work in every container.

- However, we may need to modify a backup script on that server. For this
  purpose, we could run `docker exec -it <container_name> bash` and we would
  land in a bash terminal in that container, as if it was SSH. There we can
  create, delete, and modify all the files we need. In other words, with
  `docker exec` we **communicate with the container, not any process**.

In this document, we don't have any server in any container, as we don't need
them. That's why we placed _bash_ as the main process, thus we can `attach` to
it instead of `exec` a new _bash_ process. But keep in mind that
**this isn't the general rule and how Docker is meant to be used**.

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

> **EXERCISE 7**
> 
> Create a folder `test` and a file inside of it
> `docker-compose.yml` with the text provided above.

This is all the setup we need to do. Now, let's play with it!

> **TASK 5**
>
> Run the `docker-compose` setup **in background** (extra: what happen when
> you don't add the `-d` flag?). Check the status and the containers names with
> `docker-compose ps`. What are its states and container names?
>
> What would be the command to attach to a terminal?

Once the containers opened, we can check if everything works fine.

> **EXERCISE 8**
> 
> Open another terminal with 2 tabs (in bash you can create a tab with 
> *Ctrl+Shift+T*) and attach a container per tab. You can check that the
> bash prompt is different for each container.
> 
> Create a different file in each container with `touch`.

The last task of this section will be to restart a stopped container.

> **TASK 6**
> 
> Stop a container by exiting its shell. Does it appear now in `docker ps`?
> And in `docker-compose ps`? Do we have further info?
> 
> Restart only that container, and
> attach to it again. Does the file still exist?
> 
> What would happen if instead of restarting, you stop all containers with
> `docker-compose down` and restart them? You can verify your answer by trying
> it.

## Docker networking

Docker has a very complex but easy-to-understand network system in order to
permit containers to communicate with the outer world. When installed, it
creates it's own _isolated environment_.

The main and default Docker network is called `bridge`, and as it name tells,
it acts like a bridge between the containers and the host. New containers are
assigned with that address range. This means that, if we enable a NAT router on
our host machine, they will have internet access.

> **TASK 7**
> 
> On your host machine, run `ip a` and `ip routes`. You will see that Docker
> added some devices during its installation. What IP ranges do they use?
> Does your host machine know how to go to them (i.e. do they have it's own
> route entry)?
> 
> Now check the current *POSTROUTING* table (`sudo iptables -vL -t nat`, and
> check the *POSTROUTING* section). Do you see something that could be doing
> a NAT router for the Docker containers?

### Network types

The bridge network type is only one of the five types that Docker has. Here you
have a small description of every type:

- **BRIDGE**: This is the most common network type, and the default for every
  new container. Every new network is simply a new sub-range of IP addresses 
  inside the default `172.0.0.0/8` IP range. Of course, the addresses can be
  manually set. The bridge network also connects the containers with the host
  machine, as it also has an IP (which is normally the gateway).

- **HOST**: The *host* network simply runs the container with the network of
  the host. This means that it has the same IPs and routes. It's like we were
  running the application on the host machine, but the libraries and packages
  are isolated.

- **NONE**: This type of Docker network specifies that a container must not have
  any network attached into it. This can become very useful to protect our
  applications, so they don't have any external connections. We haven't
  mentioned it in this document, but Docker provides other inter-container
  communication methods, so we would still be able to control it.

- **OVERLAY**: This last network type is a little bit special. A swarm network
  is a "virtual network" that **is independent of the physical devices**. This
  means, that multiple devices can, together, have a single overlay network.
  This method becomes very useful when using distributed servers, and can be
  compared to [Kubernetes](https://kubernetes.io/). By default, this networks
  are allocated in the `10.0.0.0/8` IP range.

  We will just use this network type for educational purposes in a non-standard
  way, as we will have multiple overlay networks in a single physical computer.
  To be able to create overlay networks in this edge case, we need to initialize
  a special Docker feature: *swarm*. It's explained in the next section.

- **MACVLAN**: The *macvlan* network creates a new connection to the host
  computer's main network. As this last sentence wasn't easy to understand,
  let's see an example. But don't worry, we won't see this in the exercises and
  tasks.

  Imagine your laptop is connected to the internet through WiFi (or Ethernet)
  with the IPv4 `192.168.1.5`. If a new container is attached to the *macvlan*
  network, Docker will "try to connect a new device to your router", so that,
  for example, the new container's IPv4 address is `192.158.1.7`. You can set it
  up to use DHCP or a manual configuration.

> **EXERCISE 9**
> 
> Run `docker network ls` to see the default docker networks and its names.
> When a new network is created, you will see it here.
> 
> **Note:** From now on, you'll be creating (directly or indirectly) a lot of
> Docker networks, so the output of `docker network ls` can become a nightmare.
> You will be able to delete all unused networks (except for the default ones)
> with `docker network prune`.

### Extra: docker swarm

To use overlay networks, we need to have _swarm_. It's the Kubernetes of Docker:
it manages the containers between the different hosts.

For example, if we make a cluster of 2 hosts and 5 containers need to be
executed between those hosts, _swarm_ will decide where to run each container,
depending on the resources needed, to make both hosts have approximately the
same amount of work.

In our case, we only have one host, but we still need to initialize _swarm_, as
overlay networks work on top of it. As you can imagine, the command to do so
is `docker swarm init` (don't run it yet). You need to do this only once: if
you already did this, you will get an error saying that
_this node is already part of a swarm_.

**Warning:** docker swarm is more strict than your computer: you may have more
than one IPv4 and IPv6 address in your network interface; it's fine with the
normal usage of Ubuntu. However, swarm requires **a single address** (you can
have an IPv4 *and* an IPv6, but not two IPv4), meaning that you may get an error
if you have more than one. You can specify only one address, but the easiest way
is to delete that extra one.

If you're interested in practicing a little bit with _swarm_, you can check out
this [tutorial](https://docs.docker.com/engine/swarm/swarm-tutorial/).

### Default network setup

As in a normal case we don't need any complex networking, Docker does a lot of
default things for us. For example, when a network is created, an IP range is
assigned, and when containers are added to it, an IP is automatically assigned.
Imagine how painful will it be to always connect to the network (with a
different IP) every time you start a new container!

Docker provides a feature to **inspect a network**. This can help us when
debugging, and will show us relevant information. The magic command is
`docker network inspect <network_name>`. This will result in a JSON object being
printed in our terminal (we could also save it to a file for better reading).
It will contain the IP range, the connected containers and its IPs, and other
metadata.

> **TASK 8**
> 
> With the compose file from the previous section running, inspect all networks
> available and note down each container's IP address. Verify your answers by
> running `ip a` on every container.

Docker also sets up the routes to all neighbors at the start of every new
container. This means that, if two containers are on the same network, they
will be able to ping each other without prior configuration.

But that's not all, Docker also provides a "DNS server", so you can put the
container name instead of its IP address, and it will replace it. However,
**this feature may not work if we change some network settings on-the-go**
(and surprise, this is what we will do!).

> **TASK 9**
> 
> Using the `ping` command (you can use the container's name instead of its
> IPv4), perform these tasks:
> 
> - Check with `ip route` if the containers can communicate to each other.
> 
> - Can they also communicate with the host machine? If so, which IP must they
>   use to reach the host machine?
> 
> - Can all containers reach Internet (i.e. google.com)? Did you expect that?
> 
> - Now set the host's ip_forward flag to 0 (docker sets it to 1 by default)
>   with `sudo sysctl -w net.ipv4.forward=0`. Can now the containers ping to
>   google? Did you expect that to happen?
> 
> Remember to set the _ip_forward_ bit to 1 at the end of this task.

If you look to some Docker tutorials, you may see that the only network-related
thing is to **expose a port**. Now that we know how docker connects each
container, what does this do? The answer is really simple: it adds a rule to
the host's *iptables*.

For example, "bind any inbound packets coming from WiFi and port 80 to the
docker container with IP `X` and the port 3000". As you can imagine, we could
do this by ourselves, but Docker does it for us.

> **EXERCISE 10**
> 
> Check the NAT table in *iptables* (same command as before). Save the output.
> 
> Now run `docker run -it -p 100:3000 ubuntu`, and in another terminal check the
> *iptables* again.
> 
> Compare both outputs. Do you see somewhere a new port-forwarding
> rule? Can you imagine what does the `-p` flag do, without reading the
> documentation?
> 
> Extra: add the conclusions of this exercise in the report.

### Managing docker networks

A good way to learn all the network stuff is to play with it. For this, you will
need some new docker commands. Here are some examples that you may need:

- `docker network create -d bridge --subnet 172.0.56.0/24 new_network_name` will
  create a new network of type *bridge* and the specified subnet and name.

- `docker run -it --network new_network_name royalmo/docker-networks` will run
  an image in a container with a specified network.

As you can see, Docker asks us to specify the subnet of a network. With a
physical Switch, this setup doesn't need to be done, but as we are
working in a virtualized environment, we need to add this extra information.
It's done this way so Docker can assign IPs automatically, and to add an extra
security barrier.

If you need to create a network with more options, check out this [reference
manual](https://docs.docker.com/engine/reference/commandline/network_create/).

> **TASK 10**
> 
> Imagine that we have a physical computer (A) and another physical computer
> (B), both connected to the same LAN (i. e. (A) and (B) must be able to ping
> each other).
> - There is a bridge network in (A) with subnet `10.250.45.0/24`.
> - (A) has a single container (with image `royalmo/docker-networks`) connected
>   to that bridge network.
> - (B) has the route `10.250.45.0/24 via <A's IP>`
> 
> Try (if possible) and justify the answers of these questions:
> - Will (A)'s container be able to ping (B)?
> - Will (B) be able to ping (A)'s container?
> - Indeed, (A) implements a NAT router. Does it help protecting (A)'s
>   containers from external attacks?

## A complete exercise

Now that you know the essentials about docker, docker-compose and docker
networking, its time to apply it to simulate a real-life network.

A `docker-compose.yml` file has been prepared just for you. You don't need to
understand what's inside of it, but now that you know a lot about Docker it
could be an interesting exercise. You can see the file in this lab session's
[repository](https://github.com/royalmo/docker-networks) or in
[this direct link](https://raw.githubusercontent.com/royalmo/docker-networks/main/docker-compose.yml).

From now on, let's consider a *node* a container of our compose file. It will
simulate a device on our virtual network.

---

**Disclaimer:** this compose file uses overlay networks, that need swarm setup.
You may find this a little bit overkill, and it is.

If you wish to not use swarm, there's a workaround just for you: you can replace
all overlay networks with bridges. All will work the same way, but now
<ins>the host will act as a network superuser</ins>: it will be able to connect
to every node, and <ins>every node will have Internet access</ins>. However,
some nodes won't be able to communicate with each other right away.

You will then need to change a little bit the statements of the following tasks.
You don't need to connect each node to the internet, but you can route all
_default_ requests through another interface, for example, and check if
everything works as expected using _tcpdump_.

---

> **EXERCISE 11**
> 
> Download the docker-compose file in a new folder called `docker_networks`
> and run it.
> 
> This file will need to create overlay networks, so remember to initialize them
> the first time only with `docker swarm init`. Some warnings about swarm may
> appear while starting everything, telling that there aren't more hosts. It
> should be a problem in a normal case, but it's fine for us.
> 
> Once everything is up and running, attach to every node. Remember to use
> bash's tabs or another fancy terminal for ubuntu like *tilix*.

### Getting familiarized with the network

The nodes are connected with overlay networks. To prevent some headaches, a
schema is provided to you:

![network](https://user-images.githubusercontent.com/49844173/210058483-d91a2f26-a27b-493f-958c-32e7b0f88467.png)

In the repository you will find a `.gv` file with the source code of this
schema. You will find it useful for the next task.

> **TASK 11**
> 
> Fill the graph with the subnets, container's IPs and container interface's
> names. That way, you will have all the names and IP needed at a single place.
> 
> **Warning!** Every time you restart the docker-compose, all addresses, ranges
> and configurations done on the nodes will be lost. It's recommended to do
> tasks 11, 12 and 13 as a pack, so you can use the results from the previous
> tasks. Pick a day you have plenty of time!
> 
> Add the updated graph to the report.

Now that we are familiarized with our node network, let's check its initial
state.

> **EXERCISE 12**
> 
> Check if *node1* has internet access (with a ping to google.com). Now check it
> for any other node. Try also to ping *node1* from *node2*, and a *node7* from
> *node2*.

As you can see, there is a lot to do. But as we did this in previous lab
sessions, it should be done faster than expected.

However, you can see that there are multiple ways to reach some nodes. Be
careful with how you set up some routes, you may end up sending the packets
into an infinite loop (and loose them due to TTL)!

### Extending docker's NAT

We need to take account of another thing: Docker created a NAT router
**only for the bridge network's subnet**. We need to add the overlay networks'
IPs into that NAT. As the following tasks are a little long, here you have
the magic command:

```
sudo iptables -t nat -A POSTROUTING ! -o <net0> -s 10.0.0.0/8 -j MASQUERADE
```

Replace `<net0>` in the last command with net0 interface's name that you
can see when running `ip a` in the host computer (i.e. `br-c39dadf0293e`).
You will have to delete the rule manually by the end of the lab session.

> **TASK 12**
> 
> By only changing the packet forwarding bit and the routing tables of every
> node (and maybe the host?), make that every node can communicate to every node
> **and** has internet access (remember to add the *POSTROUTING* route on the
> host).
> 
> Explain the criteria you used to set up the routes (i.e. why did you chose to
> send packets through that way and not another).
> 
> You can check the results by repeating *Exercise 11*. Run also *tcpdump* on
> some nodes to check that the packets are going through the desired route.

If you finished the last task and all worked, congratulations! You finished this
lab session and learned something (hopefully).

### To be continued ...

For those that didn't have enough, an extra task has been prepared for you.
As with the *Task 12*, it's something you did in other lab sessions. Have fun!

> **TASK 13** (*Optional*)
> 
> Set up the node2 as a NAT router. Re-evaluate the routes (now some nodes
> won't be able to reach other nodes directly).
> 
> Verify that all works as expected by looking at ports and IP addresses in
> *tcpdump*'s output of the correct nodes.

## More information

If you wish to understand the files and commands used in this document,
you can check the official documentation, or look for some tutorials:

- [Dockerfile manual reference](https://docs.docker.com/engine/reference/builder/)

- [docker-compose.yml manual reference](
https://docs.docker.com/compose/compose-file/compose-file-v3/)

As you can see, all of the settings can be done in a Dockerfile. This means
that we could create a *docker-compose* file with the correct images, such that
when we run `docker-compose up`, it starts all the nodes **and** sets up the
routes automatically.

But that is too much for a lab session, do it on your own and only if you
want! ;)

### Copyright notice

This project is under the GPL v3 license. Please give credit if you wish to use
it somewhere else. Feel free to ask me before getting in trouble with the law!
