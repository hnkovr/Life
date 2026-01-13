import pytest
from django.contrib.auth.models import User
from rest_framework.test import APIClient
from datetime import date


@pytest.mark.django_db
def test_list_shows_only_own_tasks():
    u1 = User.objects.create_user(username="u1", email="u1@example.com", password="p1")
    u2 = User.objects.create_user(username="u2", email="u2@example.com", password="p2")

    c1 = APIClient()
    r = c1.post("/api/auth/login", {"email": "u1@example.com", "password": "p1"}, format="json")
    c1.credentials(HTTP_AUTHORIZATION=f"Bearer {r.json()['access']}")

    c2 = APIClient()
    r2 = c2.post("/api/auth/login", {"email": "u2@example.com", "password": "p2"}, format="json")
    c2.credentials(HTTP_AUTHORIZATION=f"Bearer {r2.json()['access']}")

    # u1 creates two tasks
    c1.post("/api/tasks/", {"title": "A", "domain": "personal"}, format="json")
    c1.post("/api/tasks/", {"title": "B", "domain": "work"}, format="json")
    # u2 creates one task
    c2.post("/api/tasks/", {"title": "C", "domain": "work"}, format="json")

    assert len(c1.get("/api/tasks/").json()) == 2
    assert len(c2.get("/api/tasks/").json()) == 1


@pytest.mark.django_db
def test_filters_domain_status_due_date_and_search():
    u = User.objects.create_user(username="u", email="u@example.com", password="p")
    c = APIClient()
    r = c.post("/api/auth/login", {"email": "u@example.com", "password": "p"}, format="json")
    c.credentials(HTTP_AUTHORIZATION=f"Bearer {r.json()['access']}")

    # create tasks with different attributes
    c.post("/api/tasks/", {"title": "Pay bills", "domain": "personal", "status": "todo"}, format="json")
    c.post("/api/tasks/", {"title": "Prepare report", "domain": "work", "status": "doing"}, format="json")
    c.post("/api/tasks/", {"title": "Wait for reply", "domain": "work", "status": "waiting", "due_date": str(date.today())}, format="json")

    assert len(c.get("/api/tasks/?domain=work").json()) == 2
    assert len(c.get("/api/tasks/?status=todo").json()) == 1
    assert len(c.get(f"/api/tasks/?due_date={date.today():%Y-%m-%d}").json()) == 1
    # search by title
    assert len(c.get("/api/tasks/?search=report").json()) == 1


@pytest.mark.django_db
def test_create_without_title_returns_400():
    u = User.objects.create_user(username="u", email="u@example.com", password="p")
    c = APIClient()
    r = c.post("/api/auth/login", {"email": "u@example.com", "password": "p"}, format="json")
    c.credentials(HTTP_AUTHORIZATION=f"Bearer {r.json()['access']}")
    resp = c.post("/api/tasks/", {"domain": "personal"}, format="json")
    assert resp.status_code == 400

