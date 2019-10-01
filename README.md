# CI/CD Pipeline Template for Data Projects

Pipenv run options:

| Pipenv task               | Description                                                                          |
| ------------------------- | ------------------------------------------------------------------------------------ |
| `pipenv run setup`        | Setup local pip environment. Run it first.                                           |
| `pipenv run clean`        | Clean up temp files.                                                                 |
| `pipenv run lock-req`     | Update `requirements.txt`. Run it if you added or upgraded some packages in Pipfile. |
| `pipenv run server-prod`  | Run your Flask app in production.                                                    |
| `pipenv run server-watch` | Run your Flask app in dev mode with watch task.                                      |
| `pipenv run lint`         | Run pylint.                                                                          |
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
- [x] Add Gitlab CI, Procfile

### Format Markdown files with prettier

Prerequisite: Node.js and `prettier` command line tool. (https://prettier.io/)

```
prettier "**/*.md" --write --parser=markdown
```
