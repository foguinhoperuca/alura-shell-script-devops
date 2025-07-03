FROM node:latest
# MAINTAINER Douglas Quintanilha # MAINTAINER is deprected
LABEL MAINTAINER="Jefferson Campos"
ENV NODE_ENV=development
COPY . /var/www
WORKDIR /var/www
RUN npm install 
ENTRYPOINT ["npm", "start"]
EXPOSE 3000
