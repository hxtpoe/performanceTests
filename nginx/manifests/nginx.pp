class php5 {
  $version = '55w' # or 54w or empty

  exec {"add_webtatic_repo" :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm',
    user    => 'root',
    creates => "/etc/yum.repos.d/webtatic.repo"
  }

  # file {'add_phpinfo':
  #   path    => '/usr/share/nginx/html/index.php',
  #   content => '<?php phpinfo();',
  #   ensure  => present
  # }
  ->
  file {'add_nginx_repo':
    path    => '/etc/yum.repos.d/nginx.repo',
    ensure  => present,
    owner  => 'root',
    content => '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1'
  }
  ->
  file {'add_mongodb_repo':
    path    => '/etc/yum.repos.d/mongodb.repo',
    ensure  => present,
    owner  => 'root',
    content => '[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1'
  }
  ->
  package {
    'nginx.x86_64' :
    ensure => installed;
    "php${version}-fpm.x86_64" :
    ensure => installed;
    "php${version}-cli.x86_64" :
    ensure => installed;
    "php${version}-common.x86_64" :
    ensure => installed;
    "php${version}-devel.x86_64" :
    ensure => installed;
    "php${version}-intl.x86_64" :
    ensure => installed;
    "php${version}-mbstring.x86_64" :
    ensure => installed;
    "php${version}-pdo.x86_64" :
    ensure => installed;
    "php${version}-xml.x86_64" :
    ensure => installed;
    "php${version}-xmlrpc.x86_64" :
    ensure => installed;
    "php${version}-pear.noarch" :
    ensure => installed;
    "php${version}-opcache.x86_64" :
    ensure => installed;
    "mongodb-org-server.x86_64" :
    ensure => installed;
    "mongodb-org.x86_64" :
    ensure => installed;
    "git" :
    ensure => installed;
  }
  ->
  exec {"install_mongo_from_pecl" :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'pecl install mongo',
    user  => 'root',
    creates => '/usr/lib64/php/modules/mongo.so'
  }
  ->
  exec {'add_json.ini':
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'printf "\npriority=20\nextension=json.so \n" > /etc/php.d/json.ini',
    user  => 'root',
    notify  => Service['php-fpm'],
    creates => '/etc/php.d/json.ini'
  }
  ->
  exec {'add_mongo.ini':
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'printf "\npriority=30\nextension=mongo.so \n" > /etc/php.d/mongo.ini',
    user  => 'root',
    notify  => Service['php-fpm'],
    creates => '/etc/php.d/mongo.ini',
  }
  ->
  exec {'set_timezone':
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'printf "date.timezone = \"Europe/Warsaw\" \n" >> /etc/php.ini',
    user  => 'root',
    notify  => Service['php-fpm'],
  }
  ->
  file {'config virtual host':
    path    => '/etc/nginx/conf.d/default.conf',
    ensure  => present,
    owner  => 'root',
    content => '
server {
    server_name jmeter;
    root /var/www/html/jmeter/web;

    location / {
        # try to serve file directly, fallback to app.php
        try_files $uri /app.php$is_args$args;
    }

    location ~ ^/(app|app_dev|config)\.php(/|$) {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTPS off;
    }

    error_log /var/log/nginx/project_error.log;
    access_log /var/log/nginx/project_access.log;
}

  '
  }
  ->
  file {'config nginx':
    path    => '/etc/nginx/nginx.conf',
    ensure  => present,
    owner  => 'root',
    content => '
        user  nginx;
        worker_processes  1;

        error_log  /var/log/nginx/error.log warn;
        pid        /var/run/nginx.pid;


        events {
            worker_connections  1024;
        }


        http {
            include       /etc/nginx/mime.types;
            default_type  application/octet-stream;

            log_format  main  \'$remote_addr - $remote_user [$time_local] "$request" \'
                              \'$status $body_bytes_sent "$http_referer" \'
                              \'"$http_user_agent" "$http_x_forwarded_for"\';

            access_log  /var/log/nginx/access.log  main;

            sendfile        on;
            #tcp_nopush     on;

            keepalive_timeout  65;

            #gzip  on;

            include /etc/nginx/conf.d/*.conf;
            include /etc/nginx/sites-enabled/*;
        }'
  }
  ->
  service {'mongod' :
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
  }
  ->
  service {'php-fpm' :
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
  }
  ->
  service {'nginx' :
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
  }
  ->
  exec {"install_composer" :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer',
    user    => 'root',
    creates => '/usr/local/bin/composer',
  }
  ->
  file { "/var/www/html/jmeter/":
    ensure    => "directory",
    owner    => "vagrant",
    group    => "vagrant",
    mode    => 775,
  }
  ->
  exec {'clone_project' :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'git clone https://github.com/hxtpoe/performanceTests.git /var/www/html/jmeter/',
    creates => '/var/www/html/jmeter/.git/',
    user    => 'vagrant',
    timeout => 0
  }

  exec {"add_new_rule" :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT',
    user    => 'root'
  }
  ->
  exec {"save_iptables" :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'service iptables save',
    user    => 'root'
  }
  ->
  exec {"restart_iptables" :
    path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    command => 'service iptables restart',
    user    => 'root'
  }
}


include php5
