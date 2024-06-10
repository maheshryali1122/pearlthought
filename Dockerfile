FROM node:14
EXPOSE 3000
RUN  git clone https://github.com/maheshryali1122/pearlthoughtsassignment.git && \
    cd pearlthoughtsassignment && \
    npm install && \
    npm run build
WORKDIR /pearlthoughtsassignment
CMD ["npm", "start", "--host", "0.0.0.0"]
