# PS-CreateLabVMs
General sequence of scripts you might use to create and Active Directory environment for a lab, especially if you have to replicate that lab with slight changes if you're running many instances at once.

* These scripts have been slightly modified (and not tested) from an actual instance where I've needed to create a set of labs.
* You should not pull them down and expect them to work perfectly for you, especially if you don't test them before using them for your real production run

## Pre-Requisites
You'll need your own set of usernames for '.\Names.csv', with the column header: `first,last,title`. There can be as many usernames as you want.

**WARNING** This will not create a totally realistic AD environment - normal AD environments actually fill out things like who a person's supervisor is and other organizational details like address, phone numbers, etc. This is only sufficient for labs where those things are not a requirement
