#!/bin/sh
# Source and Authentication Merger - tool for merging private
# authentication details into source
# (C) Copyright 2015 Albert Huang
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Variables
FILES_TO_MERGE=""
VARS_TO_REPLACE=""
OPTIONAL_VARS=""
CONF_NAME="msp432twitterclient"

# Core Functions

# 0 is successful match, 1 is fail to match
# (grep-like exit codes)
_find_in_arr() {
    skip_first=0
    found=1
    for item in $@; do
        [ "$skip_first" = 0 ] && skip_first=1 && continue
        
        [ "$item" = "$1" ] && found=0 && break
    done
    return $found
}

add_file() {
    for f in $@; do
        _find_in_arr "$f" "$FILES_TO_MERGE" && \
            echo "ERROR: Duplicate file '$f' detected" \
                "- this is a bug." \
            && exit 1
    done
        
    if [ "$FILES_TO_MERGE" = "" ]; then
        FILES_TO_MERGE="$@"
    else
        FILES_TO_MERGE="$FILES_TO_MERGE $@"
    fi
}

add_replacement() {
    for var in $@; do
        _find_in_arr "$var" $VARS_TO_REPLACE && \
            echo "ERROR: Duplicate variable '$var' detected" \
                "- this is a bug." \
            && exit 1
    done
        
    if [ "$VARS_TO_REPLACE" = "" ]; then
        VARS_TO_REPLACE="$@"
    else
        VARS_TO_REPLACE="$VARS_TO_REPLACE $@"
    fi
}

set_optional() {
    for var in $@; do
        _find_in_arr "$var" $OPTIONAL_VARS &&
            echo "ERROR: Duplicate variable '$var' detected" \
                "- this is a bug." \
            && exit 1
        
        # Ensure that the variable already exists in the replacement
        # list
        in_replace_list=1
        _find_in_arr "$var" $VARS_TO_REPLACE || in_replace_list=0
        
        [ "$in_replace_list" = "0" ] && \
            echo "ERROR: Non-existent variable '$var' detected" \
                "- this is a bug." && \
            echo "Variables must be added first, then set optional." \
            && exit 1
    done
        
    if [ "$OPTIONAL_VARS" = "" ]; then
        OPTIONAL_VARS="$@"
    else
        OPTIONAL_VARS="$OPTIONAL_VARS $@"
    fi
}

# TODO: Allow blank variables
check_any_reqs() {
    for var in $VARS_TO_REPLACE; do
        _find_in_arr "$var" "$OPTIONAL_VARS"
        [ ! "$?" = "0" ] && \
            eval [ -z \"\$$var\" ] && \
                return 1
    done
    
    return 0
}

print_any_reqs() {
    for var in $VARS_TO_REPLACE; do
        _find_in_arr "$var" "$OPTIONAL_VARS"
        [ ! "$?" = "0" ] && \
            eval [ -z \"\$$var\" ] && \
                echo "Variable '$var' needs to be defined."
    done
}

check_final_reqs() {
    for var in $VARS_TO_REPLACE; do
        _find_in_arr "$var" "$OPTIONAL_VARS"
        [ ! "$?" = "0" ] && \
            eval [ -z \"\$$var\" ] && \
                echo "ERROR: Undefined variable '$var' detected" \
                    "- this must be defined in your config." \
                && echo "Other variables not defined include:" \
                && print_any_reqs \
                && exit 1
    done
}

# TODO: set_dependency(), set_description(), set_mutex()

do_replacements() {
    for f in $FILES_TO_MERGE; do
        echo "Merging authentication info for file $f..."
        cp "$f" /tmp/merge_src_auth.tmp-file
        for var in $VARS_TO_REPLACE; do
            _find_in_arr "$var" "$OPTIONAL_VARS"
            [ "$?" = "0" ] && \
                eval [ -z \"\$$var\" ] && \
                echo "Removing optional line: $var" && \
                (cat /tmp/merge_src_auth.tmp-file | sed "/::$var::/d" > /tmp/merge_src_auth.tmp-file2) && \
                mv /tmp/merge_src_auth.tmp-file2 /tmp/merge_src_auth.tmp-file && continue
            
            # Dirty...
            eval echo \$"$var" > /tmp/merge_src_auth.tmp-subst
            subst=`cat /tmp/merge_src_auth.tmp-subst`
            rm /tmp/merge_src_auth.tmp-subst
            
            (cat /tmp/merge_src_auth.tmp-file | sed "s/::$var::/$subst/g" > /tmp/merge_src_auth.tmp-file2) && \
            mv /tmp/merge_src_auth.tmp-file2 /tmp/merge_src_auth.tmp-file
        done
        mv /tmp/merge_src_auth.tmp-file "src-out/$f"
    done
}

# Main program

# Check for initial project setup configuration.
# If none exists, exit.
if [ -f "authsrc_$CONF_NAME""_setup.conf" ]; then
    . ./"authsrc_$CONF_NAME""_setup.conf"
else
    echo "No configuration file found for authentication replacement."
    echo "(Searching for: auth_src_$CONF_NAME""_setup.conf)"
    echo "Exiting."
    exit 0
fi

# Check for any need to load specific authentication.
check_any_reqs && NEED_USER_CONF=0 || NEED_USER_CONF=1

if [ "$NEED_USER_CONF" = "1" ]; then
    # Load user-specific authentication.
    # We attempt to load the dotfile first, then attempt to load the regular
    # configuration file.
    if [ -f "$HOME/.authsrc_""$CONF_NAME" ]; then
        . "$HOME/.authsrc_""$CONF_NAME"
    elif [ -f "$HOME/authsrc_""$CONF_NAME"".conf" ]; then
        . "$HOME/authsrc_""$CONF_NAME"".conf"
    else
        echo "ERROR: No user configuration found, needed for" \
            "undefined variables."
        echo "These variables need to be defined:"
        print_any_reqs
        echo "Create a file called $HOME/.authsrc_""$CONF_NAME"
        echo "or $HOME/authsrc_""$CONF_NAME"".conf."
        echo "(The first file has higher precedence.)"
        echo "Then add variables and values: VAR=value"
        exit 1
    fi
fi

check_final_reqs

do_replacements
