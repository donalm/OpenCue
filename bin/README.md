# Development Tooling

It can be useful to configure the applications to run directly from the
checkout of OpenCue that you're developing on.

The scripts in this directory tree configure a basic deployment of OpenCue on
one machine (your workstation, for example) and then bootstrap the individual
applications to launch using your checkout.

The 'rebuild' script sets up a new installation of OpenCue. It just expects you
to have Postgres installed (including the contrib rpm) and it needs python2,
python3 and virtualenv to be available.

## Config Files

These can be updated if you wish:

- database_credentials.sh
- opencue_conf.yaml
- update_environment.sh

The only value that strictly needs to be updated is the password in the
database_credentials.sh file.

