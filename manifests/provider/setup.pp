# Run vendor's irods_setup.sh for the provider-enabled server
class irods::provider::setup {
  if $::irods::provider::do_setup {
    notify{'Doing iRODS setup':}
    irods::lib::setup{'provider':
      setup_rsp_file => 'provider-setup.rsp',
      setup_rsp_tmpl => 'provider-setup.rsp.erb',
      fix_sql        => true,
    }
  } else {
    notify{'Skipping iRODS setup':}
  }
}
