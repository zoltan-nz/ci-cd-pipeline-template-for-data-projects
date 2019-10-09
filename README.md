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
| `pipenv run lint-types` | Run `mypy` type checking linter.
| `pipenv run format`       | Run the `black` code formatter.                                                      |
| `pipenv run test`         | Run `pytest`.                                                                        |
| `pipenv run test-watch`   | Run `pytest` in watch mode.                                                          |
| `pipenv run cov`          | Run code coverage report.                                                            |
| `pipenv run cov-html`     | Generate a code coverage report in html format.                                      |
| `pipenv run build`        | Build python binary version                                                          |
| `pipenv run build-docker` | Run a local docker image                                                             |



## Implementation tasks:

- [x] Add basic Flask app to web_api folder
- [x] Add simple pytest
- [x] Add editorconfig
- [x] Add LICENSE file
- [x] Add python project files (`Pipfile`, `pylintrc`, `requirements.txt`, `setup.cfg`, `setup.py`)
- [x] Dockerfile for production
- [x] Add Gitlab CI
- [x] Add strict typing support with `mypy`

### Format Markdown files with prettier

Prerequisite: Node.js and `prettier` command line tool. (https://prettier.io/)

```
prettier "**/*.md" --write --parser=markdown
```
