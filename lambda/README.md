# Lambda Layers for Perl

This example takes ideas from several existing online tutorials and examples. The reference material can be found at the bottom.

The premise is to use a docker image to export the layer components into zip files that are published as layers

## Dependencies

- Docker
- AWS Account and CLI

## Build or pull the docker image

### Build

```shell
cd layers
make build
```

This make command is simply running `docker build` then tagging the image with a version

### Pull

TODO: validate when pushed

```shell
docker pull dheffx/perl-lambda
```

## Export layers as zip files

The Docker image is built with a script and command to automatically export the necessary layers.

```shell
cd layers
make export
```

This is effectively running `layers/script/export.sh` on the container, while mounting your local directory to output the zip files.

You will end up with three zip files, one for each layer:

```shell
$ ls -ltr /zips/
total 26420
-rw-r--r-- 1 root root   666887 Mar 30 16:06 perl-base.zip
-rw-r--r-- 1 root root 23665836 Mar 30 16:06 perl-paws.zip
-rw-r--r-- 1 root root     1221 Mar 30 16:06 perl-runtime.zip
```

## Publish to AWS

```shell
cd layers
make publish
```

This will publish all three of the layers using `publish-layer-version` via AWS CLI

If you want to publish a specific layer, you can do so with publish-<layer_name>

```shell
make publish-perl-base
make publish-perl-paws
make publish-perl-runtime
```

## Reference

- https://github.com/moznion/aws-lambda-perl5-layer

Utilizes Docker to install Perl on top of a base image provided by LambCI

- https://medium.com/@avijitsarkar123/aws-lambda-custom-runtime-really-works-how-i-developed-a-lambda-in-perl-9a481a7ab465

- https://medium.com/foundations/playing-with-perl-based-lambda-functions-37c12ca01ae6

Two tutorials on creating a lambda layer for Perl

- https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html