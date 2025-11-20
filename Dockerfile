FROM node:20.19.5-alpine3.22 AS builder
WORKDIR /opt/frontend
COPY package*.json ./
COPY patches ./patches
RUN npm install
# Copy and build the application
# COPY . .

ARG OPIK_VERSION
ARG SENTRY_ENABLED
ARG SENTRY_DSN

ENV VITE_APP_VERSION=${OPIK_VERSION}
ENV VITE_SENTRY_ENABLED=${SENTRY_ENABLED}
ENV VITE_SENTRY_DSN=${SENTRY_DSN}
ENV NODE_OPTIONS="--max-old-space-size=8192"

ARG BUILD_MODE=production
RUN npm run build -- --mode $BUILD_MODE

FROM amazonlinux:2023

RUN yum update -y && \
  yum install -y nginx-1.26.3 && \
  yum clean all

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
