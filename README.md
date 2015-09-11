MSP432 Twitter Client
======================

Introduction
-------------
The MSP432 Twitter Client is just a fun little sketch I wrote while at
a TI workshop for the MSP432 platform. It's still a work in progress!

(Note that this is NOT by TI - it's just by a student wanting to learn
and have a bit of fun with the platform!)

Downloading
------------
You can get a ZIP from:
https://github.com/alberthdev/MSP432TwitterClient/master.zip

Alternatively, if you have a Git client, you can simple clone this
repository.

Requirements
-------------
To build, you will need:

 * Energia, from: http://energia.nu/
 * Linux/Mac or some UNIX; on Windows, Cygwin/MSYS

On Windows, you will need to open the Cygwin/MSYS environment first, and
then do the rest of the steps for building.

Building
---------
If you downloaded a ZIP release, make sure to unzip it!

Once you are ready, follow these instructions:

 1. Change directory to the directory with the MSP432 Twitter Client
    source code (e.g. this directory).
 2. Copy the sample configuration file,
    `authsrc_msp432twitterclient.conf`, to your home directory. You can
    accomplish this by running `cp authsrc_msp432twitterclient.conf ~/`.
 3. Modify the configuration file to include all necessary
    authentication details. Grab the Temboo API information from
    https://temboo.com and the Twitter API information from
    https://apps.twitter.com/.
 4. Once you're done editing, go back to the source directory.
 5. Type `make` and press ENTER.
 6. If everything works, you should now have a message to compile the
    client manually by yourself. Open Energia and proceed to compile
    your project! Note that you MUST use the `src-out` folder source,
    since it integrate your authentication details.

Note that you should NEVER modify code in `src-out` - only modify code
in this root directory! The build system generates code with updated
authentication information to `src-out` . As such, code within `src-out`
can be modified and deleted at any time!

Source and Authentication Merger
---------------------------------
One of the tools included is a tool for merging private authentication
details into source code. This is used to discretely insert
authentication details while reducing the risk of accidentally
publishing authentication details online.

The components include:
 
 * merge_src_auth.sh, the base script with all of the functions and
   setup necessary to load the configuration.
 * authsrc_msp432twitterclient_setup.conf, the project configuration that
   calls the functions and sets variables to prepare for variable
   replacement within the source files.
 * ~/.authsrc_msp432twitterclient or ~/authsrc_msp432twitterclient.conf,
   the user configuration with all of the authentication variable data
   for replacement in the source file.

Essentially, the main script sources from the project file first and
figures out what variables need to be replaced, and then loads the user
configuration file to try and fill the variables so that replacement
can occur.

Optional and default values can be set within the project file. Optional
values result in the removal of a source line when the variable in that
source line is optional and not defined. Default values can also be set
with the standard value setting (see below). However, it is important to
note that mixing optional and default values on the same variable will
cause problems! (Or rather, it will force the optional variable to show
up, therefore making it not optional!)

Values are set by using `VARIABLE_NAME=value`. This is essentially
shell scripting value setting, since the entire system is written as
a group of shell scripts.

More to come...
