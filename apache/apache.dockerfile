FROM httpd:alpine

# override default httpd.conf with our local version
# to fetch the default httpd.conf from the container run
# docker run --rm httpd:alpine cat /usr/local/apache2/conf/httpd.conf > httpd.conf
ADD ./httpd.conf /usr/local/apache2/conf/httpd.conf

# add custom vhosts
ADD ./httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

# create the /var/www/html directory, -p for creating the parent
# directories if they're not present
# change the owner of the directory to dev
RUN mkdir -p /var/www/html && chown www-data:www-data /var/www/html
