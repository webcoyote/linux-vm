
users = data_bag('users')
users.each do |user_info|
  user = data_bag_item('users', user_info)

  user user['id'] do
    group     user['group']
    shell     user['shell']
    comment   user['comment']
    home      "/home/#{user['id']}"
    supports  :manage_home => true
  end
end

=begin
{
    "authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsSjlBPBwY68yb/WfSUmGCzw4Mk+PxLVJVPQUmMPBOgeO7/Wy37nglaZmWCrjCVZVxhQDTaczNe5/PqUvDthzlOe8QTEZRp41t6Dg3qaLfyvzqldg4lmEQRGU2BRkkBe6+d0L6SfEr+FcByyj0X7EPAKus1e+2ojPRDB5mhqFq+PQvTP3w7wQp5ulKAfPdJfFAnzE/r/2SO55DAGO6Rg7YHUNyyWeCsYfeE81zkrP2K9ULf5VcVTNTfWjLZAzplU5gA3mT3cr90H59jafh4uhqvOkF2xgHwpiddV+gRYiMcOtvV4LUb2mT988JhhFe9ycMppl5dhcXduRc3IrfnhFkQ== pat@FATPAD\n",
    "dotfiles": {
        "repo": "git://github.com/webcoyote/my_dotfiles",
        "files": [
            "bin",
            ".devilspie",
            ".gemrc",
            ".rspec",
            ".rvmrc",
            ".zshrc"
        ]
    }
}
=end
