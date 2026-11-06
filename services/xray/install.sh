source /opt/hiddify-manager/scripts/common/utils.sh
source /opt/hiddify-manager/scripts/common/package_manager.sh
# latest= #$(get_release_version hiddify-sing-box)
# Pinned to 26.7.28, the last Xray whose REALITY server accepts a ClientHello without X25519MLKEM768.
# From 26.9.9 on (xtls/reality 8cdf7bf) REALITY rejects any hello that does not offer X25519MLKEM768 before X25519,
# and every sing-box based client strips X25519MLKEM768 from its REALITY hello (Hiddify app before 5.5.5, NekoBox,
# Karing, sing-box, ...): with 26.10.31 REALITY worked only on Hiddify 5.5.5. Empty again = the latest in packages.lock.
version="26.7.28"
mkdir -p bin run


download_package xray sb.zip $version
if [ "$?" == "0"  ] || ! is_installed ./bin/xray; then
    systemctl stop hiddify-xray.service > /dev/null 2>&1 
    rm -rf bin/*
    install_package unzip 
    unzip -o sb.zip -d bin/ > /dev/null || exit 1
    rm -r sb.zip 
    chown root:root bin/xray || exit 2
    chmod +x bin/xray || exit 3
    ln -sf /opt/hiddify-manager/services/xray/bin/xray /usr/bin/xray || exit 3
    set_installed_version xray $version
fi
