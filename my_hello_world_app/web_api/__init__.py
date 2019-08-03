from flask import Flask

from my_hello_world_app.web_api.router import create_app


def start() -> Flask:
    return create_app()
