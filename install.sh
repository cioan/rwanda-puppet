#! /bin/bash

puppet apply -v \
  --detailed-exitcodes \
  --logdest=console \
  --logdest=syslog \
  --hiera_config=./hiera.yaml \
  --modulepath=./modules \
  manifests/site.pp
