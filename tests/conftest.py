import pytest

from my_hello_world_app.web_api import create_app


@pytest.fixture
def app():
    test_app = create_app({"TESTING": True})

    yield test_app


@pytest.fixture
def client(app):
    return app.test_client()
