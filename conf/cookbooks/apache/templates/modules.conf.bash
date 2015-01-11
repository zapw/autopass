eval $setvar conf_modules_2_2 <<'EOF'
LoadModule authn_default_module modules/mod_authn_default.so
LoadModule authz_default_module modules/mod_authz_default.so
EOF
eval $setvar conf_modules_2_4 <<'EOF'
LoadModule access_compat_module modules/mod_access_compat.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule filter_module modules/mod_filter.so
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule systemd_module modules/mod_systemd.so
LoadModule unixd_module modules/mod_unixd.so
EOF

eval "$setvar conf_modules" <<EOF
$({ [[ $os_relver = 7 ]] && echo "$conf_modules_2_4";} || { [[ $os_relver = 6 ]] && echo "$conf_modules_2_2";})
LoadModule alias_module modules/mod_alias.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule auth_digest_module modules/mod_auth_digest.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_owner_module modules/mod_authz_owner.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule deflate_module modules/mod_deflate.so
LoadModule dir_module modules/mod_dir.so
LoadModule env_module modules/mod_env.so
LoadModule expires_module modules/mod_expires.so
LoadModule headers_module modules/mod_headers.so
LoadModule include_module modules/mod_include.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule logio_module modules/mod_logio.so
LoadModule mime_magic_module modules/mod_mime_magic.so
LoadModule mime_module modules/mod_mime.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule speling_module modules/mod_speling.so
LoadModule status_module modules/mod_status.so
LoadModule vhost_alias_module modules/mod_vhost_alias.so
EOF
