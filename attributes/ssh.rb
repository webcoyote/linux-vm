# Disable insecure login methods
default['openssh']['server']['permit_root_login'] = "no"
default['openssh']['server']['password_authentication'] = "no"
