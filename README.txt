Vim configuration files for Drupal developers

The files in this directory are designed to make it easier for Drupal developers to edit files using vim.

INSTALLATION

Copy the files, other than this README.txt, into your vimfiles directory.  For most users, your vimfiles directory is ~/.vim; from within vim, use

:help vimfiles

for details.  If you have downloaded these files as ultimate_vimrc.tgz and your vimfiles directory is ~/.vim, then this should work:

$ cd ~/.vim
$ tar xzf ~/src/ultimate_vimrc.tgz --strip-components 1
$ rm README.txt

When you are done, you should have the following directory structure inside your vimfiles directory:

	doc/
	ftdetect/
	ftdetect/drupal.vim
	ftplugin/
	ftplugin/php_drupal.vim
	plugin/
	plugin/drupal.vim

UPDATES AND SUPPORT

For the latest version of this project, see http://drupal.org/project/vimrc .
To file a bug report or feature request, see the corresponding issues queue:
http://drupal.org/project/issues/vimrc?status=All&categories=All
