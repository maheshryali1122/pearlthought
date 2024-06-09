FROM node:14
EXPOSE 3000
RUN git clone https://github.com/simonplend/example-app-nodejs-backend-react-frontend.git && \
    cd example-app-nodejs-backend-react-frontend && \
    npm install && \
    npm run build
WORKDIR /example-app-nodejs-backend-react-frontend
CMD ["npm", "start", "--host", "0.0.0.0"]
