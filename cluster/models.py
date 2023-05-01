from django.db import models


class Cluster(models.Model):
    name = models.CharField(max_length=255)
    pod_ip = models.CharField(max_length=255)
    namespace = models.CharField(max_length=255)
