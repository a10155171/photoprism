# Ubuntu 24.04 LTS (Noble Numbat)
FROM photoprism/develop:240911-noble

## Alternative Environments:
# FROM photoprism/develop:armv7    # ARMv7 (32bit)
# FROM photoprism/develop:noble    # Ubuntu 24.04 LTS (Noble Numbat)
# FROM photoprism/develop:mantic   # Ubuntu 23.10 (Mantic Minotaur)
# FROM photoprism/develop:lunar    # Ubuntu 23.04 (Lunar Lobster)
# FROM photoprism/develop:jammy    # Ubuntu 22.04 LTS (Jammy Jellyfish)
# FROM photoprism/develop:impish   # Ubuntu 21.10 (Impish Indri)
# FROM photoprism/develop:bookworm # Debian 12 (Bookworm)
# FROM photoprism/develop:bullseye # Debian 11 (Bullseye)
# FROM photoprism/develop:buster   # Debian 10 (Buster)

# Set default working directory.
WORKDIR "/go/src/github.com/photoprism/photoprism"

# set miniconda path
ENV PATH="/miniconda3/bin:${PATH}"
ARG PATH="/miniconda3/bin:${PATH}"

# install htop and miniconda
RUN apt update && \
    apt install -y htop && \
    curl https://repo.anaconda.com/miniconda/Miniconda3-py39_24.7.1-0-Linux-x86_64.sh -o Miniconda3.sh && \
    bash Miniconda3.sh -b -p /miniconda3 && \
    rm Miniconda3.sh && \
    rm -rf /var/lib/apt/lists/*

# install python packages to base
RUN conda install -y conda-forge::numpy=1.21.1 Pillow=10.2.0 h5py=3.8.0 &&\
    conda install -y -c pytorch pytorch=1.12.1 torchvision &&\
    conda clean -a -y
    
# Copy source to image.
COPY . .
COPY --chown=root:root /scripts/dist/ /scripts/

CMD /miniconda3/bin/python ExpansionNet_v2/server.py --load_path ExpansionNet_v2/rf_model.pth
