class ff_gln_gw::monitor::nrpe ( $allowed_hosts ) {
  class { 'sudo': }

  package {
    'nagios-nrpe-server':
      ensure => installed,
      notify => Service['nagios-nrpe-server'];
    'nagios-plugins':
      ensure => installed,
      notify => Service['nagios-nrpe-server'];
    'cron-apt':
      ensure => installed;
  }

  service {
    'nagios-nrpe-server':
       ensure => running,
       hasrestart => true,
       enable => true,
       require => [
         Package['nagios-nrpe-server'],
         File['/etc/nagios/nrpe.d/allowed_hosts.cfg'],
         File['/etc/nagios/nrpe.d/check_apt.cfg']
       ];
  }

  file {
    '/etc/nagios/nrpe.d/allowed_hosts.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      content => template('ff_gln_gw/etc/nagios/nrpe.d/allowed_hosts.cfg.erb'),
      notify  => [Service['nagios-nrpe-server']];
  }

  file {
    '/etc/nagios/nrpe.d/check_procs.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      content => template('ff_gln_gw/etc/nagios/nrpe.d/check_procs.cfg.erb'),
      notify  => [Service['nagios-nrpe-server']];
  }

  file {
    '/etc/nagios/nrpe.d/check_apt.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_apt.cfg";
  }

  file {
    '/etc/nagios/nrpe.d/check_disk.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_disk.cfg";
  } ->
  sudo::conf { 'nagios-disk':
    priority => 10,
    content  => "nagios ALL=(ALL:ALL) NOPASSWD:/usr/lib/nagios/plugins/check_disk",
  }

  file {
    '/etc/nagios/nrpe.d/check_swap.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_swap.cfg";
  }

  file {
    '/etc/nagios/nrpe.d/check_disk_root.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_disk_root.cfg";
  }

  file {
    '/etc/nagios/nrpe.d/check_swraid.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_swraid.cfg";
  } ->
  file {
    '/usr/lib/nagios/plugins/check_cciss_ffgt':
      ensure => file,
      mode => '0755',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/usr/lib//nagios/plugins/check_cciss_ffgt";
  } ->
  sudo::conf { 'nagios-hwraid':
    priority => 10,
    content  => "nagios ALL=(ALL:ALL) NOPASSWD:/usr/lib/nagios/plugins/check_cciss_ffgt -v -p",
  }

  file {
    '/etc/nagios/nrpe.d/check_docker.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_docker.cfg",
      notify  => [Service['nagios-nrpe-server']];
  } ->
  file {
    '/usr/lib/nagios/plugins/check_docker.py':
      ensure => file,
      mode => '0755',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/usr/lib/nagios/plugins/check_docker.py";
  } ->
  sudo::conf { 'nagios-docker':
    priority => 10,
    content  => "nagios ALL=(ALL:ALL) NOPASSWD:/usr/lib/nagios/plugins/check_docker.py",
  }

    file {
    '/etc/nagios/nrpe.d/check_kernel.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_kernel.cfg",
      notify  => [Service['nagios-nrpe-server']];
  } ->
  file {
    '/usr/lib/nagios/plugins/check_deb_kernel_version':
      ensure => file,
      mode => '0755',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/usr/lib/nagios/plugins/check_deb_kernel_version";
  }

  file {
    '/etc/nagios/nrpe.d/check_hwraid.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_hwraid.cfg";
  } ->

  file {
    '/usr/lib//nagios/plugins/check_md_raid_ffgt':
      ensure => file,
      mode => '0655',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/usr/lib//nagios/plugins/check_md_raid_ffgt";
  } ->
  sudo::conf { 'nagios-swraid':
    priority => 10,
    content  => "nagios ALL=(ALL:ALL) NOPASSWD:/usr/lib/nagios/plugins/check_md_raid_ffgt",
  }

  file {
    '/etc/nagios/nrpe.d/check_procs_name.cfg':
      ensure => file,
      mode => '0644',
      owner => 'root',
      group => 'root',
      require => Package['nagios-nrpe-server'],
      source => "puppet:///modules/ff_gln_gw/etc/nagios/nrpe.d/check_procs_name.cfg";
  }

  ff_gln_gw::firewall::service { 'nrpe':
    ports => ['5666'],
    chains => ['wan'];
  }
}

define ff_gln_gw::monitor::nrpe::check_command ( $command ) {
  if defined(Class['ff_gln_gw::monitor::nrpe']) {
    file {
      "/etc/nagios/nrpe.d/check_${name}.cfg":
        ensure => file,
        mode => '0644',
        owner => 'root',
        group => 'root',
        content => inline_template("command[check_${name}]=${command}\n"),
        require => Package['nagios-nrpe-server'],
        notify => Service['nagios-nrpe-server'];
    }
  }
}
