# Descrição do Repositório

Este repositório armazena os arquivos necessários para criação da imagem Docker e a execução da imagem em container do Serviço de interpolação de dados espaciais.

### O passo a passo aqui demostrado, foi executado no sistema opercional Linux Ubuntu 18.04 LTS

# Pré-requsitos

* Docker: https://docs.docker.com/engine/install/

# Documentação de Referência Docker

* Referência: https://docs.docker.com/engine/reference/commandline/docker/

# Criação de Imagem e Iniciação do Container


1) Baixar o projeto [juawi](https://github.com/jualabs/juawi) do github


2) Criar a imagem (trocar **juawi** pelo nome desejado para a imagem):

	```sh
            docker build --tag juawi .
        ```

3) Criar o container (trocar a primeira ocorrência de **juawi** pelo nome desejado para o container e a segunda pelo nome da imagem criada no passo 3):

	```sh
    docker run \
        --interactive \
        --tty \
        --detach \
        --name juawi \
        --publish 8001:8001 \
        --volume  /juawi/data:/home/juawi/juawi/data/ \
        juawi
    ```

Observação: o mapeamento entre os volumes é necessário para que o container manter os modelos gerdados no formato .Rds salvos no computador hospedeiro.

4) Teste do funcionamento do serviço juawi digite no browser o seguinte url **http://localhost:8001/test** .

5) Outros comandos necessários:

    * Iniciar o serviço dentro do container manualmente (trocar **juawi** pelo nome do container):

	```sh
           docker exec -itd $(docker ps -a -q --filter name=juawi --format="{{.ID}}") /bin/bash -c "Rscript plumber.R"
        ```

    * Acessar o terminal de um container (trocar **juawi** pelo nome do container):

	```sh
    docker exec -it $(docker ps -a -q --filter name=juawi --format="{{.ID}}") /bin/bash
    ```

    * Parar e remover um container (trocar **juawi** pelo nome do container):

	```sh
    docker rm $(docker stop $(docker ps -a -q --filter name=juawi --format="{{.ID}}"))
	```
	
    * Exibir log do container (trocar **juawi** pelo nome do container):

    ```sh
    docker container logs --details -f $(docker ps -a -q --filter name=juawi --format="{{.ID}}")
    ```

    Remove todos os containers parados, todas as imagens dangling e todas as redes não utilizadas:
    ```sh
    docker system prune
	  ```

6) Enviar imagem para o servidor de registro de imagens (trocar o **[servidor_de_registro]** pela url do servidor de registro se estiver salvando as imagems Docker em um servidor de imagens privado diferente do Docker Hub, caso esteja utilizando o Docker Hub executar a parte 2 e 3 deste item):

	1 - Sem o docker Hub
	```sh
	docker push [servidor_de_registro]/juawi:1.0
	```
	**Ou**
	```sh
	docker push [servidor_de_registro]/juawi:latest
	```

	2 - Com o docker Hub 
	```sh
	docker login
	Username:*****
	Password:******
	Login Succeeded
	```
	```sh
	docker push [seu_id_docker_hub]/juawi:1.0
	```
	**Ou**
	```sh
	docker push [seu_id_docker_hub]/juawi:latest
	```


