# FaaS for Perl with Lambda Layers

This example borrows from several existing online repositories, or tutorials. They will be referenced below.

In particular, I've forked two repositories (and will likely push some of this work back) that will be used.

## Dependencies

- Docker
- AWS Account and CLI
- AWS SAM CLI

## Getting started

### Clone example layers and functions

```shell
git clone https://github.com/dheffx/aws-lambda-perl5-layer.git layers
git clone https://github.com/dheffx/aws-lambda-perl5-layer-example.git functions
```

### Build the layers

```shell
make -C layers build-docker-image PERL_VERSION=5.28.1 CONTAINER_TAG=5.28
make -C layers build CONTAINER_TAG=5.28
```

***Note: This can take a few minutes***

This will build a docker image called `lambda-perl-layer-foundation`, then will extract its contents as two zip files.

```shell
ls layers/*.zip
lambda-layer-perl-5.28.zip lambda-layer-perl-5.28-paws.zip
```

The first one is the base Perl runtime. The other is the lib for Paws.

Paws is installed because

- To demonstrate multiple layers for a single function
- When running functions in AWS, you probably want to access other AWS services
- It is a large amount of files that would increase the artifact size for each function that would otherwise vendor it

The base layer image is also used for running Carton to vendor the additional libraries defined in cpanfile for each function.

See the project [README.md](layers/README.md) for more.

### Build the sample functions

Each sample function consists of at least a handler script, such as `handler.pl`. Most of them also contain a `cpanfile`.

The Makefile in `functions/` is set up to use the image made for the layers to build their artifact. Any modules defined in `cpanfile` and bundled.

```shell
make -C functions build CONTAINER_TAG=5.28 FUNC_NAME=simple-yaml
make -C functions build CONTAINER_TAG=5.28 FUNC_NAME=plack
```

Some are just a single file and do not need the build, you can just zip them

```shell
zip -j functions/hello-world/hello-world.zip functions/hello-world/* -x *.zip
zip -j functions/s3-upload/s3-upload.zip functions/s3-upload/* -x *.zip
zip -j functions/python-system-perl/python-system-perl.zip functions/python-system-perl/* -x *.zip
```

The `s3-upload` function utilizes the 2nd layer for Paws

### Create a bucket to store your function artifacts

```shell
aws s3 mb your-perl-faas-project-artifacts
export ARTIFACT_BUCKET=your-perl-faas-project-artifacts
```

### Execute functions locally

use `sam local` commands to execute functions locally

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html

#### Workaround for known bug with SAM

https://github.com/awslabs/aws-sam-cli/issues/947

In short, SAM is not properly extracting layers from zip files for `sam local`.

To get around this, unzip the layers to a temporary directory, and update `template.yaml` to reference them

```yaml
ContentUri: layers/tmp
```

#### Example invocations

Direct Invoke

```shell
sam local invoke HelloWorld --event test/hello.event
sam local invoke SimpleYaml --event test/yaml.event
sam local invoke PythonSystemPerl --event test/hello.event
```

AWS Events

```shell
sam local generate-event s3 put | sam local invoke S3Upload
```

### Package and deploy

```shell
sam package \
  --region $AWS_REGION \
  --template-file template.yml \
  --s3-bucket $ARTIFACT_BUCKET \
  --output-template-file ./out.yml

aws cloudformation deploy \
  --template-file ./out.yml \
  --stack-name perl-faas \
  --capabilities CAPABILITY_IAM
```

#### Test the s3 upload function

```
perl test/generate-files.pl outdir
aws sync outdir/ s3://your-upload-bucket/landing
rm -rf outdir
aws ls s3://your-upload-bucket/processed
```

## Reference

The two repositories that was forked for this example:

- https://github.com/moznion/aws-lambda-perl5-layer
- https://github.com/moznion/aws-lambda-perl5-layer-example

Here are a few other articles out there on this topic

- https://medium.com/@avijitsarkar123/aws-lambda-custom-runtime-really-works-how-i-developed-a-lambda-in-perl-9a481a7ab465

- https://medium.com/foundations/playing-with-perl-based-lambda-functions-37c12ca01ae6

I would not recommend using the bootstrap file found in these articles, but otherwise there is some good information in them.

AWS Docs

- https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
- https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html
