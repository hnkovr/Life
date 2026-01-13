import pytest
from rest_framework.test import APIClient


@pytest.mark.django_db
def test_register_duplicate_email_returns_400():
    c = APIClient()
    payload = {"email": "dup@example.com", "password": "pass12345"}
    r1 = c.post("/api/auth/register", payload, format="json")
    assert r1.status_code == 201
    r2 = c.post("/api/auth/register", payload, format="json")
    assert r2.status_code == 400


@pytest.mark.django_db
def test_register_missing_password_returns_400():
    c = APIClient()
    r = c.post("/api/auth/register", {"email": "nope@example.com"}, format="json")
    assert r.status_code == 400

