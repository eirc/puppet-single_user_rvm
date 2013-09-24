# == Define: single_user_rvm::install
#
# Installs RVM.
#
# More info on installation: https://rvm.io/rvm/install
#
# === Parameters
#
# Document parameters here
#
# [*user*]
#   The user for which RVM will be installed. Defaults to the value of the title string.
#
# [*version*]
#   Version of RVM to install. More info on versions: https://rvm.io/rvm/upgrading. Defaults to 'stable'.
#
# [*rvmrc*]
#   Content for the global .rvmrc file placed in the user's homedir. If empty, .rvmrc will no be touched.
#   Defaults to ''.
#
# [*home*]
#   Set to home directory of user. Defaults to /home/${user}.
#
# === Examples
#
# Plain simple installation for user 'dude'
#
#   single_user_rvm::install { 'dude': }
#
# Install version 'head' for user dude
#
#   single_user_rvm::install { 'dude':
#     version => 'head',
#   }
#
# Set .rvmrc configuration (example auto-trusts all rvmrc's in the system).
#
#   single_user_rvm::install { 'dude':
#     rvmrc => 'rvm_trust_rvmrcs_flag=1',
#   }
#
# Use a custom home directory.
#
#   single_user_rvm::install { 'dude':
#     home  => '/path/to/special/home',
#   }
#
# Use a title different than the user name.
#
#   single_user_rvm::install { 'some other title':
#     user  => 'dude',
#     rvmrc => 'rvm_trust_rvmrcs_flag=1',
#     home  => '/path/to/special/home',
#   }
#
define single_user_rvm::install (
  $user     = $title,
  $version  = 'stable',
  $rvmrc    = '',
  $home     = '',
) {

  if $home {
    $homedir = $home
  } else {
    $homedir = "/home/${user}"
  }

  require single_user_rvm::dependencies

  $install_command = "su -c 'curl -L https://get.rvm.io | bash -s ${version}' - ${user}"

  exec { $install_command:
    path    => '/usr/bin:/usr/sbin:/bin',
    creates => "${homedir}/.rvm/bin/rvm",
    require => [ Package['curl'], Package['bash'], User[$user] ],
  }

  if $rvmrc {
    file { "${homedir}/.rvmrc":
      ensure  => present,
      owner   => $user,
      content => $rvmrc,
      require => User[$user],
    }
  }

}
