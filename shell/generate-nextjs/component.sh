#!/bin/bash
echo '┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'
echo '┃ generate component with default snippet ┃'
echo '┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛'

component_name=''
component_path=''
directory_path=''

to_kebab_case() {
  local input="$1"
  result=$(echo "$input" | sed -E 's/[_ ]+/-/g; s/([a-z])([A-Z])/\1-\2/g' | tr "[:upper:]" "[:lower:]")

  echo "$result"
}

to_pascal_case() {
  local input=$1
  result=$(echo "$input" | awk -F'[-_]' '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)} printf "%s", $0}')
  result=$(echo "$result" | tr -d ' ')

  echo "$result"
}

read -rp "enter a component directory path: " component_path
read -rp "enter a component name in PascalCase: " component_name
component_name=$(to_pascal_case "$component_name")

directory_path="src/components/$component_path/$component_name"
mkdir -p "$directory_path"
echo "mkdir $directory_path"

root_class_name=$(to_kebab_case "$component_name");
props_type_name="$component_name"Props;

# 컴포넌트 스니펫
component_file="import React from 'react';
import './index.scss';

export interface ${props_type_name} {
  children: React.ReactNode;
}

const ${component_name} = ({ children }: ${props_type_name}) => {
  return <div>{children}</div>;
};

export default ${component_name};";

# 스토리북 스니펫
storybook_file="import type { Meta, StoryObj } from '@storybook/react';
import ${component_name} from '.';

const meta: Meta<typeof ${component_name}> = {
  component: ${component_name},
  tags: ['autodocs'],
};

export default meta;

// ${component_name}.displayName = '${component_name}';

export const Default: StoryObj<typeof ${component_name}> = {
  args: {
    children: '${component_name}',
  },
};";

# scss 스니펫
scss_file=".${root_class_name} {
  \$self: #{&};
}";

echo "$component_file" > "$directory_path/index.tsx"
echo "write $directory_path/index.tsx file"
echo "$storybook_file" > "$directory_path/index.stories.tsx"
echo "write $directory_path/index.stories.tsx file"
echo "$scss_file" > "$directory_path/index.scss"
echo "write $directory_path/index.scss file"

# export 경로 설정
export_path="$component_path/index.tsx"
export_text="export * from './$directory_path/$component_name';
export { default as $component_name } from './$directory_path/$component_name';"

lastLine=$(grep -n "/$directory_path/" "$export_path" | tail -n1 | cut -d ":" -f1)
newLine=$((lastLine + 1))

if [[ -n $lastLine ]]; then
  {
    head -n "$((newLine-1))" "$export_path"
    echo "$export_text"
    tail -n "+$newLine" "$export_path"
  } > tmpfile && mv tmpfile "$export_path"
else
  echo -e "\n$export_text" >> "$export_path"
fi
