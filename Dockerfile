FROM python:3.11-slim
USER root
WORKDIR /app
COPY . .

CMD ["bin", "bash"]