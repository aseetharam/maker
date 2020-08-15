FROM ubuntu:18.04 AS spython-base
LABEL Author Arun Seetharam
LABEL Version v1
LABEL Maintainer arnstrm@iastate.edu
ENV PATH=$PATH:/usr/local/src/snap:/opt/trf/bin:/opt/rmblast-2.10.0/bin:/opt/trf/bin/
ENV ZOE=/usr/local/src/snap/Zoe
ENV PATH=$PATH:/opt/RepeatMasker/util:/opt/RepeatMasker
ENV PATH=$PATH:/opt/maker/bin
ENV PERL5LIB=$PERL5LIB:/opt/RepeatMasker:/opt/maker/lib:/opt/maker/perl/lib
RUN echo "which perl" >> /tests.sh
RUN echo "which maker" >> /tests.sh
RUN echo "which snap" >> /tests.sh
RUN echo "which RepeatMasker" >> /tests.sh
RUN echo "which augustus" >> /tests.sh
RUN echo "echo $AUGUSTUS_CONFIG_PATH" >> /tests.sh
RUN chmod u+x /tests.sh
RUN apt-get update
RUN apt-get install -y build-essential wget curl git autoconf
RUN apt-get install -y gcc g++ make
RUN apt-get install -y zlib1g-dev libgomp1 libgomp1 libpam-systemd-
RUN apt-get install -y gfortran
RUN apt-get install -y perl bioperl libfile-which-perl libtext-soundex-perl libjson-perl liburi-perl libwww-perl
RUN apt-get install -y ncbi-blast+
RUN apt-get install -y hmmer
RUN apt-get install -y cd-hit
RUN apt-get install -y exonerate
RUN apt-get install -y augustus augustus-data augustus-doc
RUN apt-get install -y hwloc-nox libc6 libcr0 libhwloc5 libmpich12 libmpich-dev blcr-util mpich-doc
RUN git clone --recursive https://github.com/KorfLab/SNAP.git /usr/local/src/snap
RUN cd /usr/local/src/snap
RUN git reset --hard a89d68e8346337c155b99697389144dfb5470b0f
RUN make
RUN export PATH=$PATH:/usr/local/src/snap
RUN export ZOE=/usr/local/src/snap/Zoe
RUN cd /opt
RUN wget http://tandem.bu.edu/trf/downloads/trf409.linux64
RUN mkdir -p /opt/trf/bin
RUN mv trf409.linux64 /opt/trf/bin/trf
RUN cd /opt
RUN wget http://www.repeatmasker.org/rmblast-2.10.0+-x64-linux.tar.gz
RUN tar xf rmblast-2.10.0+-x64-linux.tar.gz
RUN rm rmblast-2.10.0+-x64-linux.tar.gz
RUN cd /opt
RUN wget http://www.repeatmasker.org/RepeatMasker-4.1.0.tar.gz
RUN tar xf RepeatMasker-4.1.0.tar.gz
RUN rm RepeatMasker-4.1.0.tar.gz
RUN cd RepeatMasker
RUN perl configure \
-hmmer_dir=/usr/bin \
-rmblast_dir=/opt/rmblast-2.10.0/bin \
-libdir=/opt/RepeatMasker/Libraries \
-trf_prgm=/opt/trf/bin/trf \
-default_search_engine=rmblast
RUN wget https://github.com/lfaino/LoReAn/raw/noIPRS/third_party/software/RepeatMasker.Libraries.tar.gz
RUN rm -rf /opt/RepeatMasker/Libraries
RUN tar -zxf RepeatMasker.Libraries.tar.gz
RUN chmod -R 755 /opt/RepeatMasker/Libraries
RUN rm -f RepeatMasker.Libraries.tar.gz
RUN export PATH=$PATH:/opt/RepeatMasker/util:/opt/RepeatMasker
RUN export PERL5LIB=$PERL5LIB:/opt/RepeatMasker
RUN cd /opt
RUN wget http://yandell.topaz.genetics.utah.edu/maker_downloads/47DA/F2FC/9A91/967425BE163605C14F4A5434EAF7/maker-2.31.11.tgz
RUN tar xf maker-2.31.11.tgz
RUN rm maker-2.31.11.tgz
RUN cd maker/src
RUN echo Y | perl ./Build.PL
RUN ./Build installdeps
RUN ./Build install
CMD /bin/bash /tests.sh
