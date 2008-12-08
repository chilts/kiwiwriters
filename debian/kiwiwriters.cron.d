# m           h dom mon dow user         command

MAILTO=andychilton@gmail.com

# every fifteen minutes
  0,15,30,45  *  *   *   *  kiwiwriters  kw-progress.pl

# fix profiles regularly
  *           *  *   *   *  kiwiwriters  kw-fix-profile.pl

# send emails out every 10 mins
  */5         *  *   *   *  kiwiwriters  zaapt-send-email /etc/kiwiwriters/kiwiwriters.cfg

