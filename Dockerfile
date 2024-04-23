FROM nginx:latest
RUN rm /usr/share/nginx/html/index.html
RUN echo "bjm" > /usr/share/nginx/html/index.html
EXPOSE 80