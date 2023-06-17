#!/bin/bash
echo '┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'
echo '┃ generate page with default snippet ┃'
echo '┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛'

escape='\033'
color_blue="${escape}[096m" # Blue Color
color_none="${escape}[0m"
under_line="${escape}[4m"
cursor_up="${escape}[1A"
use_layout=1
bold() {
  echo -e "${color_blue}${under_line}$1${color_none}"
}

echo "enter a page directory"
echo "ex) foo/bar or (route-group)/foo/bar"
read -rp "=> app/" route_path
directory_path=src/app/$route_path
mkdir -p "$directory_path"
echo "mkdir $directory_path"

page_file="function Page() {
  return <div></div>;
}

export default Page;"
echo "$page_file" >"$directory_path/page.tsx"
echo "write app/$route_path/page.tsx file"

echo -e "Would you like to use layout.ts? … No / $(bold Yes)"

while :; do
  read -s -r -n3 key

  case "$key" in
  $'\e[C')
    use_layout=1
    echo -e "${cursor_up}Would you like to use layout.ts? … No / $(bold Yes)"
    ;;
  $'\e[D')
    use_layout=0
    echo -e "${cursor_up}Would you like to use layout.ts? … $(bold No) / Yes"
    ;;
  '')
    break
    ;;
  esac
done

if [ "$use_layout" -eq 1 ]; then
  bash tools/generate/layout/index.sh "$route_path"
fi
