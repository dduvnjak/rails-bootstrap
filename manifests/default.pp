include rvm

$ruby_version = 'ruby-2.1.5'

rvm_system_ruby {
  $ruby_version:
    ensure      => 'present',
    default_use => false,
    build_opts  => ['--binary'];
}->

class { 'nginx':
  package_source  => 'passenger',
  http_cfg_append => {
    'passenger_root' => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
    'passenger_ruby' => "/usr/local/rvm/wrappers/${ruby_version}/ruby",
  }
}

nginx::resource::vhost { 'demo':
  www_root         => '/vagrant/public',
  vhost_cfg_append => {
    'passenger_enabled' => 'on',
    'rails_env'         => 'development'
    #'passenger_ruby'    => '/usr/bin/ruby',
  }
}

package { ['git', 'nodejs']:
  ensure => installed,
}->

exec { "/usr/local/rvm/wrappers/${ruby_version}/bundle install": 
  cwd => '/vagrant'
}