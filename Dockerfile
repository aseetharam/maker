FROM maoj/augustus AS spython-base
RUN apt-get update
RUN apt-get install -y gfortran
RUN apt-get install -y ncbi-blast+
RUN apt-get install -y hmmer
RUN apt-get install -y cd-hit
RUN apt-get install -y exonerate
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh -O ~/anaconda.sh && \
bash ~/anaconda.sh -b -p /usr/local/anaconda && \
rm ~/anaconda.sh
RUN export PATH="/usr/local/anaconda/bin:$PATH"
RUN conda update -y conda
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --add channels r
RUN cd /root
RUN wget http://www.mpich.org/static/downloads/1.4.1/mpich2-1.4.1.tar.gz
RUN tar xzf mpich2-1.4.1.tar.gz
RUN cd /root/mpich2-1.4.1
RUN ./configure
RUN make && make install
RUN PATH="${PATH}:/root/mpich2-1.4.1/bin"
RUN conda install -y -c conda-forge \
perl \
perl-text-soundex
RUN conda install -y -c bioconda \
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
RUN cd /opt && wget https://github.com/lfaino/LoReAn/raw/noIPRS/third_party/software/RepeatMasker.Libraries.tar.gz && \
tar -zxf RepeatMasker.Libraries.tar.gz && rm -rf /opt/conda/share/RepeatMasker/Libraries && \
mv ./Libraries /opt/conda/share/RepeatMasker/. && chmod -R 755 /opt/conda/share/RepeatMasker/Libraries && \
cd /opt/conda/share/RepeatMasker/Libraries
RUN for f in *.hmm; do hmmpress $f; done
RUN cd /opt
RUN rm -f RepeatMasker.Libraries.tar.gz
