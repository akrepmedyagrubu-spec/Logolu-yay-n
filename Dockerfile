FROM ubuntu:22.04

RUN apt update && apt install -y ffmpeg python3 python3-pip

WORKDIR /app
COPY . .

RUN mkdir -p hls
RUN chmod +x run.sh

EXPOSE 10000

CMD ["bash", "run.sh"]
