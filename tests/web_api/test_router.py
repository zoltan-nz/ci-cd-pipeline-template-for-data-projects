from my_hello_world_app.web_api import create_app


def test_config():
    assert not create_app().testing
    assert create_app({"TESTING": True}).testing


def test_index(client):
    # The client is determined in conftest.py which is a pytest configuration setup
    response = client.get("/")
    assert response.data == b"My Hello World App is working..."
