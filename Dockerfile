FROM centos:centos6
RUN echo -e "[cloudera-manager]\nname=Cloudera Manager\nbaseurl=http://archive.cloudera.com/cm4/redhat/6/x86_64/cm/4/\ngpgcheck = 0">/etc/yum.repos.d/cloudera-manager.repo
RUN yum -y update && yum groupinstall -y 'development tools' \
 && yum -y install vim wget lsof jdk cloudera-manager-agent openssl-devel \
    sqlite-devel bzip2-devel openssh-server openssh-clients
RUN wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz && \
  tar -zxvf Python-2.7.9.tgz && cd Python-2.7.9 &&./configure && make && make install

RUN wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz \
  && tar -xvf setuptools-1.4.2.tar.gz && cd setuptools-1.4.2 && python2.7 setup.py install

RUN curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 - && \
  easy_install supervisor
RUN echo 'root:toor' |  chpasswd
COPY supervisord.conf /etc/supervisord.conf
COPY config.ini /etc/cloudera-scm-agent/config.ini
CMD ["/usr/local/bin/supervisord"]
EXPOSE 22
