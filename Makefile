# MSP432 Twitter Client - a handheld MSP432 Twitter client!
# Copyright (C) 2015 Albert Huang.
# Based on various examples from Robert Wessels @ TI, LGPLv2.1.
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

# Makefile for project

# Energia doesn't have CLI support yet, so this is disabled, but
# still useful to have once Energia gets the support!
ENERGIA_PREFIX=~/energia-0101E0016
ENERGIA=$(ENERGIA_PREFIX)/energia

.PHONY: clean upload

all: src-out/temboo_login.h src-out/MSP432_Twitter_Client.ino
	@#$(ENERGIA) --board msp432:MSP-EXP432P401R --verify src-out/MSP432_Twitter_Client.ino
	@echo "Please compile src-out/MSP432_Twitter_Client.ino manually."

upload:
	@#$(ENERGIA) --board msp432:MSP-EXP432P401R --upload src-out/MSP432_Twitter_Client.ino
	@echo "Please compile and upload src-out/MSP432_Twitter_Client.ino manually."

src-out/temboo_login.h:
	./merge_src_auth.sh

src-out/MSP432_Twitter_Client.ino:
	cp MSP432_Twitter_Client.ino src-out/MSP432_Twitter_Client.ino

clean:
	rm -f src-out/*

