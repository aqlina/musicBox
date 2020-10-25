FROM rocker/tidyverse:3.4.4

MAINTAINER Alina Tselinina <tselinina@gmail.com>

RUN apt-get -y update -qq \ 
  && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgsl0-dev \
    libpq-dev

RUN R -e "remotes::install_github('aqlina/musicBox@main', dependencies = 'Imports')"

EXPOSE 9999

CMD ["R", "-e", "musicBox::launch_app()"]
