#!/bin/bash

recursive_repo_search()
{
        for DIR in $(find -L $1 -mindepth 1 -maxdepth 1 -type d) ; do
                #echo $DIR
                cd $DIR
                if git rev-parse --git-dir > /dev/null 2>&1; then
                        # This is a valid git repository
                        pwd
                        git branch
                        cd - > /dev/null
                        #echo "$DIR is a git repo"
                else
                        # this is not a git repository
                        cd - > /dev/null
                        if (( $2 < 4 )); then
                                #echo "Recursing to level $(( $2 + 1 ))..."
                                recursive_repo_search $DIR $(( $2 + 1 ))
                        else
                                echo "Hard-coded depth limit reached! What is up with your arrangements folder?"
                        fi
                fi
        done
}

recursive_repo_search ./ 1
