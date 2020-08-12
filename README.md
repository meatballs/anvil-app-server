# meatballs/anvil-app-server
The [anvil](https://anvil.works) [app server](https://github.com/anvil-works/anvil-runtime).

## Usage

Example snippets to get started creating a container from this image:

### Using docker
```
docker create \
    --name=anvil-app-server \
    -p 3030:3030 \
    -v </path/to/your/anvil/app/>:/app \
    -v <your volume name for the db>:/anvil-data \
    meatballs/anvil-app-server
```

### Using docker-compose
```
version: '3'
services:
  anvil:
    image: meatballs/anvil-app-server
    ports:
      - 3030:3030
    volumes:
      - ./anvil_app:/app
      - anvil-data:/anvil-data
volumes:
    anvil-data:
```
