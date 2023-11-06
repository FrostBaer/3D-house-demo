#choose image
FROM node:20 AS BUILD_IMAGE
WORKDIR /app
#copy package.json
COPY package*.json .
#install the used packages
RUN npm install
#copy local files to workdir (except files in .dockerignore)
COPY . .
#build app
RUN npm run build

#run in production
FROM node:20 AS PRODUCTION_IMAGE
WORKDIR /app

COPY --from=BUILD_IMAGE /app/dist/ /app/dist/
EXPOSE 8080

COPY package*.json .
#port config
COPY vite.config.ts .
RUN npm install typescript

EXPOSE 8080
CMD [ "npm", "run", "preview" ]