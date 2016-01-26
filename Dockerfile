FROM centos:6
MAINTAINER  itaru3n <itaru3n@gmail.com>

ENV code_root /code
ENV httpd_conf ${code_root}/httpd.conf

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# add
RUN yum -y update
RUN yum -y install wget
RUN yum -y install jwhois
RUN yum -y install man
RUN yum -y install tig
RUN yum -y install tar
RUN yum -y install which

RUN yum install -y httpd
RUN yum install --enablerepo=epel,remi-php70,remi -y \
                              php \
                              php-cli \
                              php-gd \
                              php-mbstring \
                              php-mcrypt \
                              php-mysqlnd \
                              php-pdo \
                              php-xml \
                              php-intl \
                              php-curl \
                              php-zip \
                              php-zlib \
                              php-openssl \
                              php-xsl \
                              php-posix \
                              php-mbregex \
                              php-mysqli \
                              php-pdo_sqlite \
                              php-xdebug
RUN sed -i -e "s|^;date.timezone =.*$|date.timezone = Asia/Tokyo|" /etc/php.ini


# add
# Install PHP composer
RUN  curl -sS https://getcomposer.org/installer | php && \
                    mv composer.phar /usr/local/bin/composer
# Define working directory.
WORKDIR /home/cakephp
# Define working directory.
WORKDIR /usr/src/app


RUN ["composer", "config", "-g", "github-oauth.github.com", "79625493f2d6ad363d073adf005728465fa1db54"]
RUN ["composer", "create-project", "--prefer-dist", "cakephp/app", "/home/monsterinfo"]


ADD . $code_root
RUN test -e $httpd_conf && echo "Include $httpd_conf" >> /etc/httpd/conf/httpd.conf

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]


# add
# Copy the composer file into place and install dependencies.
ONBUILD ADD composer.json /usr/src/app/composer.json
ONBUILD ADD composer.lock /usr/src/app/composer.lock
ONBUILD RUN composer install --no-dev
# Copy the rest of the application into place.
ONBUILD ADD . /usr/src/app