from django.http import HttpResponse
from django.template import loader
from kubernetes import client, config

from cluster.models import Cluster


def index(request):
    config.load_incluster_config()
    # config.load_kube_config()

    server_addr = client.CoreApi().get_api_versions().server_address_by_client_cid_rs[0].server_address
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

    model_data = {
        'cluster': pod_list,
        'server_address': server_addr
    }

    template = loader.get_template('index.html')
    return HttpResponse(template.render(model_data, request))
