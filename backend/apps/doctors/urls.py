from django.urls import path
from . import views

urlpatterns = [
    path('', views.DoctorListCreateView.as_view(), name='doctor-list-create'),
    path('<int:pk>/', views.DoctorDetailView.as_view(), name='doctor-detail'),
    path('profile/', views.doctor_profile, name='doctor-profile'),
    path('schedule/', views.DoctorScheduleView.as_view(), name='doctor-schedule'),
]
