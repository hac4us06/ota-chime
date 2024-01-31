#!/bin/bash
# Make executable (chmod +x createjson.sh) and run it (./createjson.sh)


# Modify values below
# Leave blank if not used
codename="" # devon
devicename="" # Moto G32
maintainer="" # Ayush x José
zip="" # GenesisOS-Utopia-v1.0-devon-OFFICIAL-20240131-1953.zip


# Don't modify from here
script_path=${PWD}/..
zip_name=$script_path/out/target/product/$codename/$zip
buildprop=$script_path/out/target/product/$codename/system/build.prop

if [ -f $script_path/ota/devices/$codename.json ]; then
  rm $script_path/ota/devices/$codename.json
fi

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
sha256=`sha256sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
version=`echo "$zip_only" | cut -d'-' -f3`
echo "done."
echo '{
  "response": [
    {
        "datetime": '$timestamp',
	"filename": "'$zip_only'",
	"id": "'$sha256'",
	"size": '$size',
        "url": "https://dl.genesisos.dev/0:/'$codename'/'$zip_only'",
        "version": "'$version'",
	"devicename": "'$devicename'",
	"maintainer": "'$maintainer'"
    }
  ]
}'>>$script_path/ota/devices/$codename.json
