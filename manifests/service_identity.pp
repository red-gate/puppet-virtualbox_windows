# Set the identity that DCOM will use to start the VBoxSVC service
class virtualbox_windows::service_identity($username, $password, $appid = '{819B4D85-9CEE-493C-B6FC-64FFE759B3C9}') {

  exec { "Set Identity for DCOM AppId: ${appid}":
    command   => template('virtualbox_windows/set_dcom_application_identity.ps1.erb'),
    onlyif    => template('virtualbox_windows/should_set_dcom_application_identity.ps1.erb'),
    provider  => powershell,
    logoutput => true,
  }

}
