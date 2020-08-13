Bootstrap: docker
From: ubuntu:18.04
Stage: spython-base

%post
# apt packages to install
apt-get update
apt-get install -y build-essential
apt-get install -y wget
apt-get install -y git
apt-get install -y autoconf
apt-get install -y libsqlite3-dev
apt-get install -y libmysql++-dev
apt-get install -y libgsl-dev
apt-get install -y libboost-all-dev
apt-get install -y libsuitesparse-dev
apt-get install -y liblpsolve55-dev
apt-get install -y libboost-iostreams-dev
apt-get install -y zlib1g-dev
apt-get install -y libbamtools-dev
apt-get install -y libbz2-dev
apt-get install -y liblzma-dev
apt-get install -y libncurses5-dev
apt-get install -y libssl-dev
apt-get install -y libcurl3-dev
apt-get install -y libboost-all-dev
apt-get install -y gfortran
# mpich2
cd /root
wget http://www.mpich.org/static/downloads/1.4.1/mpich2-1.4.1.tar.gz
tar xzf mpich2-1.4.1.tar.gz
cd /root/mpich2-1.4.1
./configure
make && make install
PATH="${PATH}:/root/mpich2-1.4.1/bin"
# apt tools
apt-get install -y ncbi-blast+
apt-get install -y hmmer
apt-get install -y cd-hit
apt-get install -y exonerate
# htslib
git clone https://github.com/samtools/htslib.git /root/htslib
cd "/root/htslib"
autoheader
autoconf
./configure
make
make install
# bcftools
git clone https://github.com/samtools/bcftools.git /root/bcftools
cd "/root/bcftools"
autoheader
autoconf
./configure
make
make install
# samtools
git clone https://github.com/samtools/samtools.git /root/samtools
cd "/root/samtools"
autoheader
autoconf -Wno-syntax
./configure
make
make install
TOOLDIR="/root"
# haltools
cd /root
wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
tar xzf hdf5-1.10.1.tar.gz
cd /root/hdf5-1.10.1
./configure --enable-cxx
make && make install
PATH="${PATH}:/root/hdf5-1.10.1/hdf5/bin"
cd /root
git clone https://github.com/benedictpaten/sonLib.git
cd /root/sonLib
make
cd /root
git clone https://github.com/ComparativeGenomicsToolkit/hal.git
cd /root/hal
RANLIB=ranlib
make
PATH="${PATH}:/root/hal/bin"
# AUGUSUTS
git clone https://github.com/Gaius-Augustus/Augustus.git /root/augustus
cd "/root/augustus"
make clean
make
make install
PATH="/root/augustus/bin:${PATH}"
make unit_test
# configure conda
apt-get install -y wget && rm -rf /var/lib/apt/lists/*

wget \
https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& mkdir /root/.conda \
&& bash Miniconda3-latest-Linux-x86_64.sh -b \
&& rm -f Miniconda3-latest-Linux-x86_64.sh
conda --version
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --add channels r
# install packages using conda
conda install -y -c conda-forge perl perl-text-soundex
conda install -y -c bioconda cd-hit repeatmasker perl-dbd-sqlite perl-perl-unsafe-signals perl-io-all perl-inline-c perl-bioperl perl-forks perl-want perl-bit-vector snap maker
# repeat library
cd /opt && wget https://github.com/lfaino/LoReAn/raw/noIPRS/third_party/software/RepeatMasker.Libraries.tar.gz && \
tar -zxf RepeatMasker.Libraries.tar.gz && rm -rf /opt/conda/share/RepeatMasker/Libraries && \
mv ./Libraries /opt/conda/share/RepeatMasker/. && chmod -R 755 /opt/conda/share/RepeatMasker/Libraries && \
rm -f RepeatMasker.Libraries.tar.gz
%environment
export PATH="${PATH}:/root/mpich2-1.4.1/bin"
export TOOLDIR="/root"
export PATH="${PATH}:/root/hdf5-1.10.1/hdf5/bin"
export RANLIB=ranlib
export PATH="${PATH}:/root/hal/bin"
export PATH="/root/augustus/bin:${PATH}"
%runscript
cd "/root/augustus"
exec /bin/bash "$@"
%startscript
cd "/root/augustus"
exec /bin/bash "$@"
