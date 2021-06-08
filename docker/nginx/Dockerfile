FROM nginx:latest

RUN apt-get update 
RUN apt-get install vim -y

COPY ./config/default.conf /etc/nginx/conf.d/
COPY ./nginx.conf /etc/nginx/nginx.conf



EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
