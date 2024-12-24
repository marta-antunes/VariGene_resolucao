# Use an official Ubuntu as a parent image
FROM ubuntu:22.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    git \
    dos2unix \
    unzip \
    vcftools \
    && rm -rf /var/lib/apt/lists/*

# Install fastp
RUN wget http://opengene.org/fastp/fastp && \
    chmod a+x fastp && \
    mv fastp /usr/local/bin/

# Install BWA from GitHub
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    make && \
    cp bwa /usr/local/bin/ && \
    cd .. && \
    rm -rf bwa

# Install Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    tar -xjf samtools-1.11.tar.bz2 && \
    cd samtools-1.11 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf samtools-1.11 samtools-1.11.tar.bz2

# Install Bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.11/bcftools-1.11.tar.bz2 && \
    tar -xjf bcftools-1.11.tar.bz2 && \
    cd bcftools-1.11 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf bcftools-1.11 bcftools-1.11.tar.bz2

# Install Java 17
RUN apt-get update && apt-get install -y openjdk-21-jre

# Install snpEff
RUN wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip && \
    unzip snpEff_latest_core.zip -d /usr/local/ && \
    rm snpEff_latest_core.zip && \
    mkdir -p /opt/tools/snpEff && \
    cp /usr/local/snpEff/snpEff.jar /opt/tools/snpEff/snpEff.jar && \
    echo '#!/bin/sh' > /usr/local/bin/snpeff && \
    echo 'java -jar /opt/tools/snpEff/snpEff.jar "$@"' >> /usr/local/bin/snpeff && \
    chmod +x /usr/local/bin/snpeff

# Create a directory for the analysis
RUN mkdir /usr/local/analysis

# Set the working directory
WORKDIR /usr/local/analysis

# Copy the analysis script into the container
COPY analysis.sh /usr/local/analysis/analysis.sh

# Make the analysis script executable
RUN dos2unix /usr/local/analysis/analysis.sh && \
    chmod +x /usr/local/analysis/analysis.sh