# Set sudo options for password-less login for some users;
# the rest of the work is done in users.rb

sudoers_defaults = nil
case node["platform_family"]
when "debian"
  # do things on debian-ish platforms (debian, ubuntu, linuxmint)
  sudoers_defaults = [
    'env_reset',
    'exempt_group=admin',
  ]
when "rhel"
  # do things on RHEL platforms (redhat, centos, scientific, etc)
  sudoers_defaults = [
    '!visiblepw',
    'env_reset',
    'env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
    'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
    'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
    'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
    'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
    'env_keep += "HOME"',
    'always_set_home',
    'secure_path = /sbin:/bin:/usr/sbin:/usr/bin'
  ]
else
  # do things for unknown platform
end

node.set["authorization"] = {
  "sudo" => {
    "include_sudoers_d" => true,
    "sudoers_defaults" => sudoers_defaults,
  }
}
