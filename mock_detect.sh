get_distro_id() {
    local file=$1
    if [[ -f "$file" ]]; then
        local id=""
        while IFS='=' read -r key val; do
            val="${val%\"}"
            val="${val#\"}"
            [[ "$key" == "ID" ]] && id="$val"
        done < "$file"
        echo "${id:-linux}" | tr '[:upper:]' '[:lower:]'
    else
        # check Android
        if uname -o | grep -iq android; then
            echo "android"
        else
            echo "linux"
        fi
    fi
}
get_distro_id mock_os_arch
get_distro_id mock_os_mint
get_distro_id /does/not/exist
