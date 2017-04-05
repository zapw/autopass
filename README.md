Tool for automating job execution on multiplie servers


Directory structure:

autopass searches for "config" configuration file in the following order:

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


Installation:


       enter 'empty' directory, run make to compile it, copy it to your $PATH
       run, autopass.
       enjoy.


Usage:


       autopass [-r cookbook|cookbook::recipe ...] [-j jobname ...] [-s server[,port] ...] [-f file.log] [-v] [-q] [--env dirname]
       autopass -l
       autopass -h

Options:


       -r        Add cookbook/recipe to the runlist. To specify a recipe append '::' after the cookbook name
                ( leave it out to execute default recipe)


Example:


        cookbook::recipe ...


Environment data:


        --env dirname
               Where dirname is a subdirectory under $confdir/environment/. For example '--env standard'. Will load for currently
                executing cookbook, attributes data from $confdir/environment/standard/$cookbook.  Where $cookbook,
                is the currently executing cookbook from the runlist.
                ( by default attributes from $confdir/environment/default/$cookbook, are loaded first for every executing cookbook in the runlist.)



Other options:



         -j        Run job or multiplie jobs one after another by order -j jobname1 jobname2 ...
         -s        Execute cookbook/job runlist on each server by order: -s server1 server2,2022 ...
         -l        List available jobs
         -v        verbose mode, echo input
         -q        quiet mode, don't print session to stdout
         -f        file.log This option allows to log the whole session
         -h        Print this usage

