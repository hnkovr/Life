import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIClient


@pytest.mark.django_db
def test_task_crud_and_complete():
    user = User.objects.create_user(username="u1", email="u1@example.com", password="pass12345")
    client = APIClient()
    # login
    resp = client.post("/api/auth/login", {"email": "u1@example.com", "password": "pass12345"}, format="json")
    access = resp.json()["access"]
    client.credentials(HTTP_AUTHORIZATION=f"Bearer {access}")

    # create
    resp = client.post("/api/tasks/", {"title": "Task A", "domain": "personal"}, format="json")
    assert resp.status_code == 201
    tid = resp.json()["id"]

    # list
    resp = client.get("/api/tasks/")
    assert resp.status_code == 200
    assert len(resp.json()) == 1

    # update
    resp = client.patch(f"/api/tasks/{tid}/", {"status": "doing"}, format="json")
    assert resp.status_code == 200
    assert resp.json()["status"] == "doing"

    # complete
    resp = client.post(f"/api/tasks/{tid}/complete/")
    assert resp.status_code == 200
    assert resp.json()["status"] == "done"

    # delete
    resp = client.delete(f"/api/tasks/{tid}/")
    assert resp.status_code == 204

