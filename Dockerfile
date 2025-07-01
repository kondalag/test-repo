FROM rocker/r-ver:4.4.1

# Set the environment variable for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install OpenJDK 11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean

# Verify the installation by printing the Java version
RUN java -version

# Set JAVA_HOME environment variable (optional, but recommended)
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Add JAVA_HOME to the PATH (optional, but useful)
ENV PATH=$JAVA_HOME/bin:$PATH
 
#RUN R CMD javareconf
RUN apt-get update -y && apt-get install -y libcurl3-gnutls apt-transport-https libssl-dev libgdal-dev
RUN apt upgrade openssl curl -y

RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    dirmngr \
    gnupg \
    ca-certificates \
    apt-transport-https \
    curl \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libtiff-dev \
    libudunits2-dev \
    libgeos-dev \
    libproj-dev \
    libcairo2-dev \
    libxt-dev \
    libnlopt-dev

# Download and build GDAL 3.8.0
RUN apt-get update && \
    apt-get install -y wget build-essential cmake \
    libproj-dev libgeos-dev libsqlite3-dev libnetcdf-dev && \
    wget https://download.osgeo.org/gdal/3.8.0/gdal-3.8.0.tar.gz && \
    tar -xzf gdal-3.8.0.tar.gz && \
    cd gdal-3.8.0 && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) && \
    make install && \
    ldconfig


# Install R packages
RUN R -e "install.packages(c('shiny','rJava','shinydashboard','zoo','dbplyr','DT','shinycssloaders','shinyBS','shinyjs','shinyalert','formattable','ggthemes','reticulate','openxlsx', 'data.table','XML','sqldf','kableExtra','splitstackshape','shinyWidgets','janitor','mschart', 'Hmisc', 'remotes', 'devtools','rnaturalearthdata','rnaturalearthhires','spData','latticeExtra'), repos =structure(c(CRAN='http://cran.us.r-project.org')))"
RUN R -e "install.packages(c('numDeriv', 'SparseM', 'MatrixModels', 'minqa', 'RcppEigen', 'carData', 'pbkrtest', 'quantreg', 'lme4', 'corrplot', 'car', 'ggrepel', 'ggsci', 'cowplot', 'ggsignif', 'polynom', 'rstatix'), repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages(c('remotes'),repos='http://cran.us.r-project.org')"
RUN R -e 'remotes::install_version("ggplotify", version = "0.1.2", repos = "http://cran.us.r-project.org")'
RUN R -e 'remotes::install_version("flextable", version = "0.8.3", repos = "http://cran.us.r-project.org")'
RUN R -e 'remotes::install_version("officer", version = "0.4.4", repos = "http://cran.us.r-project.org")'
RUN R -e "remotes::install_version('ggpubr', version = '0.6.0', repos = 'http://cran.us.r-project.org')"
RUN R -e "remotes::install_version('sf', version = '1.0.14', repos = 'http://cran.us.r-project.org')"
RUN R -e "remotes::install_version('rnaturalearth', version = '1.0.1', repos = 'http://cran.us.r-project.org')"
RUN R -e 'remotes::install_github("ropensci/rnaturalearthhires")'
RUN R -e 'remotes::install_version("shinydashboardPlus", version = "2.0.3", repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/sf/sf_1.0-14.tar.gz", repos=NULL, type="source")'
RUN R -e "install.packages(c('processx', 'tools','tinytest', 'testthat', 'webshot2','magick', 'pdftools', 'locatexec'), repos = 'http://cran.us.r-project.org')"
RUN R -e 'install.packages("https://cran.r-project.org/src/contrib/doconv_0.3.2.tar.gz", repos=NULL, type="source")'
RUN R -e "install.packages(c('aws','aws.s3','aws.signature','readr','jose','ggplotify'), repos =structure(c(CRAN='http://cran.us.r-project.org')))"
RUN R -e "install.packages(c('maps','webshot'), repos =structure(c(CRAN='http://cran.us.r-project.org')))"
