FROM yonatanph/logicdemo:latest

LABEL maintainer "ivanmar@checkpoint.com"

COPY sources.list /etc/apt/sources.list

COPY web/sushi/ /var/www

COPY menu /usr/lib/cgi-bin
RUN chown www-data:www-data /var/www/index.html

EXPOSE 80

COPY main.sh /

ENTRYPOINT ["/main.sh"]
CMD ["default"]

