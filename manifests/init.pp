class repmand ($www_group='www-data',$www_user='www-data') {

  $root_path='/opt/repmand'

  File {
    ensure  => present,
    mode    => 0775,
    owner   => 'root',
    group   => $www_user,
  }

  file { $root_path:
    ensure  => directory,
    mode    => 2775,
    owner   => $www_user,
    group   => $www_group,
  }

  file { "${root_path}/dbxconnections":
    source  => 'puppet:///modules/repmand/opt/dbxconnections',
    require => File[$root_path];
  "${root_path}/dbxdrivers":
    source  => 'puppet:///modules/repmand/opt/dbxdrivers',
    require => File[$root_path];
  "${root_path}/libmidas.so.1":
    source  => 'puppet:///modules/repmand/opt/libmidas.so.1',
    require => File[$root_path];
  "${root_path}/printreptopdf":
    source  => 'puppet:///modules/repmand/opt/printreptopdf',
    require => File[$root_path];
  "${root_path}/printreptopdf.bin":
    source  => 'puppet:///modules/repmand/opt/printreptopdf.bin',
    require => File[$root_path];
  "${root_path}/printreptopdf.sh":
    source  => 'puppet:///modules/repmand/opt/printreptopdf.sh',
    require => File[$root_path];
  }

  file { '/usr/lib/libmidas.so.1':
    source  => 'puppet:///modules/repmand/lib/libmidas.so.1',
    mode    => 755,
    owner   => 'root',
    group   => 'root',
  }

  exec {'ldconfig-libmidas':
    command => 'ldconfig',
    unless  => 'ldconfig -v | grep libmidas',
    require => File['/usr/lib/libmidas.so.1']
  }

  file {'/usr/local/etc/dbxconnections.conf':
    mode    => 644,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/repmand/etc/dbxconnections.conf'
  }

  file {'/usr/local/etc/dbxdrivers.conf':
    mode    => 644,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/repmand/etc/dbxdrivers.conf'
  }

  if $architecture == 'amd64' {
    package {'ia32-libs':
      ensure  => present
    }
  }

}
