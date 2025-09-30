from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from django.conf import settings

# Configurar Celery
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'paciente360.settings')

app = Celery('paciente360')

# Configurar Celery usando la configuración de Django
app.config_from_object('django.conf:settings', namespace='CELERY')

# Descubrir tareas automáticamente
app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
