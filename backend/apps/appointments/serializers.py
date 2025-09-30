from rest_framework import serializers
from .models import Appointment, AppointmentReminder, VirtualQueue

class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = '__all__'

class AppointmentReminderSerializer(serializers.ModelSerializer):
    class Meta:
        model = AppointmentReminder
        fields = '__all__'

class VirtualQueueSerializer(serializers.ModelSerializer):
    class Meta:
        model = VirtualQueue
        fields = '__all__'
