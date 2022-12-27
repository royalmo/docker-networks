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

### Docker installation

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

**TASK 1** Install docker and docker-compose in your system. Note that
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

**TASK 2** Check that your Docker installation was sucessful.

---

### Docker Hub Account

[Docker Hub](https://hub.docker.com/) is where Docker images are stored (as
public or private images). In this lab session we will need to pull some public
images from there. You should need to create an account in order to pull them,
but Docker policies could vary in the future.

Creating a Docker Hub account is the first step for getting more into Docker.
It's free, and will let you access more features (that aren't needed for this
lab session).

## What is Docker?




## What is docker-compose?

## Basic Docker commands

## Docker networking

## More information
