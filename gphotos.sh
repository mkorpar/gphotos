find /data -name "*.tgz" -exec tar -xzf {} -C /data \;
mv "/data/Takeout/Google Photos/" "/data/photos"
rm -rf "/data/Takeout/"
find "/data/photos" -type d ! -path "/data/photos" ! -regex ".* - .*" -exec rm -rf "{}" \;

find /data/photos -type f -name "*.json" | while read f; do
    img="${f%.*}"
    if [ -f "$img" ]; then

        ext="${img##*.}"
        if [ "$ext" != "jpg" ] && [ "$ext" != "JPG" ]; then
            if [ "$ext" != "mov" ] && [ "$ext" != "MOV" ]; then
                echo "converting: $img"
                convert "$img" "${img%.*}.jpg"
                rm -f "$img"
                img="${img%.*}.jpg"
            fi
        fi

        echo "$img"
        ct=$(jq -r '.photoTakenTime | .timestamp' "$f")
        ct=$(date +'%Y:%m:%d %H:%M:%S.s' -d "@$ct")
        exiftool -overwrite_original_in_place "-DateTimeOriginal=$ct" "$img"
    fi
done

#find /data/photos -type f -name "*.json" -exec rm -f "{}" \;