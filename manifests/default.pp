# == Define: single_user_rvm::default
#
# Sets the default RVM ruby
#
# # === Parameters
#
# # [*ruby_string*]
#   Ruby version to install, be sure to use the full Ruby string as failing to do so will break the mechanism that
#   detects if the required ruby is already installed. Defaults to the value of the title string.
#   Should match a ruby installed by single_user_rvm::install_ruby
#
# [*user*]
#   The user for which this Ruby will be installed. Defaults to 'rvm'.
#
# === Examples
#
# Set Ruby 2.0.0 p247 as default for user 'dude':
#
#   single_user_rvm::default { 'ruby-2.0.0-p247':
#     user => 'dude',
#   }
#
define single_user_rvm::default (
  $user ='rvm') {

    if $home {
      $homedir = $home
      } else {
      $homedir = "/home/${user}"
      }
      
    
      $command =  "rvm use --default ${title}"
      $check_command = "rvm current"

    exec { "su -l ${user} -c '${command}'":
      path => "/usr/bin:/usr/sbin:/bin:~/.rvm/bin",
      provider => shell,
      logoutput => false,
      cwd => "/home/${user}",
      require => Single_user_rvm::Install[$user],
      unless => "su -l ${user} -c '${check_command}' | grep ${title}"
    }


    }

