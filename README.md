# ownCloud: Alpine

[![](https://images.microbadger.com/badges/image/owncloud/alpine.svg)](https://microbadger.com/images/owncloud/alpine "Get your own image badge on microbadger.com")

This is our minimal customized [Alpine](https://alpinelinux.org/) base image based on [official Alpine](https://registry.hub.docker.com/_/alpine/). It's only mostly for our testing and infra images you can find on this organization.


## Usage

```bash
docker run -ti \
  --name alpine \
  owncloud/alpine:latest
```


## Build locally

The available versions should be already pushed to the Docker Hub, but in case you want to try a change locally you can always execute the follwiing command to get this image built locally:

```
IMAGE_NAME=owncloud/alpine ./hooks/build
```


## Versions

* [latest](https://github.com/owncloud-docker/alpine/tree/master) available as ```owncloud/alpine:latest``` at [Docker Hub](https://registry.hub.docker.com/u/owncloud/alpine/)


## Volumes

* None


## Ports

* None


## Available environment variables

**None**


## Issues, Feedback and Ideas

Open an [Issue](https://github.com/owncloud-docker/alpine/issues)


## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Felix Boehm](https://github.com/felixboehm)
* [Thomas Boerger](https://github.com/tboerger)


## License

MIT


## Copyright

```
Copyright (c) 2017 Felix Böhm <felix@owncloud.com>
```
