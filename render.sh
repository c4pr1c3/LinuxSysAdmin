#!/bin/bash
# ref: http://rmarkdown.rstudio.com/revealjs_presentation_format.html

parent_dir="$(pwd)"
git_repo_url="https://github.com/c4pr1c3/reveal.js.git"
css_src_file="${parent_dir}/reveal.js/css/reveal.css"
css_min_file="reveal.js/css/reveal.min.css"
js_src_file="${parent_dir}/reveal.js/js/reveal.js"
js_min_file="reveal.js/js/reveal.min.js"

input_files=($(ls *.md))

if [ ! -f ${css_src_file} ] || [ ! -f ${js_src_file} ];then
  # download reveal.js repo
  git_tmp=$(mktemp -d)
  echo "git cloning ${git_repo_url}"
  git --git-dir="${git_tmp}" clone --depth=1 ${git_repo_url} 
  if [[ $? -eq 0 ]];then
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

for input in ${input_files[@]};do
  if [[ -x $(which pandoc) ]];then
    output_ppt="${input}.html"
    output_html="${input}.print.html"
    pandoc -t revealjs -s ${input} -V theme=white -V transition=fade -V incremental=true -V slideNumber=true -o "${output_ppt}" -V revealjs-url="${parent_dir}/reveal.js" -V history=true
    echo "generated presentation file: ${output_ppt}"
    pandoc -t html5 -s ${input} -V theme=white -V transition=fade -V incremental=true -V slideNumber=true -o "${output_html}" -V revealjs-url="${parent_dir}/reveal.js" -V history=true
    echo "generated presentation file: ${output_html}"
  else
    echo "You need to install pandoc to run this script"
  fi
done
