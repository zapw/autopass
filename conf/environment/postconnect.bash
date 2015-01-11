. "$envdir/functions.bash"
shopt -s nullglob extglob
for attribute in "${cookbookdir}/$cookbook/attributes/default.bash" "${cookbookdir}/$cookbook/attributes/"!(default).bash \
	"${envdir}/default/$cookbook/default.bash" "${envdir}/default/$cookbook/"!(default).bash; do
     if [[ -f $attribute ]]; then
          . "$attribute"
     fi
done

if [[ $environment != default ]] ; then
    for attribute in "$envdir/$environment/$cookbook/default.bash" "$envdir/$environment/$cookbook/"!(default).bash; do
         if [[ -f $attribute ]]; then
              . "$attribute"
         fi
    done
fi

for attribute in "$perservdir/$server/$cookbook/default.bash" "$perservdir/$server/$cookbook/"!(default).bash; do
     if [[ -f $attribute ]]; then
          . "$attribute"
     fi
done

if [[ "$interact_pre_connect" ]]; then
     eval "$interact_pre_connect"
fi
if [[ "$pre_connect" ]]; then
     eval "$pre_connect"
fi
