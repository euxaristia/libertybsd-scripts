===============================================================================
LIBERTYBSD-SCRIPTS                                       For deblobbing OpenBSD
===============================================================================

Scripts used to deblob and rebrand OpenBSD source-code, made for the
LibertyBSD project. You can get OBSD sources from your local mirror
at https://www.openbsd.org/ftp.html, as the 'src', 'xenocara', or 'sys'
tarballs. CVS can be used, as well.


----------------------------------------
SCRIPTS
----------------------------------------
There are five scripts here. Here's what they do:

	src_deblob.sh	Deblobs main OBSD source of NF FW, references, etc
	man_deblob.sh	Gets rid of pages with non-free (NF) references
	sys_deblob.sh	Deletes NF firmware and references thereof from kernel

	src_rebrand.sh	Basic system rebranding, etc
	sys_rebrand.sh	System/boot rebranding
	man_rebrand.sh	Rebrand man-pages, and add some of our new ones
	xenocara_rebrand.sh
			Rebrands X sources-- not much to this one

	ports_deblob.sh
			Deblob ports tree of all NF listings
	ports_rebrand.sh
			Rebrand ports in ports-tree, etc



----------------------------------------
USAGE
----------------------------------------
Usage of these scripts is pretty simple-- to make freshly deblobbed OBSD
sources, just run them each with the argument being the directory of the
corresponding source-code, like so:

	sh src_deblob.sh /usr/src
	sh man_deblob.sh /usr/src
	sh sys_deblob.sh /usr/src/sys
	sh xenocara_rebrand.sh /usr/xenocara
	sh ports_deblob.sh /usr/ports

For LibertyBSD 7.8 release prep in one shot, use:
	sh prepare-release-7.8.sh /usr/src /usr/src/sys /usr/xenocara /usr/ports

If you want liberated OpenBSD sources, but without the LibertyBSD rebranding,
just skip the *_rebrand.sh scripts and everything should go fine.



----------------------------------------
NOTES
----------------------------------------
All of the scripts make use of "./libdeblob.sh", and all file-editing/etc
operations are abstracted to its functions.

This is because instead of actually applying changes directly to OBSD
sources, the deblob scripts create a set of patches for them, and *then*
apply them.

You might want to perform multiple operations on a given file, (I.E.,
substitute text, then remove a line, etc.). After every operation, a new
(modified) version of the file is created in the /tmp/ directory, along with
a patch. So if you want to do multiple operations, you'll need to decide
whether or not to use the original source-code, or a modified version from
/tmp/...

This has been abstracted away with the "ifile" and "ofile" functions.
"ifile" outputs to stdout the contents of the file-- be it the patch-file, the
original, whatever is appropriate. "ofile" writes to the patch-file what is
piped to it, and handles the bullocks.

Hence why "ifile | operation | ofile" is so common in libdeblob.sh

Each script uses a very clearly-named /tmp/ directory...
	/tmp/script-name/


While it is a *tad* bit weird do all of this indirect work on the sources, it
has a few advantages I'd like to stick with:
	* Abstraction.
		Operations are all very general and unspecific; you don't need
		to manually muck with `sed` for every individual patch.
	* Easy debugging.
		If there's a problem, you can stop the script before it patches
		original sources, and look at the /tmp/ data. Compare the
		.orig with the .patch with the modified, etc. Very useful.
	* Patch generation.
		With patches being integral to the entire process, it makes all
		changes made to OBSD source code very transparent. Anyone could
		take a look at a tarball of the patches and understand *exactly*
		what changed. 
		There're probably some other obscure use-cases for these
		patches, anyway. And if it's easy to support a weird
		hypothetical use-case, why not?

... in order of importance.



----------------------------------------
BORING STUFF
----------------------------------------
Send patches/issues to:
</f/libertybsd> (raddle.me)
<#libertybsd> (Freenode)
<jadedctrl@teknik.io>
<LibertyBSD/libertybsd-scripts> (NotABug)

License is ISC (COPYING.txt)
Author is Jaidyn Ann <jadedctrl@teknik.io>
Some ports contributions by jmfgdef (Jimmybot),
Some improvements by Einhard Leichtfuß.
Source is at https://notabug.org/LibertyBSD/libertybsd-scripts
