<img src="https://github.com/railsware/plunger/raw/master/plunger.jpg" style="float:right" />

# Plunger

Plunger is code review tool for Google Code Reviews.

Basically it's ruby wrapper for [Rietveld](http://code.google.com/p/rietveld/) upload.py tool.

## Goals

* Automated original upload tool installation and configuration
* Automated changeset generation with description/title/reviewers etc...

Supported VCS:

* git

## Install

Install tool:

    gem install plunger

Configure google code review for your organization:

See [Using Code Reviews with Google Apps](http://code.google.com/p/rietveld/wiki/CodeReviewHelp#Using_Code_Reviews_with_Google_Apps)

## Commands

To see all commands:

    plunger --help

### Configure command

Synopsis:

    plunger configure

It will ask your about required options and store configuration to *~/.gem/plunger*

### Push command

Synopsis:

    plunger push

    Push options:
        --initial REVISION           Initial changeset revision.
        --final REVISION             Final changeset revision.
        --issue NUMBER               Issue number to which to add. Defaults to new issue.


## Developer Flow

* Go to your VCS project and optionally switch to your working branch.
* Finish feature/fix implementation.
* Type ``plunger push``.
* Follow instructions and it generate and push changeset to codereview server.
