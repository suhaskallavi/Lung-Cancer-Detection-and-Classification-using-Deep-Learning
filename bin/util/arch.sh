#!/bin/sh
#
# usage:        arch.sh
#
# abstract:     This Bourne Shell script determines the architecture
#               of the the current machine.
#
#               ARCH      - Machine architecture
#
#               IMPORTANT: The shell function 'check_archlist' is used
#                          by this routine and MUST be loaded first.
#                          This can be done by sourcing the file,
#
#                              archlist.sh
#
#                          before using this routine.
#
# note(s):      1. This routine must be called using a . (period)
#
#               2. Also returns ARCH_MSG which may contain additional
#                  information when ARCH returns 'unknown'.
#
# Copyright 1986-2011 The MathWorks, Inc.
#----------------------------------------------------------------------------
#
#=======================================================================
# Functions:
#   realfilepath ()
#   matlab_arch ()
#=======================================================================
    realfilepath () { # Returns the actual path in the file system
                      # of a file. It follows links. It returns an
                      # empty path if an error occurs.
                      #
                      # Returns a 1 status if the file does not exist
                      # or appears to be a circular link. Otherwise,
                      # a 0 status is returned.
                      #
                      # usage: realfilepath filepath
                      #
    filename=$1
#
# Now it is either a file or a link to a file.
#
    cpath=`pwd`

#
# Follow up to 8 links before giving up. Same as BSD 4.3
#
      n=1
      maxlinks=8
      while [ $n -le $maxlinks ]
      do
#
# Get directory correctly!
#
	newdir=`echo "$filename" | awk '
                        { tail = $0
                          np = index (tail, "/")
                          while ( np != 0 ) {
                             tail = substr (tail, np + 1, length (tail) - np)
                             if (tail == "" ) break
                             np = index (tail, "/")
                          }
                          head = substr ($0, 1, length ($0) - length (tail))
                          if ( tail == "." || tail == "..")
                             print $0
                          else
                             print head
                        }'`
	if [ ! "$newdir" ]; then
	    newdir="."
	fi
	(cd "$newdir") > /dev/null 2>&1
	if [ $? -ne 0 ]; then
	    return 1
	fi
	cd "$newdir"
#
# Need the function pwd - not the built in one
#
	newdir=`/bin/pwd`
#
	newbase=`expr //"$filename" : '.*/\(.*\)' \| "$filename"`
        lscmd=`ls -ld "$newbase" 2>/dev/null`
	if [ ! "$lscmd" ]; then
	    return 1
	fi
#
# Check for link portably
#
	if [ `expr "$lscmd" : '.*->.*'` -ne 0 ]; then
	    filename=`echo "$lscmd" | awk '{ print $NF }'`
	else
#
# It's a file
#
	    dir="$newdir"
	    command="$newbase"
#
	    cd "$dir"
#
# On Mac OS X, the -P option to pwd causes it to return a resolved path, but
# on 10.5, -P is no longer the default, so we are now passing -P explicitly
#
            if [ "$ARCH" = 'mac' -o "$ARCH" = 'maci' -o "$ARCH" = 'maci64' ]; then
                echo `/bin/pwd -P`/$command
#
# The Linux version of pwd returns a resolved path by default, and there is
# no -P option
#
            else
                echo `/bin/pwd`/$command
            fi
	    break
	fi
	n=`expr $n + 1`
      done
      if [ $n -gt $maxlinks ]; then
	return 1
      fi

    cd "$cpath"
    }
#
#=======================================================================
    set_mac_arch() {
        # First check to see if maci64 is even possible on this hardware
        if [ "`/usr/sbin/sysctl -n hw.cpu64bit_capable`" = "0" ]; then
            # maci64 is not possible. So set the arch to maci.
            ARCH="maci"
            return
        fi

        # Now check to see if maci64 is asked for
        if [ "$MACI64" = "0" ]; then
            # only maci is wanted, so arch is maci.
            ARCH="maci"
            return
        fi

        # If we get to this point, maci64 is available and desired. So, check to
        # see if 64 bit binaries are available. First, if $MATLABROOT is NOT
        # set, we can't really check for anything else.
        if [ "$MATLABROOT" = "" ]; then
            ARCH="maci64";
            return
        fi


        # if we get to this point, we need to check the binaries that we have to
        # find out if we have maci64 binaries
        if [ -d "$MATLABROOT/bin/maci64" ]; then
            ARCH="maci64"
            return
        fi

        # if we get to this point, even though maci64 is possible and desired,
        # the maci64 binaries aren't available, so fall back to maci
        ARCH="maci"
    }

#
#=======================================================================
    matlab_arch () {  # Determine the architecture for MATLAB
                      # It returns the value in the ARCH variable.
                      # If 'unknown' is returned then sometimes a
                      # diagnostic message is returned in ARCH_MSG.
                      #
                      # Always returns a 0 status.
                      #
                      # usage: matlab_arch
                      #
        ARCH="unknown"
#
        if [ -f /bin/uname ]; then
            case "`/bin/uname`" in
                SunOS)                                  # Solaris
                    case "`/bin/uname -p`" in
                        sparc)
                            ARCH="sol64"
                            ;;
                        i386)
                            ARCH="sola64"
                            ;;
                    esac
                    ;;
                Linux)
                    case "`/bin/uname -m`" in
                        i*86)
                            ARCH="glnx86"
                            ;;
                        x86_64)
                            ARCH="glnxa64"
                            ;;
                    esac
                    ;;
# Usually uname lives in /usr/bin on the Mac, but sometimes people
# have links in /bin that link uname to /usr/bin.  Because of this
# Mac needs to be listed in the checks for both /bin/uname and /usr/bin/uname
                Darwin)                                 # Mac OS X
                    case "`/bin/uname -p`" in
                        i386)
                            set_mac_arch
                            ;;
                        esac
                    ;;
                *)
                    :
                    ;;
            esac
        elif [ -f /usr/bin/uname ]; then
            case "`/usr/bin/uname`" in
                Darwin)                                 # Mac OS X
                    case "`/usr/bin/uname -p`" in
                        i386)
                            set_mac_arch
                            ;;
                        esac
                    ;;
            esac
        fi
        return 0
    }
#=======================================================================
#
# The local shell function check_archlist is assumed to be loaded before this
# function is sourced.
#
    ARCH_MSG=''
    check_archlist ARCH=$ARCH
    if [ "$ARCH" = "" ]; then
        if [ "$MATLAB_ARCH" != "" ]; then
            check_archlist MATLAB_ARCH=$MATLAB_ARCH
        fi
        if [ "$ARCH" = "" ]; then
            matlab_arch
        fi
    fi
    Arch=$ARCH
