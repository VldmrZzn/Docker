# Docker

[Дополнительная документация к проекту](https://docs.google.com/document/d/1ozOumBZp8PnaU_dQOVLlr08WhPb-_we0Pmy02hIPD7E/edit?usp=sharing)

Этот проект демонстрирует запуск простого Python-скрипта (`counter.py`) в изолированной среде с помощью **Docker** и **Docker Compose**.  
Скрипт может быть заменён на любой другой — структура проекта позволяет легко расширять функциональность.

## Структура проекта

```
 Dockerfile                 # Описание образа 
 docker-compose.yml         # Конфигурация запуска контейнера
 counter.py                 # Пример Python-скрипта
```

# Работа с Dockerfile

Cкачиваем базовый образ osrf/ros:humble-desktop.

`docker pull osrf/ros:humble-desktop`

Создание dockerfile

```
 touch Dockerfile
 nano Dockerfile
```   
Содержание Dockerfile

```
FROM osrf/ros:humble-desktop
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    xpra \
    xterm \
    net-tools \
    nano \
    mc \
    python3 \
    ros-humble-turtlebot3 \
    ros-humble-turtlebot3-simulations \
    ros-humble-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle
RUN echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc
CMD ["bash"]
```

Затем собираем образ с помощью Dockerfile:

`docker build -t ros .`

Запускаем и проверяем созданный образ c примонтированной папкой:

```
docker run -it --rm \
  -v $HOME/Desktop/my_ros:/root/my_ros_ws \
  ros
```

# Docker Compose

Docker Compose позволяет определять и запускать многоконтейнерные приложения Docker. Можно использовать файл docker-compose.yml, чтобы конфигурировать зависимости приложения от других контейнеров и настраивать сетевые параметры.

Создаем docker-compose.yml

```
version: '2'

services:
  ros:
    image: ros
    volumes:
      - ~/Desktop/my_ros_ws:/root/my_ros_ws #здесь нужны ПРОБЕЛЫ,а не tab’ы
    stdin_open: true   # эквивалент -i
    tty: true          # эквивалент -t
    command: python3 /root/my_ros_ws/counter.py
```

version — указывает версию формата файла docker-compose.yml  
services — основной раздел с описанием всех контейнеров (или сервисов), которые нужно запустить.  
my — показывает имя контейнера  
image — указывает на Docker-образ для создания контейнера.   
command — выполняется внутри контейнера после его запуска. В нашем примере python3 /root/my_ros_ws/counter.py -- это команда сервиса my.
