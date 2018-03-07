# docker-ravencoin

A dockerizaton of the ravencoin wallet and associated ccminer with x16r support.

# Wallet

On any docker-engine, you may run the wallet:

    docker-compose up -d ravencoin-wallet

Once running, you can docker exec into it and run `raven-cli` to interact with the wallet:

    docker exec -ti ravencoin-wallet bash
    $ raven-cli getnewaddress ""
    $ raven-cli getaddressesbyaccount ""
    $ raven-cli getbalance ""

# Mining

The `ravencoin-gpu-ccminer` container requires a docker-engine with the nvidia runtime enabled by default.

First, you will want to install the latest nvidia driver and cuda libraries.

# nVidia on Docker

On ubuntu, for the current latest `nvidia-390` driver:

    sudo apt-get update
    sudo apt-get install -y software-properties-common 
    sudo add-apt-repository -y ppa:graphics-drivers
    sudo apt-get update
    sudo apt-get install -y nvidia-390

To find the latest cuda library for the linux flavor and release you are using for your docker-engine host:

- https://developer.nvidia.com/cuda-downloads

For CUDA 9.1 on Ubuntu 16.04, for example:

    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
    sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install -y cuda

Now you should be able to run this and see your nvidia card:

    nvidia-smi

Before you install nvidia-docker2`, you will want to make sure your `docker-ce` is up to date as well:

    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce nvidia-docker2

Now you should be able to run this and see your nvidia card:

    docker run -ti --rm --runtime=nvidia nvidia/cuda nvidia-smi

The final remaning step to prepare your docker-engine is to edit your `dockerd` startup script and add this to the end:

    --default-runtime=nvidia

On a docker-machine generic driver provisioned ubuntu 16.04 host, I need to edit:

    sudo vi /etc/systemd/system/docker.service.d/10-machine.conf

Changing this line:

    ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:50376 -H unix:///var/run/docker.sock --storage-driver overlay2 --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic

To:

    ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:50376 -H unix:///var/run/docker.sock --storage-driver overlay2 --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic --default-runtime=nvidia

Now we tell systemd to reload the services from disk:

    systemctl daemon-reload

And then restart docker:

    systemctl restart docker

Now you should be able to run this and see your nvidia card:

    docker run -ti --rm nvidia/cuda nvidia-smi

Your docker-engine is now ready to run docker containers that use the nvidia GPU.

# Running ccminer

Start the miner using this:

    docker-compose up -d ravencoin-gpu-ccminer

Watch the logs using this:

    docker-compose logs -f --tail=100 ravencoin-gpu-ccminer

