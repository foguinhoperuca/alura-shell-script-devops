FROM node:14
WORKDIR /app-node
# only in build time
ARG PORT=6000
ENV PORT=$PORT
# can be the value direct as in 3000
EXPOSE $PORT
COPY . /app-node
RUN npm install
ENTRYPOINT npm start
