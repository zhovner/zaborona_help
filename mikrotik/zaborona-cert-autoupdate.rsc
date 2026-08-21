# Zaborona.help - certificate watchdog for MikroTik RouterOS 7
#
# The client certificate zaborona-help.crt shipped with all Zaborona.help
# instructions was issued on 2017-05-19 for 10 years and expires 2027-05-17.
# After that date the tunnel simply stops coming up, with no clear log message
# pointing at the certificate.
#
# This script checks weekly whether a new certificate has been published and
# installs it automatically, rolling back if the tunnel fails to come up.
# It also starts logging warnings 8 weeks before expiry.
#
# Install:  /import file-name=zaborona-cert-autoupdate.rsc
# Test:     /system script run zaborona-cert-autoupdate
#           /log print where message~"ZABORONA-CERT"
#
# Assumes the naming used in the official guide: interface "zaborona",
# certificate "zaborona-help.crt". Adjust the variables below if yours differ.

/system script remove [find name="zaborona-cert-autoupdate"]
/system script add name=zaborona-cert-autoupdate owner=admin policy=read,write,policy,test,ftp,sensitive dont-require-permissions=no source={
:local certUrl "https://zaborona.help/zaborona-help.crt"
:local keyUrl "https://zaborona.help/zaborona-help.key"
:local liveName "zaborona-help.crt"
:local ifName "zaborona"
:local refFile "zab-cert-reference.txt"
:local tmpCrt "zab-new-cert.crt"
:local tmpKey "zab-new-cert.key"
:local tag "[ZABORONA-CERT]"

:log info "$tag start check"

:local liveId [/certificate find name=$liveName]
:if ([:len $liveId] = 0) do={
    :log error "$tag live certificate '$liveName' not found, abort"
    :error "no live cert"
}
:local liveExp [/certificate get $liveId invalid-after]
:local liveLeft [/certificate get $liveId expires-after]
:log info "$tag installed cert expires $liveExp (in $liveLeft)"

:if ($liveLeft < 8w) do={
    :log error "$tag WARNING certificate expires in $liveLeft - tunnel will stop working"
}

/file remove [find name=$tmpCrt]
/file remove [find name=$tmpKey]
/certificate remove [find name~"zab-new-cert"]
:delay 1

:do {
    /tool fetch url=$certUrl dst-path=$tmpCrt mode=https
} on-error={
    :log error "$tag cannot download certificate, abort"
    :error "download failed"
}
:delay 2

:if ([:len [/file find name=$tmpCrt]] = 0) do={
    :log error "$tag downloaded file missing, abort"
    :error "no file"
}
:local sz [/file get [/file find name=$tmpCrt] size]
:if (($sz < 500) or ($sz > 8000)) do={
    :log error "$tag suspicious file size $sz bytes, abort"
    /file remove [find name=$tmpCrt]
    :error "bad size"
}
:local newContent [/file get [/file find name=$tmpCrt] contents]
:if ([:find $newContent "BEGIN CERTIFICATE"] = nil) do={
    :log error "$tag downloaded file is not a PEM certificate, abort"
    /file remove [find name=$tmpCrt]
    :error "not a certificate"
}

:if ([:len [/file find name=$refFile]] = 0) do={
    /file add name=$refFile contents=$newContent
    :log info "$tag reference snapshot created, nothing to compare on first run"
    /file remove [find name=$tmpCrt]
    :log info "$tag check finished"
} else={

:local refContent [/file get [/file find name=$refFile] contents]

:if ($newContent = $refContent) do={
    :log info "$tag no change, published certificate is identical"
    /file remove [find name=$tmpCrt]
} else={
    :log warning "$tag NEW certificate published, starting replacement"

    :do {
        /tool fetch url=$keyUrl dst-path=$tmpKey mode=https
    } on-error={
        :log error "$tag cannot download private key, abort"
        /file remove [find name=$tmpCrt]
        :error "key download failed"
    }
    :delay 2

    /certificate import file-name=$tmpCrt passphrase=""
    :delay 2
    /certificate import file-name=$tmpKey passphrase=""
    :delay 2

    :local newSet [/certificate find name~"zab-new-cert"]
    :if ([:len $newSet] = 0) do={
        :log error "$tag import produced no certificate, abort"
        /file remove [find name=$tmpCrt]
        /file remove [find name=$tmpKey]
        :error "import failed"
    }
    :local newId [:pick $newSet 0]
    :local newExp [/certificate get $newId invalid-after]
    :local newIss [/certificate get $newId issuer]
    :log info "$tag imported new cert, issuer '$newIss', expires $newExp"

    :local bad false
    :if ([:find $newIss "Zaborona.help"] = nil) do={
        :log error "$tag unexpected issuer, abort"
        :set bad true
    }
    :if ([/certificate get $newId private-key] != true) do={
        :log error "$tag new certificate has no matching private key, abort"
        :set bad true
    }
    :if ([/certificate get $newId expires-after] < $liveLeft) do={
        :log error "$tag published cert expires sooner than installed one, abort"
        :set bad true
    }

    :if ($bad = true) do={
        /certificate remove $newId
        /file remove [find name=$tmpCrt]
        /file remove [find name=$tmpKey]
        :error "validation failed"
    }

    :local stamp [/system clock get date]
    /certificate set $liveId name="zaborona-help-old-$stamp"
    /certificate set $newId name=$liveName
    /interface ovpn-client set [find name=$ifName] certificate=$liveName
    :delay 2
    /interface ovpn-client disable [find name=$ifName]
    :delay 3
    /interface ovpn-client enable [find name=$ifName]
    :log info "$tag certificate swapped, waiting for tunnel"
    :delay 30

    :if ([/interface get [find name=$ifName] running] = true) do={
        /file set [find name=$refFile] contents=$newContent
        :log warning "$tag certificate updated successfully, tunnel is up"
    } else={
        :log error "$tag tunnel did not come up, rolling back"
        /certificate set $newId name="zaborona-help-failed-$stamp"
        /certificate set $liveId name=$liveName
        /interface ovpn-client set [find name=$ifName] certificate=$liveName
        /interface ovpn-client disable [find name=$ifName]
        :delay 3
        /interface ovpn-client enable [find name=$ifName]
        :delay 20
        :local st [/interface get [find name=$ifName] running]
        :log error "$tag rollback done, tunnel running = $st"
    }

    /file remove [find name=$tmpCrt]
    /file remove [find name=$tmpKey]
}

:log info "$tag check finished"
}
}

/system scheduler remove [find name="zaborona-cert-check-job"]
/system scheduler add name=zaborona-cert-check-job start-time=04:00:00 interval=1w on-event="/system script run zaborona-cert-autoupdate" policy=read,write,policy,test,ftp,sensitive
