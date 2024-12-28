# Bite-Sized Command Line

This repository contains a Docker-based environment for exploring and practicing various command-line utilities. Follow the instructions below to build and run the environment.

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