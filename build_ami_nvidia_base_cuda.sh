#Driver optimization
nvidia-persistenced
nvidia-smi --auto-boost-default=0
nvidia-smi -ac 2505,1177

#CUDA dependencies
apt-get -y install freeglut3 freeglut3-dev libxi-dev libxmu-dev

#CUDA 9.0 install
wget -q "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run" -O cuda.run
sh cuda.run --silent --override --toolkit
wget -q "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/cuda_9.0.176.1_linux-run" -O cuda_p1.run
sh cuda_p1.run --silent --accept-eula
wget -q "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/2/cuda_9.0.176.2_linux-run" -O cuda_p2.run
sh cuda_p2.run --silent --accept-eula
wget -q "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/3/cuda_9.0.176.3_linux-run" -O cuda_p3.run
sh cuda_p3.run --silent --accept-eula
wget -q "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/4/cuda_9.0.176.4_linux-run" -O cuda_p4.run
sh cuda_p4.run --silent --accept-eula

#CUDA config
ln -s /usr/local/cuda-9.0 /usr/local/cuda
cat << EOF > /etc/profile.d/cuda.sh
export PATH=$PATH:/usr/local/cuda/bin
export CUDADIR=/usr/local/cuda
EOF
cat << EOF > /etc/ld.so.conf.d/cuda.conf
/usr/local/cuda/lib64
EOF
ldconfig

#GCC 6
add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt-get -y update
apt-get install gcc-6 g++-6 -y
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

#Cleanup
rm *.run
