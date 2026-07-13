set git_paths $fish_complete_path/git.fish*

for path in $git_paths
  if test "$path" != "$(status --current-filename)"
    source $path
    break
  end
end

complete -f git -a hf -d 'Manage a git-hf enabled repository'
