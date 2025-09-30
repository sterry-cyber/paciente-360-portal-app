from django.urls import path
from . import views

urlpatterns = [
    path('', views.NotificationListCreateView.as_view(), name='notification-list-create'),
    path('<int:pk>/', views.NotificationDetailView.as_view(), name='notification-detail'),
    path('user/', views.UserNotificationsView.as_view(), name='user-notifications'),
    path('mark-read/', views.MarkNotificationReadView.as_view(), name='mark-notification-read'),
    path('settings/', views.NotificationSettingsView.as_view(), name='notification-settings'),
]
