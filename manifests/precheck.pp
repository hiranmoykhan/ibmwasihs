class ibmwasihs::precheck (
  $sourcePath = 'puppet:///modules/ibmwasihs'
){
  package {'xorg-x11-xinit':
          ensure      => installed
  }
  package {'glibc':
          ensure      => installed
  }
  exec {'glibc-i686-installation':
          command     =>'yum install -y $( yum provides */ld-linux.so.2 | grep glibc | head -n 1 | awk \'{print $1}\' )',
          logoutput   => true,
          require     => Package['glibc'],
          provider    => shell,
          onlyif      => "[ $(locate ld-linux.so.2 | wc -l ) -eq 0 ]",
          timeout     => 0
  }
  exec {'installing Dependency rpm':
        command       => 'yum install -y libXau-*i686 libxcb-*i686 libX11-*i686 libXext-*i686 libXp-*i686 libICE-*i686 libuuid-*i686 libSM-*i686 libXt-*i686 libXmu-*i686 libXi-*i686 libXtst-*i686 libXrender-*i686 freetype-*0.2.i686 expat-*i686 fontconfig-*i686 libXft-*i686 compat-libstdc++-*i686 ksh-*x86_64 libgcc-*i686 libstdc++-*x86_64 expat-*x86_64 gtk2-*x86_64 ',
        logoutput   => true,
        require     => Exec['glibc-i686-installation'],
        provider    => shell,
        timeout     => 0
  }
  
  file {'ihs-details.txt':
        ensure        => present,
        path          => '/tmp',
        mode          => '0777',
        validate_cmd  => '[ $( grep -i -c installLocation % ) -eq 1 ] && [ $( grep -i -c setupAdminUser % ) -eq 1 ] && [ $( grep -i -c setupAdminGroup % ) -eq 1 ] && [ $( grep -i -c washostname % ) -eq 1 ] && [ $( grep -i -c webserverDefinition % ) -eq 1 ]',
        require       => Package["xorg-x11-xinit"]
  }
  file{'/opt/ihs-installer.tar.gz':
        ensure        => present,
        source        => "${sourcePath}/ihs-installer.tar.gz",
        require       => File['ihs-details.txt'],
        mode          => '0777',
        replace       => true
  }
  exec { 'Extract IHS Tarball':
        command       => "tar -xvf /opt/ihs-installer.tar.gz",
        require       => File['/opt/ihs-installer.tar.gz'],
        cwd           => '/opt/',
        onlyif        => "[ $( ls -l /opt | grep -c IHS ) -eq 0 ]",
        path          => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
        logoutput     => true,
        provider      => shell
      }
  file{ '/opt/IHS':
        ensure       => directory,
        require      => Exec['Extract IHS Tarball'],
        mode         => '0777'
      }
  exec{ 'Change Permission of Installer':
      path           => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
      require        => File['/opt/IHS'],
      command        => 'chmod -R 777 ./',
      cwd            => '/opt/IHS',
      logoutput      => true,
      provider       => shell
  }
}