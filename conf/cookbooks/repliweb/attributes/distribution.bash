declare -A template=([intgr]= [qa]=) replicenter=([intgr]="" [qa]="")
src_environment=""
# sites=("all") will create jobs for all sites
# sites=("domain.com" "foobar.com" "stream.example.com") will create jobs for only these sites.
sites=("")
filename='.sites'
uripath="serverid"
max_curl_procs="60"
curl_contimeout=20
curl_maxtime=60
defaultserver_docroot="/var/www/html"
regex='^(www\.)?(spotcrm[^.]*|(origin-)?qa|api|api-[^.]+|dev|cms|mcrm|crm|www|framework|lp|myaccount)\.|^localhost($|\.)'
#regex='^(www\.)?((origin-)?qa|api|api-[^.]+|dev|cms|mcrm|crm|www|framework|lp|myaccount)\.|^localhost($|\.)'
svnurl=""
new_platpath="/svn/PLAT/branches/"
prev_platpath="/svn/SPWL/branches/"
new_platpath_trunk="/svn/PLAT/trunk/"
prev_platpath_trunk="/svn/SPWL/trunk/"
wordpresspath="/svn/"
pltchksumfile="config/credentials.php"
wpchksumfile="wp-config.php"
svnusername=""
svnpassword=""
repliwebuser=""
repliwebpassword=""
intgrvhostdir=""
