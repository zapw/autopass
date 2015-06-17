Tool for automating job execution on multiplie servers


Directory structure
  autopass searches for file <config> under <conf> directory in the following order:
    "current working directory"/conf
    "current working directory"/../conf
    "absolute path"/conf
    "$HOME/.autopass
    /usr/local/etc/autopass


Description of directoires under conf/
  conf/
      config
      cookbooks/
                attributes
                recipes
      enabled
      environment/
                 default
      perserver
      roles
      runfiles
      servers

