# @author Alfred Röttger Rydahl
#
# @description This Dockerfile will build and install a container which can recognize cards.
#

# Get the working repo with cpu
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04

# Update
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y python3.5

# Install
RUN apt-get install -y apt-utils build-essential
RUN apt-get install -y pciutils vim wget git make kmod python-pip python3-pip python-numpy unzip net-tools

## OpenCV 3.4 Installation ##
RUN apt-get install -y build-essential cmake
RUN apt-get install -y qt5-default libvtk6-dev
RUN apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
RUN apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev
RUN apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy
RUN apt-get install -y unzip wget

# Download and unzip OpenCV
RUN wget https://github.com/opencv/opencv/archive/3.4.0.zip
RUN unzip 3.4.0.zip
RUN rm 3.4.0.zip
WORKDIR /opencv-3.4.0
RUN mkdir build
WORKDIR /opencv-3.4.0/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DWITH_TBB=ON -DWITH_OPENMP=ON -DWITH_IPP=ON -DWITH_NVCUVID=ON -DWITH_CUDA=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF ..
RUN make -j7
RUN make install
RUN ldconfig

# Python
RUN pip install --upgrade pip
RUN pip install gdown
RUN pip3 install Flask request jsonify flask_restful Pillow

# Clone Darknet
WORKDIR /
RUN git clone https://github.com/pjreddie/darknet.git
WORKDIR darknet/

# Build darknet
RUN sed -i 's/GPU=.*/GPU=1/' Makefile
RUN sed -i 's/CUDNN=.*/CUDNN=1/' Makefile
RUN sed -i 's/OPENMP=.*/OPENMP=1/' Makefile
RUN sed -i 's/OPENCV=.*/OPENCV=1/' Makefile
RUN make -j7

## Download and compile YOLO ##
WORKDIR /
RUN git clone https://github.com/JustusGammelgaard/YOLO.git
WORKDIR /YOLO
RUN git checkout DockerYOLO
RUN git pull
RUN apt-get install -y pkg-config
RUN pip3 install pkgconfig cython numpy
ENV GPU 1
ENV CUDA_HOME=/usr/local/cuda
ENV OPENCV 1
RUN python3 setup.py build_ext --inplace

# Download Tiny weights
RUN wget -O weights/yolov3-tiny-20000.weights https://trainingweight.imfast.io/yolov3-tiny-20000.weights

## Download models
RUN chmod +x download_models.sh
RUN ./download_models.sh

# Extract
#RUN unzip 0dockerstuff.zip
#RUN rm 0dockerstuff.zip

## Run flask-endpoint here ##
#ADD ./api.py /YOLO/api.py

# Entry
CMD ["./runserver.sh"]
##CMD ["bash"]

