apacheuser="apache"
dev_user="wwwrun"
base="/data"
crm="$base/crm"
sites="$base/foobar"
sys="$base/foobarsys"
media_uploads="/mnt/nfs/data"

devuser_dirs=("$sys")
apacheuser_dirs=("$crm" "$sites" "$sys")
apachegroup="$apacheuser"
