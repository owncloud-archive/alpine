# ownCloud: Alpine

This is our minimal customized [Alpine](https://alpinelinux.org/) base image based on [official Alpine](https://registry.hub.docker.com/_/alpine/). It's only mostly for our testing and infra images you can find on this organization.


## Versions

* [latest](latest/)

## Usage

```bash
docker run -ti \
  --name alpine \
  owncloud/alpine:latest
```


## Build locally

The available versions should be already pushed to the Docker Hub, but in case you want to try a change locally you can always execute the following command to get this image built locally:

```
IMAGE_NAME=owncloud/alpine ./hooks/build
```


## Versions

* [latest](https://github.com/owncloud-docker/alpine/tree/master) available as ```owncloud/alpine:latest``` at [Docker Hub](https://registry.hub.docker.com/u/owncloud/alpine/)


## Issues, Feedback and Ideas

Open an [Issue](https://github.com/owncloud-docker/alpine/issues)


## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Thomas Boerger](https://github.com/tboerger)
* [Felix Boehm](https://github.com/felixboehm)


## License

MIT


## Copyright

```
Copyright (c) 2017 Thomas Boerger <tboerger@owncloud.com>
```
