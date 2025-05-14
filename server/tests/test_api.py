from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_verify_images_returns_text():
    response = client.get("/verify-images")
    assert response.status_code == 200
    assert response.text == "test"
