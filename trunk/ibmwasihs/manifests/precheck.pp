class ibmwasihs::precheck (
  $sourcePath       = 'puppet://master.sapient.com/modules/ibmwasihs'
){
  package {"xorg-x11-xinit":
          ensure => installed
  }
  
  file {"ihs-details.txt":
        ensure        => present,
        path          => '/tmp',
        mode          => '0777',
        validate_cmd  => '[ $( grep -i -c installLocation % ) -eq 1 ] && [ $( grep -i -c setupAdminUser % ) -eq 1 ] && [ $( grep -i -c setupAdminGroup % ) -eq 1 ] && [ $( grep -i -c washostname % ) -eq 1 ] && [ $( grep -i -c webserverDefinition % ) -eq 1 ]',
        require       => Package["xorg-x11-xinit"]
  }
  file{"/opt/ihs-installer.tar.gz":
        ensure        => present,
        source        => "${sourcePath}/ihs-installer.tar.gz",
        require       => File["ihs-details.txt"],
        mode          => '0777',
        replace       => false
  }
  exec { "Extract IHS Tarball":
        command   => "tar -xvf /opt/ihs-installer.tar.gz",
        require   => File['/opt/ihs-installer.tar.gz'],
        cwd       => '/opt/',
        onlyif    => "[ $( ls -l /opt | grep -c IHS ) -eq 0 ]",
        path      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
        logoutput => true,
        provider  => shell
      }
  file{"/opt/IHS":
        ensure      => directory,
        require     => Exec['Extract IHS Tarball'],
        mode        => '0777'
      }
  exec{"Change Permission of Installer":
      path      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
      require   => File['/opt/IHS'],
      command   => "chmod -R 777 ./ -R",
      cwd       => '/opt/IHS',
      logoutput => true,
      provider  => shell
  }
}