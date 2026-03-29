# == Class: apticron::params
#
class apticron::params {
  $package_name = $facts['os']['family'] ? {
    default => 'apticron',
  }

  $package_list = $facts['os']['family'] ? {
    default => ['apt-listchanges'],
  }

  $config_dir_path = $facts['os']['family'] ? {
    default => '/etc/apticron',
  }

  $config_file_path = $facts['os']['family'] ? {
    default => '/etc/apticron/apticron.conf',
  }

  $config_file_owner = $facts['os']['family'] ? {
    default => 'root',
  }

  $config_file_group = $facts['os']['family'] ? {
    default => 'root',
  }

  $config_file_mode = $facts['os']['family'] ? {
    default => '0644',
  }

  $config_file_require = $facts['os']['family'] ? {
    default => 'Package[apticron]',
  }

  case $facts['os']['family'] {
    'Debian': {
    }
    default: {
      fail("${facts['os']['name']} not supported.")
    }
  }
}
