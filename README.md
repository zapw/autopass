Tool for automating job execution on multiplie servers


Directory structure:

 autopass searches for file config under conf directory in the following order:

    "current working directory"/conf/config
    "current working directory"/../conf/config
    "absolute path"/conf/config
    "$HOME/.autopass/config
    /usr/local/etc/autopass/config


Description of directoires under conf/ :


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
