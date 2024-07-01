# collect the `irods::icommands` array of hashes to instantiate
# appropriate `irods::lib::icommands` define types and add them to the
# catalog.
#
# Also log in as the irods admin to run iadmin commands.
#
class irods::icommands (
  $iadmin_set = hiera_array('irods::icommands', []),
) {


  iadmin_collect($iadmin_set)

  file { '/root/.irods':
    ensure => 'directory',
    mode   => '0700',
  }

  -> file { '/root/.irods/irods_environment.json':
    ensure  => 'file',
    content => template('irods/irods_environment.json.erb'),
    mode    => '0600',
  }

  -> exec { 'irods_admin_iinit':
    path        => ['/usr/bin','/bin'],
    environment => ['HOME=/root'],
    command     => "echo ${irods::globals::provider_admin_pass} | iinit",
    unless      => 'iadmin lu > /dev/null 2>&1',
  }

  file { '/etc/bash_completion.d/i-commands-auto.bash':
    ensure => 'file',
    source => 'puppet:///modules/irods/i-commands-auto.bash',
    mode   => '0644',
  }

}
