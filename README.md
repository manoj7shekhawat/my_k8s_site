# Steps to run application
``gunicorn --bind=:8000 --workers=3 my_k8s_site.wsgi``

``python manage.py runserver``
#### Mac M1 issue for docker platform issues
``docker build --platform=linux/amd64  -t my-k8s-site .``
``docker tag d513a224515a manoj7shekhawat/my-k8s-site:v20230430-3``
``docker push manoj7shekhawat/my-k8s-site:v20230430-3``