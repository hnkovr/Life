from django.urls import include, path
from rest_framework.routers import DefaultRouter

from apps.tasks.views import TaskViewSet
from apps.authentication.views import AuthView

router = DefaultRouter()
router.register(r"tasks", TaskViewSet, basename="task")

auth = AuthView.as_view
urlpatterns = [
    path("auth/register", auth({"post": "register"})),
    path("auth/login", auth({"post": "login"})),
    path("auth/refresh", auth({"post": "refresh"})),
    path("auth/logout", auth({"post": "logout"})),
    path("", include(router.urls)),
]
