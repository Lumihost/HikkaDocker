FROM python:3.8-slim AS python-base

# ! `-e DOCKER_HIKKA_ADDRESS=...` and `-e DOCKER_HIKKA_PORT=...` are expected

ENV DOCKER=true
ENV GIT_PYTHON_REFRESH=quiet
ENV PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt update \ 
    && apt install libcairo2 git build-essential -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp/*

# mounting a volume probably already does this..?
RUN mkdir /data

RUN useradd -ms /bin/bash hikkadocker

RUN git clone https://github.com/Lumihost/HikkaDocker /data/Hikka \
    # && chmod -R a+rwx /data \
    && chown -R hikkadocker /data

WORKDIR /data/Hikka

USER hikkadocker

RUN pip install --no-warn-script-location --no-cache-dir -U -r requirements.txt

EXPOSE 8080

CMD ["python", "-m", "hikka"]
