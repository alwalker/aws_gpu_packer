## Packer
Packer is used to build both a base image and an image that runs the application.  

The base image is created from the latest Ubuntu 18.04 marketplace image and installs the latest updates, version 390 of the NVIDA drivers, and version 9.0 of the CUDA toolkit as well as all of its patches.  In order for CUDA to function it also installs GCC 6 and sets it to the default.  This is done manually by running `packer build packer_nvidia_base.json' and should be done whenever any OS updates are needed.

The application image is created using two scripts, one run as root and the other run as the application user.

The root script does the following:

1. Installs pip, venv, the AWS CLI, and some other handy utilities
2. Set's up the directory structure and permissions for the application and configs
3. Creates a systemd unit for running the application
4. Installs and configures NGINX

The user script does the following:

1. Copies the application code and configuration from S3
2. Set's up a venv for the application and installs its dependencies