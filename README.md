# CI/CD Pipeline Template for Data Projects

## How to use this template?

Install Python v3.8. Suggested way to install Python on your developer machine is `pyenv`. On macOS, you can use the following command.

```
$ brew install pyenv
$ pyenv install 3.8.0
$ pyenv global 3.8.0
```

Install `pipenv`.

```
$ pip install pipenv
```

Run `setup` script from this project.

```
$ pipenv run setup
```

### Run the application

In development mode on http://localhost:5000

```
$ pipenv run server-watch
```

In production mode on http://localhost:8080

```
$ pipenv run server-prod
```

### Linting

```
$ pipenv run lint
```

### Code formatter

```
$ pipenv run format
```

### Type checker

```
$ pipenv run lint-types
```

### Testing

You can run test only once or in watch mode, which will rerun the test when files change detected.

```
$ pipenv run test
$ pipenv run test-watch
```

Check the coverage report in your browser

```
pipenv run cov-html
```

Pipenv run options:

| Pipenv task               | Description                                                                          |
| ------------------------- | ------------------------------------------------------------------------------------ |
| `pipenv run setup`        | Setup local pip environment. Run it first.                                           |
| `pipenv run clean`        | Clean up temp files.                                                                 |
| `pipenv run lock-req`     | Update `requirements.txt`. Run it if you added or upgraded some packages in Pipfile. |
| `pipenv run server-prod`  | Run your Flask app in production.                                                    |
| `pipenv run server-watch` | Run your Flask app in dev mode with watch task.                                      |
| `pipenv run lint`         | Run pylint.                                                                          |
| `pipenv run lint-types`   | Run `mypy` type checking linter.                                                     |
| `pipenv run format`       | Run the `black` code formatter.                                                      |
| `pipenv run test`         | Run `pytest`.                                                                        |
| `pipenv run test-watch`   | Run `pytest` in watch mode.                                                          |
| `pipenv run cov`          | Run code coverage report.                                                            |
| `pipenv run cov-html`     | Generate a code coverage report in html format.                                      |
| `pipenv run build`        | Build python binary version                                                          |
| `pipenv run build-docker` | Run a local docker image                                                             |

## Kubernetes and Google Cloud

## Pipeline stages

- There are four stages in the pipeline: `test`, `review`, `staging`, `production`.
- The `review` stage is used only in development branch and it deploys a preview version of the app in under a temporary subdomain. The subdomain is the branch name.
- Docker image names has to be tagged. The tag name is a short hash string which is generated from the actual git commit hash.

## Dynamic Kubernetes manifest files

- Kubernetes manifest yaml files are originally static files.
- We use `envsubs` shell command to replace placeholders with environment variable values.

## Environment variables

| Environment Variable       | Description                                                                                                                                                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| KUBE_NAMESPACE             | Kubernetes namespace. It changes based on the deployment stage. E.g. `my-app-review`, `my-app-staging`, `my-app-production`.                                                                                                                      |
| KUBE_DEPLOYMENT_NAME       | Pod deployment name. E.g.`my-app-deployment`                                                                                                                                                                                                      |
| KUBE_APP_NAME              | The app name used as label mainly. E.g. `my-app`                                                                                                                                                                                                  |
| KUBE_IMAGE_NAME            | Important! The docker image name with the registry url: `gcr.io/my-project-id/my-app:hash`                                                                                                                                                        |
| KUBE_CONTAINER_PORT        | Depend on your application. Check `Dockerfile`'s `EXPOSE` value. E.g. `8080`                                                                                                                                                                      |
| KUBE_SERVICE_NAME          | The service name of the load balancer. E.g. `my-app-preview-load-balancer-service`.                                                                                                                                                               |
| KUBE_SERVICE_EXTERNAL_PORT | Service exposes the app container on this port. It can be used to connect directly to the app or in an Ingress controller. E.g. `9090`                                                                                                            |
| KUBE_INGRESS_NAME          | Ingress controller creates subdomains. This is just the name of the Controller. E.g. `my-app-router`.                                                                                                                                             |
| KUBE_PUBLIC_APP_DOMAIN     | The public domain address. It can be the production domain or a subdomain. E.g. `example.com`, `staging.example.com`, `some-review-branch.1.2.3.4.nip.io`                                                                                         |
| KUBE_IMAGE_PULL_POLICY     | Use "Always" in production, Docker for Mac Kubernetes needs "Never" value for locally built images.                                                                                                                                               |
| KUBE_EXAMPLE_SECRET        | A base64 encoded json string which will be written out using `example-secret.json` filename in a Secret Volume and attached to `/home/app/secrets/`. Search for `example-secret` and `EXAMPLE_SECRET` strings to see, how can you manage secrets. |

## Google Cloud environment variables

This template repository supports Google Cloud out of the box. Google Cloud access keys and variables are stored in environment variables. These environment variables are used only in Gitlab CI. In your repository seetings, you can setup environment variables which are injected in Gitlab Runner.

In your local environment you can store keys in `./secrets` folder. Never commit any key or id in your source control system.

| Environment variable   | Description                                                                             |
| ---------------------- | --------------------------------------------------------------------------------------- |
| GC_PROJECT_ID          | Google Cloud project ID                                                                 |
| GC_SERVICE_ACCOUNT_KEY | A json content for Google Cloud access                                                  |
| GC_CLUSTER_NAME        | The name of your cluster                                                                |
| GC_ZONE                | The geographic zone where your cluster is hosted                                        |
| GC_BASE_DOMAIN         | The base domain name where your cluster is exposed, usually setup by ingress controller |
| GC_EXAMPLE_SECRET      | An example secret if your project need it                                               |

## Manifest templates

These files are placed in `kubernetes` folder and they are used in `.gitlab-ci.yaml`.

| Template file     | Role                                                                                                                                                                    |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `namespace.yaml`  | Setup the namespace of the stage.                                                                                                                                       |
| `deployment.yaml` | Deploy the app pod.                                                                                                                                                     |
| `service.yaml`    | Load balancer setup.                                                                                                                                                    |
| `ingress.yaml`    | Ingress controller configuration to create unique subdomains for review apps. Stage and production configuration will be deployed once and probably never gonna change. |
| `secret.yaml`     | Secrets used to inject a whole file or a key value pair in a deployed container.                                                                                        |

## Inject docker image tag in the app

The docker image tag is injected in the Flask application. We use an ARG value in Dockerfile. It is mapped to an environment variable, so the Flask app can access it using `os.getenv`.

There is a custom `/version` route is implemented in the Flask app to print out the injected tag.

## Implementing Secrets

- Creating a `./secrets` folder for account-key `json` files.
- Google Cloud SDK default behaviour is to read `json` key from a path which listed in `GOOGLE_APPLICATION_CREDENTIALS` env variable.
- Add secrets content to `.gitignore` to prevent unexpected sharing.
- Open a `Volume` in `Dockerfile` for `/home/app/secrets` where Kubernetes can attach a Secret volume.
- Setup the volume in `deployment.yaml`.

Important notes for using `base64` for encoding. This tool insert a new line after each 76 characters which brakes an encoded json file. Use `base64 -w 0` format to disable line wrapping.

## Debug Kubernetes deployment in your local environment

Deploy the application in local Kubernetes environment. Local Kubernetes is Docker For Mac for instance.

- Setup a default Kubernetes context on your local machine using Docker for Mac.
- Switch the default context to your local.

```
$ kubectl config set-context docker-desktop
```

- Use `octant` to check your cluster: https://github.com/vmware-tanzu/octant
- [Install NGINX Ingress Controller on Docker for Mac](https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac)
- Build a local image.

```
$ pipenv run build-docker-local
```

- Update `./scripts/local-kubernetes-deployment.sh` environmental variables.
- Use free dns resolver to be able to use dynamic subdomains. E.g. my_hello_world_app.127.0.0.1.nip.io, my_hello_world_app.lvh.me, my_hello_world_app.127.0.0.1.xip.io
- Run local Kubernetes deployment `pipenv run deploy-kubernetes-local`. Please make sure that the `envsubst` command line tool is installed in your machine. On macOS, `envsubst` is part of the `gettext` library. Use `brew install gettext` first and link to your PATH with `brew link --force gettext`.
- See the log with `kubectl logs -n your-namespace pod-name` where your-namespace what you setup in your script and pod name can be various.
- Get the name of the pod with `kubectl pods -n your-namespace`

## Gitlab Runner Test

You can use the local version of Gitlab Runner to test your `.gitlab-ci.yml` implementation. The script is in `scripts` folder: `./scripts/gitlab-runner-test.sh`.

Install Gitlab Runner on your local machine (on macOS):

```
$ brew install gitlab-runner
```

Add Google Cloud secret keys to your `./secrets` folder, adjust your environment variables in the script and just run it to see, how is that work.

```
$ sh ./scripts/gitlab-runner-test.sh
```

## Implementation tasks:

- [x] Add basic Flask app to web_api folder
- [x] Add simple pytest
- [x] Add editorconfig
- [x] Add LICENSE file
- [x] Add python project files (`Pipfile`, `pylintrc`, `requirements.txt`, `setup.cfg`, `setup.py`)
- [x] Dockerfile for production
- [x] Add Gitlab CI
- [x] Add strict typing support with `mypy`
- [x] Add Kubernetes manifest templates

### Format Markdown files with prettier

Prerequisite: Node.js and `prettier` command line tool. (https://prettier.io/)

```
prettier "**/*.md" --write --parser=markdown
```
