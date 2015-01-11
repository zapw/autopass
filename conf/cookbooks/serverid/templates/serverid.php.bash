eval "$setvar serverid" <<'EOF'
<?php
echo gethostname();
echo "<hr/>";
foreach (getallheaders() as $name => $value) {
    echo "$name: $value<br/>";
}
echo "SERVER('REMOTE_ADDR'):" . (isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '');
?>
EOF
