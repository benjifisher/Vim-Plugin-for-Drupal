Vim configuration files for Drupal developers

The files in this directory are designed to make it easier for Drupal developers
to edit files using vim.

INSTALLATION

Copy the files, other than this README.txt, into your vimfiles directory.  For
most users, your vimfiles directory is ~/.vim; on Windows, it is ~\vimfiles by
default.  From within vim, use

:help vimfiles

for details.  If you have downloaded these files as ultimate_vimrc.tgz and your
vimfiles directory is ~/.vim, then this should work on UNIX-like systems:

$ cd ~/.vim
$ tar xzf path/to/ultimate_vimrc.tgz --strip-components 1 --exclude=README.txt

When you are done, you should have the following directory structure inside your
vimfiles directory:

        doc/drupal.txt
        ftdetect/drupal.vim
        ftplugin/drupal.vim
        plugin/drupal.vim

In order to use the tags defined in the help file, start vim and do
        :helptags ~/.vim/doc
(assuming that the file is installed as ~/.vim/doc/drupal.txt).  See
        :help add-local-help
for details.  After this step, you should be able to read the documentation with
        :help drupal.txt

UPDATES AND SUPPORT

For the latest version of this project, see http://drupal.org/project/vimrc .
To file a bug report or feature request, see the corresponding issues queue:
http://drupal.org/project/issues/vimrc?status=All&categories=All

TROUBLESHOOTING

* If :help dies not work:

If :help does not work in your installation of vim, you can find the official
vim documentation on-line at http://vimdoc.sourceforge.net/ .  It may be that
you have only a vim executable and not the "runtime" support files.

* If nothing works:

Some shared servers install a "tiny" version of Vim.  Many features of this
project will not work with such a version.  (See below for details.)  Check your
version of vim from a shell with

$ vim --version

The fourth line of output should tell you what sort of version you have.

It is possible to get a lot of the functionallity provided by the Drupal-Vim
plugins working with the tiny-vim by creating a vimrc file based on the contents
of the plugins.

* Creating the vimrc file

There are two methods to create the required vimrc file:

1) On Linux or Mac OS X, go to the directory where you have the files from this
project and

$ cat plugin/drupal.vim ftplugin/php_drupal.vim >> ~/.vimrc

This will add the contents of the two files to your vimrc file.
NOTE: Windows users should use ~\vimfiles instead of ~/.vimrc.  You will
probably need a method other than cat.

2) Create a vimrc file and add these two lines inside it:
        source path/to/vimrc/plugin/drupal.vim
        source path/to/vimrc/ftplugin/php_drupal.vim
NOTE: Where path/to/vimrc is where you extracted the contents of this project.

* Info on tiny-vim

You can find the original discussion here: http://drupal.org/node/1326562
This tiny-vim was found on a shared CentOS server and it identifies itself as:
========================================================================
VIM - Vi IMproved 7.0 (2006 May 7, compiled Mar 5 2011 21:36:07)
 Included patches: 1, 3-4, 7-9, 11, 13-17, 19-26, 29-31, 34-44, 47, 50-56,
58-64, 66-73, 75, 77-92, 94-107, 109, 202, 234-237
 Compiled by
 Tiny version without GUI.
...
========================================================================
Notice the fourth line!

Known to work on the tiny-vim are:
* Line numbers
* Multiple Undos
* Arrow keys are usable in Insert mode

Known NOT to work and their workarounds (if any):
* Vim Help, aka :help command. Luckily for us there is
http://vimdoc.sourceforge.net/
* Color/syntax highlighting
* Persistent Undo (introduced in Vim7.3, so a tiny 7.3 might have this feature)

Please help make this troubleshooting section better either by enriching it
yourself or by posting on the issue queue:
http://drupal.org/project/issues/vimrc.
