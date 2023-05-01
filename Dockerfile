# syntax=docker/dockerfile:1
FROM python:3.9.15
# Sets an environmental variable that ensures output from python is sent straight to the terminal without buffering it first
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Sets the container's working directory to /code
WORKDIR /code
# Copies all files from our local project into the container
ADD . /code
# runs the pip install command for all packages listed in the requirements.txt file
RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "my_k8s_site.wsgi"]
