from django.http import HttpResponse
from django.template import loader

from cluster.models import Cluster

from pick import pick  # install pick using `pip install pick`

from kubernetes import client, config
from kubernetes.client import configuration


def index(request):
    config.load_incluster_config()

    v1 = client.CoreV1Api()
    print("Listing pods with their IPs:")
    ret = v1.list_pod_for_all_namespaces(watch=False)
    pod_list = []
    for i in ret.items:
        print("%s\t%s\t%s" %
              (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
        pod_list.append(
            Cluster(
                name=i.metadata.name,
                pod_ip=i.status.pod_ip,
                namespace=i.metadata.namespace
            )
        )

    context_new = {
        'cluster': pod_list
    }

    template = loader.get_template('index.html')
    return HttpResponse(template.render(context_new, request))
