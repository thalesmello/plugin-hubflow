#!fish
#
# git-flow-completion
# ===================
#
# Fish completion support for [HubFlow](https://github.com/datasift/gitflow)
#
# The contained completion routines provide support for completing:
#
#  * git-hf init and version
#  * feature, hotfix and release branches
#  * remote feature, hotfix and release branch names
#
#
# Installation
# ------------
#
# To achieve git-hf completion nirvana:
#
#  1. install using your favorite package manager
#
#
# The Fine Print
# --------------
#
# Copyright (c) 2012-2015 [Justin Hileman](http://justinhileman.com)
#
# Distributed under the [MIT License](http://creativecommons.org/licenses/MIT/)


## Support functions

function __fish_git_hf_using_command
  set cmd (commandline -opc)
  set subcommands $argv
  if [ (count $cmd) = (math (count $subcommands) + 1) ]
    for i in (seq (count $subcommands))
      if not test $subcommands[$i] = $cmd[(math $i + 1)]
        return 1
      end
    end
    return 0
  end
  return 1
end

function __fish_git_hf_prefix
  git config "hubflow.prefix.$argv[1]" 2> /dev/null; or echo "$argv[1]/"
end

function __fish_git_hf_branches
  set prefix (__fish_git_hf_prefix $argv[1])
  __fish_git_branches | grep --color=never "^$prefix" | sed "s,^$prefix,," | sort
end

function __fish_git_hf_remote_branches
  set prefix (__fish_git_hf_prefix $argv[1])
  set origin (git config hubflow.origin 2> /dev/null; or echo "origin")
  git branch -r 2> /dev/null | sed "s/^ *//g" | grep --color=never "^$origin/$prefix" | sed "s,^$origin/$prefix,," | sort
end

function __fish_git_hf_untracked_branches
  set branches (__fish_git_hf_branches $argv[1])
  for branch in (__fish_git_hf_remote_branches $argv[1])
    if not contains $branch $branches
      echo $branch
    end
  end
end

function __fish_git_hf_unpublished_branches
  set branches (__fish_git_hf_remote_branches $argv[1])
  for branch in (__fish_git_hf_branches $argv[1])
    if not contains $branch $branches
      echo $branch
    end
  end
end


## git-hf

complete -f git-hf -n '__fish_git_hf_using_command' -a version -d 'Show version information'



## git-hf init

complete -f git-hf -n '__fish_git_hf_using_command' -a init    -d 'Initialize a new git repo with support for the branching model'
complete -f git-hf -n '__fish_git_hf_using_command init' -s f  -d 'Force reinitialization'
complete -f git-hf -n '__fish_git_hf_using_command init' -s d  -d 'Use default branch names'



## git-hf feature

complete -f git-hf -n '__fish_git_hf_using_command' -a feature      -d 'Manage feature branches'
complete -f git-hf -n '__fish_git_hf_using_command feature' -a list -d 'List feature branches'
complete -f git-hf -n '__fish_git_hf_using_command feature' -s v    -d 'Verbose output'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a start    -d 'Start a new feature branch'
complete -f git-hf -n '__fish_git_hf_using_command feature start' -s F  -d 'Fetch from origin first'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a finish   -d 'Finish a feature branch'
complete -f git-hf -n '__fish_git_hf_using_command feature finish' -s F -d 'Fetch from origin first'
complete -f git-hf -n '__fish_git_hf_using_command feature finish' -s r -d 'Rebase instead of merging'
complete -f git-hf -n '__fish_git_hf_using_command feature finish' -a '(__fish_git_hf_branches feature)' -d 'Feature branch'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a publish  -d 'Publish a feature branch to remote'
complete -f git-hf -n '__fish_git_hf_using_command feature publish' -a '(__fish_git_hf_unpublished_branches feature)' -d 'Feature branch'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a track    -d 'Checkout remote feature branch'
complete -f git-hf -n '__fish_git_hf_using_command feature track' -a '(__fish_git_hf_untracked_branches feature)' -d 'Feature branch'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a diff     -d 'Show all changes'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a rebase   -d 'Rebase against integration branch'
complete -f git-hf -n '__fish_git_hf_using_command feature rebase' -s i -d 'Do an interactive rebase'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a checkout -d 'Checkout local feature branch'
complete -f git-hf -n '__fish_git_hf_using_command feature checkout' -a '(__fish_git_hf_branches feature)' -d 'Feature branch'

complete -f git-hf -n '__fish_git_hf_using_command feature' -a pull     -d 'Pull changes from remote'
complete -f git-hf -n '__fish_git_hf_using_command feature pull' -a '(__fish_git_remotes)' -d 'Remote'



## git-hf release

complete -f git-hf -n '__fish_git_hf_using_command' -a release      -d 'Manage release branches'
complete -f git-hf -n '__fish_git_hf_using_command release' -a list -d 'List release branches'
complete -f git-hf -n '__fish_git_hf_using_command release' -s v    -d 'Verbose output'

complete -f git-hf -n '__fish_git_hf_using_command release' -a start -d 'Start a new release branch'
complete -f git-hf -n '__fish_git_hf_using_command release start' -s F  -d 'Fetch from origin first'

complete -f git-hf -n '__fish_git_hf_using_command release' -a finish   -d 'Finish a release branch'
complete -f git-hf -n '__fish_git_hf_using_command release finish' -s F -d 'Fetch from origin first'
complete -f git-hf -n '__fish_git_hf_using_command release finish' -s s -d 'Sign the release tag cryptographically'
complete -f git-hf -n '__fish_git_hf_using_command release finish' -s u -d 'Use the given GPG-key for the digital signature (implies -s)'
complete -f git-hf -n '__fish_git_hf_using_command release finish' -s m -d 'Use the given tag message'
complete -f git-hf -n '__fish_git_hf_using_command release finish' -s p -d 'Push to $ORIGIN after performing finish'
complete -f git-hf -n '__fish_git_hf_using_command release finish' -a '(__fish_git_hf_branches release)' -d 'Release branch'

complete -f git-hf -n '__fish_git_hf_using_command release' -a publish  -d 'Publish a release branch to remote'
complete -f git-hf -n '__fish_git_hf_using_command release publish' -a '(__fish_git_hf_unpublished_branches release)' -d 'Release branch'

complete -f git-hf -n '__fish_git_hf_using_command release' -a track    -d 'Checkout remote release branch'
complete -f git-hf -n '__fish_git_hf_using_command release track' -a '(__fish_git_hf_untracked_branches release)' -d 'Release branch'



## git-hf hotfix

complete -f git-hf -n '__fish_git_hf_using_command' -a hotfix      -d 'Manage hotfix branches'
complete -f git-hf -n '__fish_git_hf_using_command hotfix' -a list -d 'List hotfix branches'
complete -f git-hf -n '__fish_git_hf_using_command hotfix' -s v    -d 'Verbose output'

complete -f git-hf -n '__fish_git_hf_using_command hotfix' -a start -d 'Start a new hotfix branch'
complete -f git-hf -n '__fish_git_hf_using_command hotfix start' -s F  -d 'Fetch from origin first'

complete -f git-hf -n '__fish_git_hf_using_command hotfix' -a finish   -d 'Finish a hotfix branch'
complete -f git-hf -n '__fish_git_hf_using_command hotfix finish' -s F -d 'Fetch from origin first'
complete -f git-hf -n '__fish_git_hf_using_command hotfix finish' -s s -d 'Sign the hotfix tag cryptographically'
complete -f git-hf -n '__fish_git_hf_using_command hotfix finish' -s u -d 'Use the given GPG-key for the digital signature (implies -s)'
complete -f git-hf -n '__fish_git_hf_using_command hotfix finish' -s m -d 'Use the given tag message'
complete -f git-hf -n '__fish_git_hf_using_command hotfix finish' -s p -d 'Push to $ORIGIN after performing finish'
complete -f git-hf -n '__fish_git_hf_using_command hotfix finish' -a '(__fish_git_hf_branches hotfix)' -d 'Hotfix branch'



## git-hf support

complete -f git-hf -n '__fish_git_hf_using_command' -a support      -d 'Manage support branches'
complete -f git-hf -n '__fish_git_hf_using_command support' -a list -d 'List support branches'
complete -f git-hf -n '__fish_git_hf_using_command support' -s v    -d 'Verbose output'

complete -f git-hf -n '__fish_git_hf_using_command support' -a start -d 'Start a new support branch'
complete -f git-hf -n '__fish_git_hf_using_command support start' -s F  -d 'Fetch from origin first'

