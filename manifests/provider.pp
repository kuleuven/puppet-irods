# installs provider server
class irods::provider (
  String                            $core_version            = $irods::params::core_version,
  Enum['postgres','oracle','mysql'] $db_vendor               = $irods::params::db_vendor,
  String                            $db_name                 = $irods::params::db_name,
  String                            $db_user                 = $irods::params::db_user,
  String                            $db_password             = $irods::params::db_password,
  String                            $db_srv_host             = $irods::params::db_srv_host,
  String                            $db_srv_port             = $irods::params::db_srv_port,
  Boolean                           $do_setup                = $irods::params::do_setup,
  Boolean                           $use_ssl                 = $irods::globals::use_ssl,
  Array                             $re_rulebase_set         = $irods::params::re_rulebase_set,
  Boolean                           $install_dev_pkgs        = $irods::globals::install_dev_pkgs,
  String                            $package_install_options = $irods::globals::package_install_options,
) inherits irods::params {

  include ::irods::service
  include ::irods::provider::re_rulebase_set
  include ::irods::provider::python_plugin_config

  contain ::irods::provider::setup
  
  Irods::Lib::Install['provider'] ~>
  Class['irods::provider::setup'] ->
  Class['irods::provider::re_rulebase_set'] ->
  Class['irods::provider::python_plugin_config'] ->
  Irods::Lib::Ssl['provider']

  $min_packages = ['irods-server', 'irods-runtime', 'irods-icommands', "irods-database-plugin-${db_vendor}", "irods-rule-engine-plugin-python"]
  if $install_dev_pkgs {
    $packages = concat($min_packages, ['irods-devel'])
  } else {
    $packages = $min_packages
  }

  irods::lib::install { 'provider':
    packages                => $packages,
    core_version            => $core_version,
    package_install_options => $package_install_options,
  }

  if $use_ssl {
    irods::lib::ssl { 'provider':
      ssl_certificate_chain_file_source => $irods::globals::ssl_certificate_chain_file_source,
      ssl_certificate_key_file_source   => $irods::globals::ssl_certificate_key_file_source,
    }
  }

}
