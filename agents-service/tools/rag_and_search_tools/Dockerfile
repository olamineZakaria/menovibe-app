FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

EXPOSE 8080

CMD ["uvicorn", "mcp_server:starlette_app", "--host", "0.0.0.0", "--port", "8080"]