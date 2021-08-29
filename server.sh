docker build -t trade:server .
docker container stop trade-server || true
docker container rm trade-server || true
docker run -p 8080:8080 -v $(pwd)/tmp/config.json:/app/tmp/config.json -d --name trade-server trade:server
