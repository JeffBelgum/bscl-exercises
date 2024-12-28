# Bite-Sized Command Line Labs

This repository contains a Docker-based environment for exploring and practicing various command-line utilities. The exercises provided here are **unofficial supplemental material** designed to complement Julia Evans' [Bite-Sized Command Line](https://wizardzines.com/zines/bite-size-command-line/) zine.

If you enjoy these exercises, we highly recommend purchasing the zine from Julia Evans (@b0rk) to learn more! You can find it [here](https://wizardzines.com/zines/bite-size-command-line/).

**Note:** This repository is not affiliated with Julia Evans or Wizard Zines in any way. It is created by a fan of her work to provide additional practice opportunities for those who have purchased the zine.

## How to Build & Run

### 1. Save the Dockerfile
Save the Dockerfile provided above to a file in your directory. Name it `Dockerfile`.

### 2. Build the Docker Image
Build the Docker image using the following command:

```bash
docker build -t bite-sized-cmdline-labs .
```

### 3. Run a Container Interactively
Run the container interactively using the command:

```bash
docker run -it bite-sized-cmdline-labs
```

### 4. Explore the Environment
Once inside the container, explore the resources provided:

```bash
ls
cat README.md
cd 01_grep
cat EXERCISES.txt
```

### 5. Start Practicing
Try out various command-line utilities such as sed and others included in the environment.

Enjoy learning the command line in bite-sized chunks!