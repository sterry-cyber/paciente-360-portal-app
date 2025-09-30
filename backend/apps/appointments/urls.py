from django.urls import path
from . import views

urlpatterns = [
    path('', views.AppointmentListCreateView.as_view(), name='appointment-list-create'),
    path('<int:pk>/', views.AppointmentDetailView.as_view(), name='appointment-detail'),
    path('patient/', views.PatientAppointmentsView.as_view(), name='patient-appointments'),
    path('doctor/', views.DoctorAppointmentsView.as_view(), name='doctor-appointments'),
    path('queue/', views.VirtualQueueView.as_view(), name='virtual-queue'),
]
