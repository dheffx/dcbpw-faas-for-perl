# FaaS for Perl with OpenFaaS

## Dependencies

- Docker
- Faas CLI

```shell
curl -sL https://cli.openfaas.com | sudo sh
```

For this example, Docker Swarm will be used to quickly run a single node cluster.

This readme does not go indepth on how to run OpenFaaS. Please refer to the getting started documentation

- https://docs.openfaas.com/contributing/get-started/
- https://docs.openfaas.com/deployment/docker-swarm/

## Getting Started

### Spin up OpenFaaS stack

```shell
docker swarm init
git clone https://github.com/openfaas/faas
cd faas
./deploy_stack.sh
```

OPTIONAL: Add grafana to stack for quick monitoring

```shell
docker service create -d \
  --name=grafana \
  --publish=3000:3000 \
  --network=func_functions \
  stefanprodan/faas-grafana:4.6.3
```

### Pull Perl templates

```shell
faas template pull https://github.com/dheffx/perl-openfaas-template
```

Now when you run `faas-cli new --list`, you will see perl as an available language

```
Languages available as templates:
- perl
- perl-mojo
```

The `perl` template consumes stdin whereas `perl-mojo` handles an http request in a similar fashion as seen in the OpenFaas `node10-express-template`.

For more detail on each template see the README in https://github.com/dheffx/perl-openfaas-template

### Build & Deploy the sample Perl functions

```
faas deploy -f functions/stack.yaml
```

#### Example usage

```
echo | faas invoke hello
echo | faas invoke hello-mojo
echo | faas invoke dump-env | jq

echo "my $x = 'code without strict';" | faas invoke perlcritic | jq

http://127.0.0.1:8080/function/date-endpoints?type=MONTH&intervals=4

http://127.0.0.1:8080/function/dump-env/additional/path?x=y
```

`simple-get` is an example of a function using the `ssl` build option

```yaml
build_options:
  - ssl
```

This installs dependencies for making HTTPs requests (`openssl`, `openssl-dev` and `perl-net-ssleay`) when building the image

```shell
echo "dheffx" | faas invoke simple-get | jq
```

See how the functions auto scale with load

```shell
npm i -g artillery
artillery quick --count 20 -n 100 http://127.0.0.1:8080/function/hello
```

http://127.0.0.1:3000/dashboard/db/openfaas?refresh=5s&orgId=1

admin:admin by default (see up top to add grafana)

### Create, build, and deploy a function

```
faas new my-perl-func --lang perl --prefix $DOCKER_HUB
```

edit `my-perl-func/handler.pm` to add your code, and `cpanfile` to add your deps

```
faas build -f my-perl-func.yml
faas push -f my-perl-func.yml
faas deploy -f my-perl-func.yml
```

OR

```
faas up -f my-perl-func.yml
```

use `--skip-push` if not using registry