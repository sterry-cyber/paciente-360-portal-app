from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Notification, NotificationTemplate, NotificationSettings
from .serializers import NotificationSerializer

class NotificationListCreateView(generics.ListCreateAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

class NotificationDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

class UserNotificationsView(generics.ListAPIView):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

class MarkNotificationReadView(generics.UpdateAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

class NotificationSettingsView(generics.RetrieveUpdateAPIView):
    queryset = NotificationSettings.objects.all()
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]
