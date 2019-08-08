# CI/CD Pipeline Template for Data Projects

Implementation notes:

- Add basic Flask app to web_api folder
- Add simple pytest
- Add editorconfig
- Add LICENSE file
- Add python project files (`Pipfile`, `pylintrc`, `requirements.txt`, `setup.cfg`, `setup.py`)

Pipenv run options:

| Pipenv task               | Description |
| ------------------------- | ----------- |
| `pipenv run setup`        |             |
| `pipenv run clean`        |             |
| `pipenv run lock-req`     |             |
| `pipenv run server-prod`  |             |
| `pipenv run server-watch` |             |
| `pipenv run lint`         |             |
| `pipenv run format`       |             |
| `pipenv run test`         |             |
| `pipenv run test-watch`   |             |
| `pipenv run cov`          |             |
| `pipenv run cov-html`     |             |
| `pipenv run build`        |             |
