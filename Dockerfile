# start from base
FROM centos:centos7.7.1908

ENV PATH ~/.rbenv/bin:$PATH
# install system-wide deps
RUN yum -y -q update
RUN yum -y -q install which tree sudo git gcc make bzip2 rubygems-devel openssl-devel readline-devel zlib-devel

# install rbenv & ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN cd ~/.rbenv && src/configure && make -C src
#the official instllation but comment-out, buiilding cequence is stopped by the command below.
#RUN ~/.rbenv/bin/rbenv init
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# install ruby & ruby on rails
ENV PATH ~/.rbenv/shims:/usr/local/bin:$PATH
RUN rbenv install 2.6.5
RUN rbenv global 2.6.5
RUN gem install rails -v 6.0.1

# make a sudo-user to operate and change the user
# ARG UID=501
# ARG USR=hop
# ARG PASSWORD=hophop
# RUN useradd -m --uid ${UID} --groups wheel ${USR} && echo ${USR}:${PASSWORD} | chpasswd
# USER ${UID}

# expose port
#EXPOSE 3000
