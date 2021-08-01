# FROM node:alpine
FROM alpine:latest

# set the default NODE_ENV to production
# for dev/test build with: docker build --build-arg NODE=development .
# and the testing npms will be included
ARG NODE=production
ENV NODE_ENV ${NODE}

# set New Relic APM agent to run without config file
ENV NEW_RELIC_NO_CONFIG_FILE=true

# copy package info early to install npms and delete npm command
WORKDIR /usr/src/app
COPY package*.json ./
RUN apk -U add curl jq bash nodejs npm python3 py3-pip && \
  pip3 install awscli netaddr && \
  npm install

# copy the code
COPY . .
HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f -s http://localhost:3000/health/ || exit 1
EXPOSE 3000
ENTRYPOINT ["bash","/usr/src/app/startup.sh"]
