set git_paths $fish_complete_path/git.fis?

for path in $git_paths[-1..1]
  if test "$path" != "$(status --current-filename)"
    source $path
  end
end

complete -f git -a hf -d 'Manage a git-hf enabled repository'
