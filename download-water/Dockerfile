# 使用官方 Python 运行时作为基础镜像
FROM python:3.12-slim

# 设置环境变量，防止 Python 生成 .pyc 文件并缓冲输出
ENV PYTHONUNBUFFERED=1
ENV TZ=Asia/Shanghai

# 设置工作目录
WORKDIR /app

# 安装运行依赖 + Chrome，单层完成并清理 apt 缓存
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    unzip \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgomp1 \
    libjpeg62-turbo \
    zlib1g \
    fonts-liberation \
    libnss3 \
    xdg-utils \
    tzdata \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/trusted.gpg.d/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY *.py ./

EXPOSE 18883

# 单 worker 保证后台任务状态在进程内共享，多线程处理并发请求
CMD ["gunicorn", "-w", "1", "--threads", "4", "-b", "0.0.0.0:18883", "--timeout", "120", "main:app"]