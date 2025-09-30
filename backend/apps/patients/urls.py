from django.urls import path
from . import views

urlpatterns = [
    path('', views.PatientListCreateView.as_view(), name='patient-list-create'),
    path('<int:pk>/', views.PatientDetailView.as_view(), name='patient-detail'),
    path('profile/', views.patient_profile, name='patient-profile'),
    path('profile/update/', views.update_patient_profile, name='update-patient-profile'),
]
