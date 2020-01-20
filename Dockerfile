FROM python:3.8.1-slim

RUN pip install --upgrade pip

RUN mkdir /home/app
RUN addgroup --gid 1024 app-group
RUN useradd --uid 1024 --gid 1024 --non-unique --comment "" --home-dir /home/app app
RUN chown 1024:1024 /home/app
RUN chmod 775 /home/app
RUN chmod g+s /home/app
WORKDIR /home/app
USER app

ARG docker_image_tag='pass this value when build the image with docker build --build-arg docker_image_tag=demo'

ENV FLASK_APP=my_hello_world_app
ENV FLASK_ENV=production
ENV DOCKER_IMAGE_TAG=$docker_image_tag

ENV PATH=/home/app/.local/bin:${PATH}

COPY requirements.txt ./requirements.txt
RUN pip install --user -r requirements.txt

COPY ./dist ./dist
RUN pip install --user ./dist/*

EXPOSE 8080

CMD ["waitress-serve", "--call", "my_hello_world_app:start"]
