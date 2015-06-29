class ibmwasihs::params{
  $traceLevel                      = 'INFO'
  $traceFormat                     = 'all'
  $installType                     = 'installNew'
  $silentInstallLicenseAcceptance  = true
  $allowNonRootSilentInstall       = false
  $httpPort                        = '80'
  $adminPort                       = '8008'
  $installHttpService              = false
  $installAdminService             = false
  $httpServiceName                 = 'IBM_HTTP_Server_7.0'
  $adminServiceName                = 'IBM_HTTP_Administration_7.0'
  $winServiceLogOnAs               = 'user'
  $winServiceUser                  = 'root'
  $winServiceStartType             = 'automatic'
  $createAdminAuth                 = true
  $runSetupAdmin                   = true
  $createAdminUserGroup            = true
  $installPlugin                   = true
  $disableOSPrereqChecking         = true
}