import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient


@pytest.mark.django_db
def test_login_invalid_credentials_returns_400():
    client = APIClient()
    # no such user
    resp = client.post(
        "/api/auth/login",
        {"email": "nouser@example.com", "password": "x"},
        format="json",
    )
    assert resp.status_code == 400


@pytest.mark.django_db
def test_refresh_with_invalid_token_returns_400():
    client = APIClient()
    resp = client.post("/api/auth/refresh", {"refresh": "invalid"}, format="json")
    assert resp.status_code == 400


@pytest.mark.django_db
def test_logout_is_stateless_204():
    client = APIClient()
    resp = client.post("/api/auth/logout", {}, format="json")
    assert resp.status_code == 204

