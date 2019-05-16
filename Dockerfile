FROM jupyter/base-notebook

USER root

# Install all OS dependencies for fully functional notebook server
#RUN echo 'deb http://cran.cnr.berkeley.edu/bin/linux/debian buster-cran35/' > /etc/apt/sources.list.d/backports.list


RUN apt-get update && apt-get install -yq --no-install-recommends \
    gnupg2 \
    vim \
    nano \
    ca-certificates \
    wget \
    apt-transport-https \
    gsfonts \
    pkg-config \
    build-essential \
    emacs \
    git \
    jed \
    libxml2-dev \
    libpng-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libunwind-dev \
    texinfo \
    && rm -rf /var/lib/apt/lists/*


#RUN mkdir ~/.gnupg
#RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

#RUN apt-key adv --keyserver keys.gnupg.net --recv-key E19F5F87128899B192B1A2C2AD5F960A256A04AF
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' > /etc/apt/sources.list.d/backports.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key E298A3A825C0D65DFD57CBB651716619E084DAB9

RUN apt-get update && apt-get install -t bionic-cran35 -y \
      r-base=3.6.0-2bionic\
      r-base-core=3.6.0-2bionic  \
      r-base-dev=3.6.0-2bionic \
      r-mathlib=3.6.0-2bionic \
      r-base-html=3.6.0-2bionic \
      r-doc-html=3.6.0-2bionic \
      r-recommended=3.6.0-2bionic

RUN Rscript -e "install.packages('IRkernel')"


# Install R and bioconductor packages for Kouros's notebooks
RUN Rscript -e "install.packages(pkgs = c('ROCR','mvtnorm','pheatmap','formatR'), \
            repos='https://cran.revolutionanalytics.com/', \
            dependencies=TRUE)"
RUN Rscript -e "install.packages(pkgs = c('dendextend', 'rentrez'), \
            repos='https://cran.revolutionanalytics.com/', \
            dependencies=TRUE)"

RUN Rscript -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos = 'https://cloud.r-project.org/'); \ 
                   BiocManager::install()"
                   
RUN Rscript -e "BiocManager::install(c('golubEsets','multtest','qvalue','limma','gage','pheatmap', 'ggbio', 'ShortRead', 'DESeq2', 'dada2', 'KEGG.db'))"

RUN Rscript -e "BiocManager::install(c('pwr','RColorBrewer','GSA','dendextend','pheatmap','cgdsr', 'caret', 'ROCR'))"

RUN Rscript -e "BiocManager::install(c('org.EcK12.eg.db','genefilter','GEOquery'))"


RUN apt-get update && apt-get install -yq --no-install-recommends \
    fastqc default-jre \
    circos \
    parallel \
    time \
    htop \
    bwa \
    samtools \
    tabix \
    picard-tools \
    openjdk-11-jdk \
    openjdk-11-jre \
    sra-toolkit \
    bcftools \
    bedtools \
    vcftools \
    seqtk \
    rna-star \
    lftp \
    && rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes -c bioconda ea-utils  && \
    conda clean -tipsy


USER jovyan
RUN pip install  bash_kernel
RUN python -m bash_kernel.install
RUN pip install multiqc
USER root

RUN Rscript -e "install.packages('tidyverse')"


# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
RUN Rscript -e "IRkernel::installspec()"

