#=====================================================================================================================================
# Imagem base da imagem rbase.
FROM r-base:latest AS rbase
#=====================================================================================================================================
# Labels.
LABEL maintainer.name="Juá Labs - DEINFO/UFRPE"
LABEL maintainer.email="Jualabs@jualabs.com"
LABEL maintainer.author="Wellington Luiz"
LABEL maintainer.creation="Setembro 2020"

#=====================================================================================================================================
RUN apt-get update --allow-releaseinfo-change && \
    apt-get install -y apt-utils && \
    apt-get install -y libsodium-dev && \
    apt-get install -y libcurl4-openssl-dev && \
    apt-get install -y curl -y && \
    apt-get install -y libssl-dev -y && \
    apt-get install -y libcurl4-openssl-dev -y
    

#=====================================================================================================================================
# Variaveis de ambiente.
From rbase AS ambiente_production

# Esses valores nao devem ser alterados.
ENV USER=juwai
ENV HOME_JUAWI=/home/juawi
ENV HOME_SERVICE=/home/juawi/juawi

#=====================================================================================================================================
# Cria usuario juawi.
RUN adduser --home ${HOME_JUAWI} juawi

#=====================================================================================================================================
# Adiciona pastas webinterpolation com os script.
COPY juawi ${HOME_SERVICE}/
COPY bibliotecas.R ${HOME_JUAWI}/
WORKDIR ${HOME_SERVICE}/
RUN Rscript ${HOME_JUAWI}/bibliotecas.R

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 8001

ENTRYPOINT ["R", "-e", \
"pr <- plumber::plumb('Main.R'); \
pr$run(host = '0.0.0.0', port= 8001)"]

CMD ["Main.R"]
