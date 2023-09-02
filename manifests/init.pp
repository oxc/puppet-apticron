# == Class: apticron
#
class apticron (
  Enum['absent', 'latest', 'present', 'purged'] $package_ensure = 'present',
  String $package_name = $::apticron::params::package_name,
  Array[String] $package_list = $::apticron::params::package_list,

  Stdlib::Absolutepath $config_dir_path = $::apticron::params::config_dir_path,
  Boolean $config_dir_purge = false,
  Boolean $config_dir_recurse = true,
  Optional[String] $config_dir_source = undef,

  Stdlib::Absolutepath $config_file_path = $::apticron::params::config_file_path,
  String $config_file_owner = $::apticron::params::config_file_owner,
  String $config_file_group = $::apticron::params::config_file_group,
  String $config_file_mode = $::apticron::params::config_file_mode,
  Optional[String] $config_file_source = undef,
  Optional[String] $config_file_string = undef,
  Optional[String] $config_file_template = undef,

  String $config_file_require = $::apticron::params::config_file_require,

  Hash $config_file_hash = {},
  Hash $config_file_options_hash = {},

  String $email = "apticron@${::domain}",
  String $email_from = "root@${::fqdn}",
  String $email_subject = '[apticron] $SYSTEM: $NUM_PACKAGES package update(s)',
  $random = fqdn_rand('60'),
) inherits ::apticron::params {

  $config_file_content = extlib::default_content($config_file_string, $config_file_template)

  if $config_file_hash {
    create_resources('apticron::define', $config_file_hash)
  }

  if $package_ensure == 'purged' {
    $config_dir_ensure  = 'absent'
    $config_file_ensure = 'absent'
  } else {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
  }

  anchor { 'apticron::begin': } ->
  class { '::apticron::install': } ->
  class { '::apticron::config': } ->
  anchor { 'apticron::end': }
}
