# HTS Jupyter notebook container

We are offering a series of 6 workshops on biological assays and data analysis for HIV researchers.
This series is funded by an R25 grand from the National Institute of Allergies and Infectious Disease (NIAID).
Our goal is to provide educational enrichment for HIV researchers on current assay technologies and the statistical and bioinformatic analysis techniques necessary to process such data. 


This is the source for the Docker container used to run the course Jupyter
notebooks. 



# Using the image
## Install docker

To run a container on your local machine or laptop, download the docker program from <https://www.docker.com>. 


## Run image on your local computer

Once you have the docker program installed, open the program (you should get a terminal screen with command line). Enter the command:
```
docker pull dukehtscourse/jupyter-hts-2019
```

This will pull down the course docker image from dockerhub. It may take a few minutes. Next, run the command to start a container:
```
docker run --name hts-course -v YOUR_DIRECTORY_WITH_COURSE_MATERIAL:/home/jovyan/work \
-d -p 127.0.0.1\:9999\:8888 \
-e PASSWORD="YOUR_CHOSEN_NOTEBOOK_PASSWORD" \
-e NB_UID=1000 \
-t dukehtscourse/jupyter-hts-2019
```
The most important parts of this verbiage are the `YOUR_DIRECTORY_WITH_COURSE_MATERIALS` and `YOUR_CHOSEN_NOTEBOOK_PASSWORD`. 
-   `YOUR_DIRECTORY_WITH_COURSE_MATERIALS` (Bind mounting): The directory name is the one you extracted your course materials into. So, if you put them in your home directory, it might look something like: `-v /home/janice/HTS2019-notebooks:/home/jovyan/work`
-   `YOUR_CHOSEN_NOTEBOOK_PASSWORD`: The password is whatever you want to use to password protect your notebook. Now, this command is running the notebook so that it is only 'seen' by your local computer - no one else on the internet can access it, and you cannot access it remotely, so the password is a bit of overkill. Use it anyway. An example might be: `-e PASSWORD="Pssst_this_is_Secret"` except that this is a terrible password and you should follow standard rules of not using words, include a mix of capital and lowercase and special symbols. etc.
-   `-d -p 127.0.0.1\:9999\:8888` part of the command is telling docker to run the notebook so that it is only visible to the local machine. It is absolutely possible to run it as a server to be accessed across the web - but there are some security risks associated, so if you want to do this proceed with great caution and get help.

Of course, it would be better either configure HTTPS (see the options section below) or run an Nginx proxy in front of the container instance so you get https (encryption) instead of http.

### Open the Jupyter in your browser

Open a browser and point it to http://127.0.0.1:9999
You should get to a Jupyter screen asking for a password. This is the password you created in the docker run command.
Now, you should be able to run anything you like from the course. Depending on your laptop's resources (RAM, cores), this might be slow, so be aware and start by testing only one file (vs the entire course data set).

### Stopping Docker
The container will continue running, even if you do not have Jupyter open in a web browser.  If you don't plan to use it for a while, you might want to shut it down so it isn't using resources on your computer.  Here are two ways to do that:
#### Kitematic
Included in the [Docker for Mac](https://docs.docker.com/docker-for-mac/) and the [Docker for Windows](https://docs.docker.com/docker-for-windows/) installations.
   
#### Commandline
You may want to familiarize yourself with the following Docker commands.
-   `docker stop`
-   `docker rm`
-   `docker ps -a`
-   `docker images`
-   `docker rmi`

### Windows Note
These instructions have not been tested in a Windows environment.  If you have problems with them, please give us feedback

## Run image on a server
To run on a remote server you will want to use a slightly different command from above, because you *will need to connect remotely*:

```
docker run --name hts-course \
-v YOUR_DIRECTORY_WITH_COURSE_MATERIAL:/home/jovyan/work \
-d -p 8888:8888 \
-e USE_HTTPS="yes" \
-e PASSWORD="YOUR_CHOSEN_NOTEBOOK_PASSWORD" \
-e NB_UID=1000 \
-t dukehtscourse/jupyter-hts-2019
```

## Options

You may customize the execution of the Docker container and the Notebook server it contains with the following optional arguments.

* `-e PASSWORD="YOURPASS"` - Configures Jupyter Notebook to require the given password. Should be conbined with `USE_HTTPS` on untrusted networks.
* `-e USE_HTTPS=yes` - Configures Jupyter Notebook to accept encrypted HTTPS connections. If a `pem` file containing a SSL certificate and key is not provided (see below), the container will generate a self-signed certificate for you.
* **(v4.0.x)** `-e NB_UID=1000` - Specify the uid of the `jovyan` user. Useful to mount host volumes with specific file ownership.
* `-e GRANT_SUDO=yes` - Gives the `jovyan` user passwordless `sudo` capability. Useful for installing OS packages. **You should only enable `sudo` if you trust the user or if the container is running on an isolated host.**
* `-v /some/host/folder/for/work:/home/jovyan/work` - Host mounts the default working directory on the host to preserve work even when the container is destroyed and recreated (e.g., during an upgrade).
* **(v3.2.x)** `-v /some/host/folder/for/server.pem:/home/jovyan/.ipython/profile_default/security/notebook.pem` - Mounts a SSL certificate plus key for `USE_HTTPS`. Useful if you have a real certificate for the domain under which you are running the Notebook server.
* **(v4.0.x)** `-v /some/host/folder/for/server.pem:/home/jovyan/.local/share/jupyter/notebook.pem` - Mounts a SSL certificate plus key for `USE_HTTPS`. Useful if you have a real certificate for the domain under which you are running the Notebook server.
* `-e INTERFACE=10.10.10.10` - Configures Jupyter Notebook to listen on the given interface. Defaults to '*', all interfaces, which is appropriate when running using default bridged Docker networking. When using Docker's `--net=host`, you may wish to use this option to specify a particular network interface.
* `-e PORT=8888` - Configures Jupyter Notebook to listen on the given port. Defaults to 8888, which is the port exposed within the Dockerfile for the image. When using Docker's `--net=host`, you may wish to use this option to specify a particular port.


## Running the Course Image with Singularity
Docker requires root permissions to run, so you are unlikely to be able to run Docker on a computer that you are not fully in control of.  As an alternative you can run the course image with [Singularity](https://sylabs.io/singularity/), another container system. Singularity is similar to Docker, and can run Docker images, but you do not need special permissions to run Singularity images *or* Docker images with Singularity (as long as Singularity is actually installed on the computer).

The following command uses Singularity to start up a container from the course Jupyter image.
```
singularity exec docker://dukehtscourse/jupyter-hts-2019 /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser
```

### Running the Course Image on a SLURM cluster



  506  /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser 


We will use the example of the Duke Computer Cluster, but these instructions should be easily adaptable to other clusters

1. From your computer run this to connect to DCC:
```
ssh NetID@dcc-login-03.oit.duke.edu
```
2. Once you are connected run this to start a tmux session:
```
tmux new -s jupyter
```
3. Once you have started a tmux session you can start up Jupyter with this command:
```
srun singularity exec docker://dukehtscourse/jupyter-hts-2019 /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser
```
> Note: the first time you run this, it might take a VERY long time to download the Docker image and build the Singularity image from it

Running this command will print a bunch of stuff. You can ignore everything except the last two lines, which will say something like:

http://dcc-chsi-01:8889/?token=08172007896ad29bb5fbd92f6f3f516a8b2f7303ed7f1df3
or http://127.0.0.1:8889/?token=08172007896ad29bb5fbd92f6f3f516a8b2f7303ed7f1df3
You need this information for the next few steps. For the next step you need the “dcc-chsi-01:8889” part.
“dcc-chsi-01” is the compute node that Jupyter is running on and “8889” is the port it is listening on. You may get a different value every time you start the container.

4. You want to run the following command in another terminal on your computer to set up port forwarding.
```
ssh -L PORT:NODE.rc.duke.edu:PORT NetID@dcc-login-03.oit.duke.edu
```
In this command you want to replace “PORT” with the value you got for port from the srun command and replace “NODE” with the compute node that was printed by the srun command. So for the example above, the ssh port forwarding command would be:

```
ssh -L 8889:dcc-chsi-01.rc.duke.edu:8889 NetID@dcc-login-03.oit.duke.edu
```

5. Now you can put the last line that the srun command printed in your web browser and it should open your Jupyter instance running on DCC.

#### Notes
1. The Jupyter session keeps running until you explicitly shut it down.  If the port forwarding SSH connection drops you will need to restart SSH with the same command, but you don’t need to restart Jupyter.

2. There are two ways to explicitly shut down Jupyter:
    1. Within Jupyter, click on the *Jupyter* logo in the top left to go to the main Jupyter page, then click "Quit" in the top right
    2. Do control-C twice in the terminal where you started Jupyter. If this connection dropped, you can reconnect to it with:
    ```
    ssh NetID@dcc-login-03.oit.duke.edu
    tmux a -t jupyter
    ```
    After shutting down the Jupyter session you can type `exit` at the terminal to close the tmux session.

3. If you need more memory or more cpus you can use the `--mem` and/or `--cpus-per-task` arguments to in the “srun”, for example to request 4 CPUs and 10GB of RAM:
```
srun --cpus-per-task=4 --mem=10G singularity exec docker://dukehtscourse/jupyter-hts-2019 /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser
```

4. If you have high priority access to a partition you can request that partition be used with the `-A` and `-p` arguments to `srun`:
```
srun -A chsi -p chsi singularity exec docker://dukehtscourse/jupyter-hts-2019 /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser
```

5. You might want to access files that are outside of your home directory. Within a singularity container your access to the host computer is
    limited: by default, from inside the container you can only access your home directory. If you want to access directories that are outside your home
    directory, you have to tell *Singularity* when you start the container with the `--bind` command line argument. For example:

```
srun singularity --bind /work/josh:/work/josh exec docker://dukehtscourse/jupyter-hts-2019 /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser
```

5. You can combine several of these command line flags:
```
srun -A chsi -p chsi --cpus-per-task=4 --mem=10G singularity --bind /work/josh:/work/josh exec docker://dukehtscourse/jupyter-hts-2019 /usr/local/bin/start.sh jupyter notebook --ip=0.0.0.0 --no-browser

6. It is strongly recommended to set the `SINGULARITY_CACHEDIR` environment variables in your .bashrc or when running `srun`. This environment variable specifies where the Docker image (and the Singularity image built from it) are saved. If this variable is not specified, singularity will cache images in `$HOME/.singularity/cache`, which can fill up quickly. This is discussed in the [Singularity Documentation](https://sylabs.io/guides/3.7/user-guide/build_env.html#cache-folders)

### Install Singularity
Here are instructions for installing:

- [Singularity version 2.6](https://sylabs.io/guides/2.6/user-guide/quick_start.html#quick-installation-steps)
- [Singularity version 3.2](https://sylabs.io/guides/3.2/user-guide/quick_start.html#quick-installation-steps)
- [Singularity Desktop for macOS (Alpha Preview)](https://sylabs.io/singularity-desktop-macos/)
