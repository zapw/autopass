eval "$setvar sysconfig_httpd" <<EOF
#start_custom
$(
   if [[ $os_relver = 6 ]] ; then
       append="export "
   fi
   qa=0
   shopt -s extglob
   for qa_server in "${qa_servers[@]}" ; do
     if [[ $HOSTNAME = "${qa_server%%.*}"@(|.*) ]] ; then
         qa="1"
         break
     fi
   done
   if [[ $qa = 1  ]] ; then
       for var in "${!enviros[@]}" ; do
             [[ "${qa_enviros["$var"]+x}" ]] && unset -v "enviros["$var"]"
       done
       for arrname in enviros qa_enviros ; do
            if [[ $arrname = "enviros" ]] ; then
                for key in "${!enviros[@]}" ; do
                     printf "${append}%s\n" "$key=\"${enviros["$key"]}\""
                done
            elif [[ $arrname = "qa_enviros" ]] ; then
                  for key in "${!qa_enviros[@]}" ; do
                       printf "${append}%s\n" "$key=\"${qa_enviros["$key"]}\""
                  done
            fi

       done
   else
       for key in "${!enviros[@]}" ; do
             printf "${append}%s\n" "$key=\"${enviros["$key"]}\""
       done
   fi
)
#end_custom
EOF
