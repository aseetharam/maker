FROM ubuntu:18.04
# apt packages to install
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y autoconf
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y libmysql++-dev
RUN apt-get install -y libgsl-dev
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libsuitesparse-dev
RUN apt-get install -y liblpsolve55-dev
RUN apt-get install -y libboost-iostreams-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libbamtools-dev
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libcurl3-dev
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y mpich2 
# apt tools
RUN apt-get install -y ncbi-blast+
RUN apt-get install -y hmmer
RUN apt-get install -y cd-hit
RUN apt-get install -y exonerate
# htslib
RUN git clone https://github.com/samtools/htslib.git /root/htslib
WORKDIR "/root/htslib"
RUN autoheader
RUN autoconf
RUN ./configure
RUN make
RUN make install
# bcftools
RUN git clone https://github.com/samtools/bcftools.git /root/bcftools
WORKDIR "/root/bcftools"
RUN autoheader
RUN autoconf
RUN ./configure
RUN make
RUN make install
# samtools
RUN git clone https://github.com/samtools/samtools.git /root/samtools
WORKDIR "/root/samtools"
RUN autoheader
RUN autoconf -Wno-syntax
RUN ./configure
RUN make
RUN make install
ENV TOOLDIR="/root"
# haltools
WORKDIR /root
RUN wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
RUN tar xzf hdf5-1.10.1.tar.gz
WORKDIR /root/hdf5-1.10.1
RUN ./configure --enable-cxx
RUN make && make install
ENV PATH="${PATH}:/root/hdf5-1.10.1/hdf5/bin"
WORKDIR /root
RUN git clone https://github.com/benedictpaten/sonLib.git
WORKDIR /root/sonLib
RUN make
WORKDIR /root
RUN git clone https://github.com/ComparativeGenomicsToolkit/hal.git
WORKDIR /root/hal
ENV RANLIB=ranlib
RUN make
ENV PATH="${PATH}:/root/hal/bin"
# AUGUSUTS
RUN git clone https://github.com/Gaius-Augustus/Augustus.git /root/augustus
WORKDIR "/root/augustus"
RUN make clean
RUN make
RUN make install
ENV PATH="/root/augustus/bin:${PATH}"
RUN make unit_test
# configure conda
RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --add channels r
# install packages using conda
RUN conda install -y -c conda-forge perl perl-text-soundex
RUN conda install -y -c bioconda cd-hit repeatmasker perl-dbd-sqlite perl-perl-unsafe-signals perl-io-all perl-inline-c perl-bioperl perl-forks perl-want perl-bit-vector snap maker
# repeat library
RUN cd /opt && wget https://github.com/lfaino/LoReAn/raw/noIPRS/third_party/software/RepeatMasker.Libraries.tar.gz && \
    tar -zxf RepeatMasker.Libraries.tar.gz && rm -rf /opt/conda/share/RepeatMasker/Libraries && \
    mv ./Libraries /opt/conda/share/RepeatMasker/. && chmod -R 755 /opt/conda/share/RepeatMasker/Libraries && \
    rm -f RepeatMasker.Libraries.tar.gz
