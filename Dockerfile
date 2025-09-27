FROM node:20-slim
WORKDIR /app
COPY package*.json .
RUN ["npm", "ci"]

ENV NODE_ENV=production
COPY . .
EXPOSE 8080

USER node
CMD ["node", "server.js"]