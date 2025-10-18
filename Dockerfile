# Используем ROS Humble
FROM osrf/ros:humble-desktop

# Отключаем интерактивные запросы при установке
ENV DEBIAN_FRONTEND=noninteractive

# Обновляем и устанавливаем пакеты
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

# Устанавливаем переменные окружения
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle

# Добавляем source в /etc/bash.bashrc, чтобы он работал для всех пользователей
RUN echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc

# Стартовая команда
CMD ["bash"]
