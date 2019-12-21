# ベースイメージ取得
FROM centos:centos7.7.1908
MAINTAINER z.kimura

# 既存ライブラリのアップデートと必要ライブラリのインストール
RUN yum -y -q update && \
    curl -sL https://rpm.nodesource.com/setup_12.x | bash - && \
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    yum -y -q install which tree sudo git gcc make bzip2 rubygems-devel openssl-devel \
    readline-devel zlib-devel gcc-c++ sqlite-devel nodejs yarn

# rbenvとruby-buildをインストール
ENV PATH ~/.rbenv/bin:$PATH
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    cd ~/.rbenv && src/configure && make -C src
#オフィシャルのreadmeだと以下のコマンドが必要だが、dockerビルドが止まっちゃうので除外
#RUN ~/.rbenv/bin/rbenv init
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile && \
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# rubyとruby on railsをインストール
ENV PATH ~/.rbenv/shims:/usr/local/bin:$PATH
RUN rbenv install 2.6.5 && \
    rbenv global 2.6.5 && \
    gem install rails -v 6.0.1

#ローカルのrailsディレクトリをコンテナ内にコピー
RUN mkdir /kiff
ADD kiff /kiff

#railsの起動
WORKDIR /kiff
RUN gem install bundler:2.1.2 && \
    bundle update rails && \
    bundle install && \
    yarn install --check-files
EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0"]


# sudoユーザーを作成
#ARG UID=501
#ARG USR=hop
#ARG PASSWORD=hophop
#RUN useradd -m --uid ${UID} --groups wheel ${USR} && echo ${USR}:${PASSWORD} | chpasswd
#USER ${UID}

# expose port
#EXPOSE 3000
