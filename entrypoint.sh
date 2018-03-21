#!/bin/bash
set -e

# Add initialisation logic here
confd -onetime -backend env
sleep 3

# Run application - takes all the extra command line arguments and execs them as a command
exec "$@"