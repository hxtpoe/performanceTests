class php5 {
	$version = '55w' # or 54w or empty

	exec {"add_webtatic_repo" :
		path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
		command => 'rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm',
		user 	=> 'root',
		creates => "/etc/yum.repos.d/webtatic.repo"
	}

    file {'add_phpinfo':
      path    => '/var/www/html/index.php',
      ensure  => present,
      content => '<?php phpinfo();',
    }

    file {'add_mongodb_repo':
      path    => '/etc/yum.repos.d/mongodb.repo',
      ensure  => present,
      content => "[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1",
    }
    ->
	package {
		'httpd' :
	 		ensure => installed;
		"php${version}.x86_64" :
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
	exec {"install_composer" :
		path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
		command => 'curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer',
		user 	=> 'root',
		creates => '/usr/local/bin/composer',
	}
	->
	exec {"install_mongo_from_pecl" :
		path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
		command => 'pecl install mongo',
		user 	=> 'root',
		creates => '/usr/lib64/php/modules/mongo.so',
	}
	->
	exec {'add_json.ini':
		path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
		command => 'printf "\npriority=20\nextension=json.so \n" > /etc/php.d/json.ini',
		user 	=> 'root',
		notify 	=> Service[httpd],
		creates => '/etc/php.d/json.ini'
    }
    ->
	exec {'add_mongo.ini':
		path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
		command => 'printf "\npriority=30\nextension=mongo.so \n" > /etc/php.d/mongo.ini',
		user 	=> 'root',
		notify 	=> Service[httpd],
		creates => '/etc/php.d/mongo.ini',
	}

    file { "/var/www/html/jmeter":
    	ensure 	=> "directory",
    	owner  	=> "vagrant",
    	group  	=> "vagrant",
    	mode   	=> 775,
	}
	->
    exec {'clone_project' :
    	path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/bin",
    	command => 'git clone https://github.com/hxtpoe/performanceTests.git /var/www/html/jmeter/',
   		creates => '/var/www/html/jmeter/.git/',
     	user    => 'vagrant',
		timeout => 0
     }

	service {'httpd' :
	    ensure 		=> running,
        enable 		=> true,
        hasrestart 	=> true,
        hasstatus 	=> true,
	}

    service {'mongod' :
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
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
