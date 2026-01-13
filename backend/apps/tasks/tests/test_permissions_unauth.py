import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIClient


@pytest.mark.django_db
def test_tasks_list_unauthorized_returns_401():
    client = APIClient()
    resp = client.get("/api/tasks/")
    assert resp.status_code in (401, 403)


@pytest.mark.django_db
def test_cannot_access_others_task():
    # user1 creates task
    u1 = User.objects.create_user(username="u1", email="u1@example.com", password="p1")
    u2 = User.objects.create_user(username="u2", email="u2@example.com", password="p2")
    c1 = APIClient()
    r1 = c1.post("/api/auth/login", {"email": "u1@example.com", "password": "p1"}, format="json")
    c1.credentials(HTTP_AUTHORIZATION=f"Bearer {r1.json()['access']}")
    created = c1.post("/api/tasks/", {"title": "Secret", "domain": "personal"}, format="json").json()

    # user2 tries to retrieve or modify
    c2 = APIClient()
    r2 = c2.post("/api/auth/login", {"email": "u2@example.com", "password": "p2"}, format="json")
    c2.credentials(HTTP_AUTHORIZATION=f"Bearer {r2.json()['access']}")

    # Should be 404 due to queryset scoping (or 403 if object-level check triggers)
    get_resp = c2.get(f"/api/tasks/{created['id']}/")
    assert get_resp.status_code in (403, 404)
    patch_resp = c2.patch(f"/api/tasks/{created['id']}/", {"title": "Hacked"}, format="json")
    assert patch_resp.status_code in (403, 404)

