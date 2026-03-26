set git_paths $fish_complete_path/git.fish*

for path in $git_paths
  if test "$path" != "$(status --current-filename)"
    source $path
    break
  end
end

complete -f git -n __fish_git_needs_command -a hf -d 'Manage a git-hf enabled repository'
