from os import getenv

from typing import Optional, Dict
from flask import Flask


def create_app(test_config: Optional[Dict] = None) -> Flask:
    """ App factory method to initialize the application with given configuration """

    app: Flask = Flask(__name__)

    if test_config is not None:
        app.config.from_mapping(test_config)

    @app.route("/")
    def index():  # pylint: disable=unused-variable
        return "My Hello World App is working..."

    @app.route("/version")
    def version():  # pylint: disable=unused-variable
        """
        DOCKER_IMAGE_TAG is passed in the app from Dockerfile as ARG.
        It should be setup in docker build task..
        It is used in .gitlab-ci.yaml to pass the hash of the latest commit as docker image tag.
        E.g. docker build --build-arg docker_image_tag="my-version" -t my-image-name:my-version .
        We can check the deployed
        """
        return getenv("DOCKER_IMAGE_TAG")

    return app
