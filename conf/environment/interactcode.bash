. "$envdir/functions.bash"

exec 5>&1 1>&4

shopt -s nullglob extglob
for attribute in "${cookbookdir}/$cookbook/attributes/default.bash" "${cookbookdir}/$cookbook/attributes/"!(default).bash \
	 "${envdir}/default/$cookbook/default.bash" "${envdir}/default/$cookbook/"!(default).bash  ; do
     if [[ -f $attribute ]] ; then 
         attributes+=("$attribute")
         . "$attribute"
     fi
done
if [[ $environment != default ]] ; then
    for attribute in "${envdir}/$environment/$cookbook/default.bash" "${envdir}/$environment/$cookbook/"!(default).bash; do
     if [[ -f $attribute ]] ; then 
         attributes+=("$attribute")
         . "$attribute"
     fi
    done
fi

for attribute in "${perservdir}/$server/$cookbook/default.bash" "${perservdir}/$server/$cookbook/"!(default).bash; do
     if [[ -f $attribute ]] ; then 
         attributes+=("$attribute")
         . "$attribute"
     fi
done
