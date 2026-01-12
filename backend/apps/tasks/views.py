from django.utils import timezone
from rest_framework import filters, permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Task
from .serializers import TaskSerializer


class IsOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.user == request.user


class TaskViewSet(viewsets.ModelViewSet):
    serializer_class = TaskSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwner]
    filter_backends = [filters.SearchFilter]
    search_fields = ["title", "description"]

    def get_queryset(self):
        qs = Task.objects.filter(user=self.request.user)
        domain = self.request.query_params.get("domain")
        status_param = self.request.query_params.get("status")
        due_date = self.request.query_params.get("due_date")
        if domain:
            qs = qs.filter(domain=domain)
        if status_param:
            qs = qs.filter(status=status_param)
        if due_date:
            qs = qs.filter(due_date=due_date)
        return qs.order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    # Use default permission_classes (IsAuthenticated + IsOwner for object-level checks)

    def perform_update(self, serializer):
        instance = serializer.save()
        return instance

    @action(detail=True, methods=["post"])
    def complete(self, request, pk=None):
        task = self.get_object()
        task.status = Task.Status.DONE
        task.completed_at = timezone.now()
        task.save(update_fields=["status", "completed_at", "updated_at"])
        return Response(TaskSerializer(task).data, status=status.HTTP_200_OK)
