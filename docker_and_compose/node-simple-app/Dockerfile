FROM node:latest
# MAINTAINER Jefferson Campos # MAINTAINER is deprecated in favor of LABEL
LABEL MAINTAINER="Jefferson Campos"
ENV NODE_ENV=production
ENV PORT=3000
COPY . /var/www
WORKDIR /var/www
RUN npm install
ENTRYPOINT ["npm", "start"]
EXPOSE $PORT
