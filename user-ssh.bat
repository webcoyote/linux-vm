@setlocal
::@set TERM=
ssh.exe %USERNAME%@127.0.0.1 -p 2222 -i "%USERPROFILE%\.ssh\id_rsa" %*
