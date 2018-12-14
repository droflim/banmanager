# description: adds useful public commands like !t, !op, !dop, !h, !dh, !v, !dv, !k, !kb, script is easy to use.

# simple to use:
# public cmds: !op, !dop, !h, !dh, !v, !dv <nick> ... <nick>, !t <topic>
# use '!t' if you want to set the topic as anonymous

# !k <nick> [<reason>], !kb <nick> [<reason>]

# Author: Tomekk
# e-mail:  tomekk/@/oswiecim/./eu/./org
# home page: http://tomekk.oswiecim.eu.org/
#
# Version 0.4
#
# This file is Copyrighted under the GNU Public License.
# http://www.gnu.org/copyleft/gpl.html

# default ban type is: *!*ident*@some.domain.com [4]

# fixed: problems with nicks with special characters
# fixed: some code fixes ;]
# added: unsed topic, just write !t, thats all

# halfop/dehalfop commands, 0 - disable, 1 - enable
set half 0

# sets ban type
# 1)  *!*@*.domain.com
# 2)  *!*@some.domain.com
# 3)  *nick*!*@some.domain.com
# 4)  *!*ident*@some.domain.com
set btype 4

bind pub o|o !op op_fct
bind pub o|o !dop deop_fct
bind pub o|o !v voice_fct
bind pub o|o !dv devoice_fct
bind pub o|o !k kick_fct
bind pub o|o !kb kick_ban_fct
bind pub o|o !t topic_fct

if {$half == "1"} {
	bind pub o|o !h halfop_fct
	bind pub o|o !dh dehalfop_fct
}

proc op_fct { nick uhost hand chan arg } {
	 set txt [split $arg]

         set player [lindex $txt 0]

	 if {$player != ""} {
		foreach opnick $txt {
			putquick "MODE $chan +o $opnick"
		}
		
	 } {
		putquick "MODE $chan +o $nick"
	 }
}

proc deop_fct { nick uhost hand chan arg } {
	global botnick

	set txt [split $arg]

	set player [lindex $txt 0]

	if {$player != ""} {
		foreach dopnick $txt {
			if {$botnick != $dopnick} {
				putquick "MODE $chan -o $dopnick"
			}
		}
	} {
		putquick "MODE $chan -o $nick"
	}
}

proc voice_fct { nick uhost hand chan arg } {
	set txt [split $arg]

	set player [lindex $txt 0]

        if {$player != ""} {
		foreach vnick $txt {
			putquick "MODE $chan +v $vnick"
		}
	} {
		putquick "MODE $chan +v $nick"
	}
}

proc devoice_fct { nick uhost hand chan arg } {
	global botnick

	set txt [split $arg]

	set player [lindex $txt 0]

	if {$player != ""} {
		foreach dvnick $txt {
			if {$botnick != $dvnick} {
				putquick "MODE $chan -v $dvnick"
			}
		}
	} {
		putquick "MODE $chan -v $nick"
	}
}
		
proc halfop_fct { nick uhost hand chan arg } {
	set txt [split $arg]

	set player [lindex $txt 0]

	if {$player != ""} {
		foreach hnick $txt {
			putquick "MODE $chan +h $hnick"
                }
	} {
			putquick "MODE $chan +h $nick"
	}
}

proc dehalfop_fct { nick uhost hand chan arg } {
	global botnick

	set txt [split $arg]

	set player [lindex $txt 0]

	if {$player != ""} {
		foreach dhnick $txt {
			if {$botnick != $dhnick} {
				putquick "MODE $chan -h $dhnick"
			}
		}
	} {
			putquick "MODE $chan -h $nick"
	}
}
	

proc kick_fct { nick uhost hand chan arg } {
	set txt [split $arg]

	set player [lindex $txt 0]

	set msg [join [lrange $txt 1 end]]
	
	if {![isbotnick $player]} {
		if {$player != ""} {
			putkick $chan $player $msg
		} {
			putkick $chan $nick $msg
		}
	}
}

proc kick_ban_fct { nick uhost hand chan arg } {
	set txt [split $arg]

	set player [lindex $txt 0]

        set msg [join [lrange $txt 1 end]]

        if {![isbotnick $player]} {
		if {$player != ""} {
			set victim $player
			set uhost [getchanhost $player $chan]
		} {
			set victim $nick
		}

		if {[onchan $victim $chan]} {
			set player_ident "[banmask $uhost $victim]"
		
			if {[isop $victim $chan]} {
				pushmode $chan "-o" $victim
			}

			putquick "MODE $chan +b $player_ident"
			putkick $chan $victim $msg
		}
	}
}

proc topic_fct { nick uhost hand chan arg } {
	if {$arg == ""} {
		putquick "TOPIC $chan :"
	} {
		putquick "TOPIC $chan :$arg"
	}
}

proc banmask {host nick} {
	global btype

	switch -- $btype {

	1 { 
		set mask "*!*@[lindex [split [maskhost $host] "@"] 1]" 
	  }
		
	2 { 
		set mask "*!*@[lindex [split $host @] 1]" 
	  }

	3 { 
		set mask "*$nick*!*@[lindex [split $host "@"] 1]"  
          }
	
        4 { 	
		set mask "*!*[lindex [split $host "@"] 0]*@[lindex [split $host "@"] 1]" 
	  }

 	return $mask
     }
}

putlog "tkpubcmds.tcl ver 0.4 by Tomekk loaded" 
