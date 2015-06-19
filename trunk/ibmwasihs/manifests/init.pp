# Class: ibmwasihs
#
# This module manages ibmwasihs
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class ibmwasihs(
  $responseFile = '/tmp/ihs-resposefile.txt',
  $traceLevel                      = 'UNSET',
  $traceFormat                     = 'UNSET',
  $installType                     = 'UNSET',
  $silentInstallLicenseAcceptance  = 'UNSET',
  $allowNonRootSilentInstall       = 'UNSET',
  $httpPort                        = 'UNSET',
  $adminPort                       = 'UNSET',
  $installHttpService              = 'UNSET',
  $installAdminService             = 'UNSET',
  $httpServiceName                 = 'UNSET',
  $adminServiceName                = 'UNSET',
  $winServiceLogOnAs               = 'UNSET',
  $winServiceUser                  = 'UNSET',
  $winServiceStartType             = 'UNSET',
  $createAdminAuth                 = 'UNSET',
  $runSetupAdmin                   = 'UNSET',
  $createAdminUserGroup            = 'UNSET',
  $installPlugin                   = 'UNSET',
  $webserverDefinition             = 'UNSET',
  $responseFileBackup              = '/tmp/ihs-installation-location.txt'
) {
		class { "ibmwasihs::precheck": }
		include ibmwasihs::params
		exec{"Creating Response file":
		      command     => "cat /tmp/ihs-details.txt >> ${responseFile}",
		      require     => File["ihs-details.txt"],
		      provider    => shell
		}
		$traceLevel_real = $traceLevel ? {
		    'UNSET' => $::ibmwasihs::params::traceLevel,
		    default => $traceLevel,
		  }
		$traceFormat_real = $traceFormat ? {
		    'UNSET' => $::ibmwasihs::params::traceFormat,
		    default => $traceFormat,
		  }
		$installType_real = $installType ? {
		    'UNSET' => $::ibmwasihs::params::installType,
		    default => $installType,
      }
    $silentInstallLicenseAcceptance_real = $silentInstallLicenseAcceptance ? {
		    'UNSET' => $::ibmwasihs::params::silentInstallLicenseAcceptance,
		    default => $silentInstallLicenseAcceptance,
      }
    $allowNonRootSilentInstall_real = $allowNonRootSilentInstall ? {
		    'UNSET' => $::ibmwasihs::params::allowNonRootSilentInstall,
		    default => $allowNonRootSilentInstall,
      }
    $httpPort_real = $httpPort ? {
		    'UNSET' => $::ibmwasihs::params::httpPort,
		    default => $httpPort,
      }
    $adminPort_real = $adminPort ? {
		    'UNSET' => $::ibmwasihs::params::adminPort,
		    default => $adminPort,
      }
    $installHttpService_real = $installHttpService ? {
		    'UNSET' => $::ibmwasihs::params::installHttpService,
		    default => $installHttpService,
      }  
    $installAdminService_real = $installAdminService ? {
		    'UNSET' => $::ibmwasihs::params::installAdminService,
		    default => $installAdminService,
      }
    $httpServiceName_real = $httpServiceName ? {
		    'UNSET' => $::ibmwasihs::params::httpServiceName,
		    default => $httpServiceName,
      }
    $adminServiceName_real = $adminServiceName ? {
		    'UNSET' => $::ibmwasihs::params::adminServiceName,
		    default => $adminServiceName,
      }
    $winServiceLogOnAs_real = $winServiceLogOnAs ? {
		    'UNSET' => $::ibmwasihs::params::winServiceLogOnAs,
		    default => $winServiceLogOnAs,
      }
    $winServiceUser_real = $winServiceUser ? {
		    'UNSET' => $::ibmwasihs::params::winServiceUser,
		    default => $winServiceUser,
      }
    $winServiceStartType_real = $winServiceStartType ? {
		    'UNSET' => $::ibmwasihs::params::winServiceStartType,
		    default => $winServiceStartType,
      }
    $createAdminAuth_real = $createAdminAuth ? {
		    'UNSET' => $::ibmwasihs::params::createAdminAuth,
		    default => $createAdminAuth,
      }
    $runSetupAdmin_real = $runSetupAdmin ? {
		    'UNSET' => $::ibmwasihs::params::runSetupAdmin,
		    default => $runSetupAdmin,
      }
    $createAdminUserGroup_real = $createAdminUserGroup ? {
		    'UNSET' => $::ibmwasihs::params::createAdminUserGroup,
		    default => $createAdminUserGroup,
      }
    $installPlugin_real = $installPlugin ? {
		    'UNSET' => $::ibmwasihs::params::installPlugin,
		    default => $installPlugin,
      }
		file_line{"Appending other variables to the file":
		      require     => Exec['Creating Response file'],
		      path        => "${responseFile}",
		      line        => "-OPT traceLevel=${traceLevel_real}\n-OPT traceFormat=${traceFormat_real}\n-OPT installType=${installType_real}\n-OPT silentInstallLicenseAcceptance=${silentInstallLicenseAcceptance_real}\n-OPT allowNonRootSilentInstall=${allowNonRootSilentInstall_real}\n-OPT httpPort=${httpPort_real}\n-OPT adminPort=${adminPort_real}\n-OPT installHttpService=${installHttpService_real}\n-OPT installAdminService=${installAdminService_real}\n-OPT httpServiceName=${httpServiceName_real}\n-OPT adminServiceName=${adminServiceName_real}\n-OPT winServiceLogOnAs=${winServiceLogOnAs_real}\n-OPT winServiceUser=${winServiceUser_real}\n-OPT winServiceStartType=${winServiceStartType_real}\n-OPT createAdminAuth=${createAdminAuth_real}\n-OPT runSetupAdmin=${runSetupAdmin_real}\n-OPT createAdminUserGroup=${createAdminUserGroup_real}\n-OPT installPlugin=${installPlugin_real}"
		  }
		exec{"Installation of IHS":
		      require     => File_line['Appending other variables to the file'],
		      command     => "./install -options ${responseFile} -silent",
		      onlyif      => "[ $( $( echo -e $( cat responseFileBackup )\'/bin/apachectl\' ) -v | grep -c -i IBM ) -eq 0 ]",
          provider    => shell,
          cwd         => "/opt/IHS/"
      }
    exec{"Remove ihs-detailsfile":
          command     => "rm -f /tmp/ihs-details.txt && cp ${responseFile} /usr/bin/ihs-installed.txt",
          require     => Exec['Installation of IHS'],
          provider    => shell
      }
}
