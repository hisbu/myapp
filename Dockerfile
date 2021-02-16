FROM nginx

#setworkdir
WORKDIR /usr/share/nginx/html
# copy file from build directory
COPY build/ .
#expose port 80
EXPOSE 80
#start nginx
CMD ["nginx","-g","daemon off;"]