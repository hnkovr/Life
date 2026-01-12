import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient


@pytest.mark.django_db
def test_register_login_refresh_flow():
    client = APIClient()

    # Register
    resp = client.post(
        "/api/auth/register",
        {"email": "u1@example.com", "password": "pass12345"},
        format="json",
    )
    assert resp.status_code == 201

    # Login
    resp = client.post(
        "/api/auth/login",
        {"email": "u1@example.com", "password": "pass12345"},
        format="json",
    )
    assert resp.status_code == 200
    tokens = resp.json()
    assert "access" in tokens and "refresh" in tokens

    # Refresh
    resp = client.post(
        "/api/auth/refresh",
        {"refresh": tokens["refresh"]},
        format="json",
    )
    assert resp.status_code == 200
    assert "access" in resp.json()

