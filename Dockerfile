FROM node:latest as tools
WORKDIR /app
COPY package.json package-lock.json ./

# If you have native dependencies, you'll need extra tools
# RUN apk add --no-cache make gcc g++ python3

RUN npm ci --prod

# Then we copy over the modules from above onto a `slim` image
FROM node:slim

# If possible, run your container using `docker run --init`
# Otherwise, you can use `tini`:
# RUN apk add --no-cache tini
# ENTRYPOINT ["/sbin/tini", "--"]

WORKDIR /app
COPY --from=tools /app .
COPY . .
CMD ["node", "server.js"]
