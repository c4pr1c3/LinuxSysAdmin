#!/bin/bash
# ref: http://rmarkdown.rstudio.com/revealjs_presentation_format.html

parent_dir="$(pwd)"
git_repo_url="https://github.com/c4pr1c3/reveal.js.git"
css_src_file="${parent_dir}/reveal.js/css/reveal.css"
css_min_file="reveal.js/css/reveal.min.css"
js_src_file="${parent_dir}/reveal.js/js/reveal.js"
js_min_file="reveal.js/js/reveal.min.js"

if [ ! -f "${css_src_file}" ] || [ ! -f "${js_src_file}" ];then
  # download reveal.js repo
  git_tmp=$(mktemp -d)
  echo "git cloning ${git_repo_url}"
  if [[ $(git --git-dir="${git_tmp}" clone --depth=1 ${git_repo_url}) ]];then
    echo "Done with git clone ${git_repo_url}"
  else
    echo "Failed with git clone ${git_repo_url}"
    exit 1
  fi
else
  echo "reveal.js is installed"
fi

if [[ ! -e "${css_min_file}" ]];then
  ln -s "${css_src_file}" "${css_min_file}"
fi
if [[ ! -e "${js_min_file}" ]];then
  ln -s "${js_src_file}" "${js_min_file}"
fi

if [[ -x $(command -v pandoc) ]];then
  for input in ./*.md;do
    if [[ "$input" == "./README.md" ]];then
      continue
    fi
    output_ppt="${input}.html"
    output_html="${input}.print.html"
    pandoc -t revealjs -s "${input}" -V theme=white -V transition=fade -V incremental=true -V slideNumber=true -o "${output_ppt}" -V revealjs-url="reveal.js" -V history=true
    echo "generated presentation file: ${output_ppt}"
    pandoc -t html5 -s "${input}" -V theme=white -V transition=fade -V incremental=true -V slideNumber=true -o "${output_html}" -V revealjs-url="reveal.js" -V history=true
    echo "generated presentation file: ${output_html}"
  done
  # 生成默认首页
  pandoc index.md -s -o index.html
else
  echo "You need to install pandoc to run this script"
  exit 1
fi
