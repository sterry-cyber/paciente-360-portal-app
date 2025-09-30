from django.urls import path
from . import views

urlpatterns = [
    path('', views.MedicalRecordListCreateView.as_view(), name='medical-record-list-create'),
    path('<int:pk>/', views.MedicalRecordDetailView.as_view(), name='medical-record-detail'),
    path('patient/', views.PatientMedicalRecordsView.as_view(), name='patient-medical-records'),
    path('lab-results/', views.LabResultView.as_view(), name='lab-results'),
    path('imaging-results/', views.ImagingResultView.as_view(), name='imaging-results'),
]
