#!/bin/bash
echo '┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'
echo '┃ generate layout with default snippet ┃'
echo '┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛'

route_path=''
parse_args() {
  if [ -n "$1" ]; then
    route_path=$1
  fi
}

while [[ "$#" -ge 1 ]]; do
  parse_args "$1"
  shift
done

if [ -z "$route_path" ]; then
  echo "enter a layout directory path"
  echo "ex) foo/bar or (route-group)/foo/bar"
  read -rp "=> app/" route_path
fi

directory_path=src/app/$route_path

if [[ ! -d "$directory_path" ]]; then
  echo "no directory"
  exit 5
fi

layout_file="import { ReactNode } from 'react';

interface LayoutProps {
  children: ReactNode;
}

function Layout({ children }: LayoutProps) {
  return <div>{children}</div>;
}

export default Layout;"

echo "$layout_file" >"$directory_path/layout.tsx"
echo "write app/$route_path/layout.tsx file"
