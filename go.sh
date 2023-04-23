function listings
{
gh release view --json assets 2>/dev/null | python3 -mjson.tool | sed  '1,2d;$d' | json -ga name url size updatedAt -d, | sort | grep $3 | (
while read -r line; do
	name=$(echo $line | cut -d"," -f1 | awk '{print tolower($0)}')
	url=$(echo $line | cut -d"," -f2)
	size=$(echo $line | cut -d"," -f3)
	updated=$(echo $line | cut -d"," -f4)
           if [[ "${name: -3}" == ".xz" ]]; then
             board_name=$(echo $name | cut -d"_" -f3)
             source ../build/config/boards/$board_name.*
             out_release=$(echo $name | cut -d"_" -f4)
             out_branch=$(echo $name | cut -d"_" -f5)
             out_kernel=$(echo $name | cut -d"_" -f6-7 | cut -d"." -f1-3 | cut -d"_" -f1)
             out_desktop=$(echo $name | cut -d"_" -f7)
             out_size=$(echo "scale=0; $size/1024/1024" | bc -l)"M"
             # outputs
             echo -ne "${board_name}/${out_release^}_${out_branch}$([[ -n "${out_desktop}" ]] && echo "_")${out_desktop}_nightly|$url|"$(date -d $updated +"%s")"|$out_size|\n" >> $1
             out_desktop=${out_desktop:-cli}
             echo -ne "| [$BOARD_NAME]($url#$board_name) | [:file_folder:]($url".asc") | [:file_folder:]($url".sha") | $out_release | $out_branch | $out_desktop | $out_size | $out_kernel |\n" >> $2
             #echo "$BOARD_NAME" >> unsupported.tmp
           fi
          done
          )
}

truncate data.csv --size=0
truncate README.md --size=0

echo -e "\n# Generic / popular\n"  >> README.md
echo "| Image &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | GPG | SHA | Release | Branch | &nbsp;&nbsp;&nbsp; Variant | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Kernel |" >> README.md
echo "| --- | :--: | :--: | --: | --: | --: | --: | --: |" >> README.md
release "data.csv" "README.md" "Uefi\|Rpi4b"
echo -e "<br>\n\n# Optimized \n\n" >> README.md
echo "| Image &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | GPG | SHA | Release | Branch | &nbsp;&nbsp;&nbsp; Variant | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Kernel |" >> README.md
echo "| --- | :--: | :--: | --: | --: | --: | --: | --: |" >> README.md
release "data.csv" "README.md" "-v Rpi4b\|Uefi"
