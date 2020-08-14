Bootstrap: docker
From: maoj/augustus


%post
apt-get update
apt-get install -y gfortran
apt-get install -y ncbi-blast+
apt-get install -y hmmer
apt-get install -y cd-hit
apt-get install -y exonerate
# install anaconda
wget https://repo.anaconda.com/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh -O ~/anaconda.sh && \
  bash ~/anaconda.sh -b -p /usr/local/anaconda && \
  rm ~/anaconda.sh
export PATH="/usr/local/anaconda/bin:$PATH"
conda update -y conda
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --add channels r
# mpich2
cd /root
wget http://www.mpich.org/static/downloads/1.4.1/mpich2-1.4.1.tar.gz
tar xzf mpich2-1.4.1.tar.gz
cd /root/mpich2-1.4.1
./configure
make && make install
PATH="${PATH}:/root/mpich2-1.4.1/bin"
# install conda packages
conda install -y -c conda-forge \
                    perl \
                    perl-text-soundex
conda install -y -c bioconda \
                    cd-hit \
                    repeatmasker \
                    perl-dbd-sqlite \
                    perl-perl-unsafe-signals \
                    perl-io-all \
                    perl-inline-c \
                    perl-bioperl \
                    perl-forks \
                    perl-want \
                    perl-bit-vector \
                    snap \
                    maker
# repeat library
cd /opt && wget https://github.com/lfaino/LoReAn/raw/noIPRS/third_party/software/RepeatMasker.Libraries.tar.gz && \
  tar -zxf RepeatMasker.Libraries.tar.gz && rm -rf /opt/conda/share/RepeatMasker/Libraries && \
  mv ./Libraries /opt/conda/share/RepeatMasker/. && chmod -R 755 /opt/conda/share/RepeatMasker/Libraries && \
cd /opt/conda/share/RepeatMasker/Libraries
for f in *.hmm; do hmmpress $f; done
cd /opt
rm -f RepeatMasker.Libraries.tar.gz
