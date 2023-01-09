#!/usr/bin/env zsh
# fake npm scripts hahaha

about () { #: show help & commands
    NAME='alfred-pub-dev-simple'
    echo "$NAME script runner"
    echo "Commands:"
    cat r.sh | sed -nr 's/^(.*) \(\).* #: (.*)$/  \1\t\2/p' | expand -20
}

build () { #: Build the app
    dart compile exe bin/pubdev_search.dart -o "workflow/pubdev_search-$(uname -m)"
}

dev:link () { #: link the WIP version to Alfred
    ln -s \
        /Users/adam/Code/alfred-pub-dev-simple/workflow \
        /Users/adam/Code/dotfiles/config/alfred5/Alfred.alfredpreferences/workflows/alfred-pub-dev-simple;
}

dev:unlink () { #: remove the WIP version link from Alfred
    rm /Users/adam/Code/dotfiles/config/alfred5/Alfred.alfredpreferences/workflows/alfred-pub-dev-simple;
}

test () { #: run tests
    zsh test/test.sh
}

if [[ $# > 0 ]]; then
    script=`shift 1`
    $script "$@"
else
    about
fi