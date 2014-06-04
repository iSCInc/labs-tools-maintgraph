#!/bin/bash

cd /data/project/maintgraph

# lavoro_sporco.sh
echo -n $(date "+%Y-%m-%d %H:%M:%S")
cat public_html/data/lavoro_sporco.csv | grep $(date +%Y%m%d) > /dev/null

if [ $? -eq 0 ]
  then
    echo ": lavoro_sporco.sh [skip]"
  else
    if [ $(date +%H) -eq 19 ]
      then
        echo ": lavoro_sporco.sh [run]"
      else
        echo ": lavoro_sporco.sh [failover]"
    fi

    ./lavoro_sporco.sh

    echo -n $(date "+%Y-%m-%d %H:%M:%S")
    tail -n 1 public_html/data/lavoro_sporco.csv | grep -E "[0-9]{8},([0-9]+,){23}[0-9]+" > /dev/null

    if [ $? -eq 0 ]
      then
        echo ": lavoro_sporco.sh [ok]"
        tail -n 1 public_html/data/lavoro_sporco.csv > bot.csv
      else
        echo ": lavoro_sporco.sh [error]"
        echo -e "Subject: lavoro_sporco.sh [error]\n\nChecking of lavoro_sporco.csv failed." | /usr/sbin/exim -odf -i  maintgraph.maintainers@tools.wmflabs.org
    fi
fi

# diff.sh
echo -n $(date "+%Y-%m-%d %H:%M:%S")
cat ./public_html/data/diff.csv | grep $(date +%Y%m%d) > /dev/null

if [ $? -eq 0 ]
  then
    echo ": diff.sh [skip]"
  else
    if [ $(date +%H) -eq 19 ]
      then
        echo ": diff.sh [run]"
      else
        echo ": diff.sh [failover]"
    fi

    ./diff.sh

    echo -n $(date "+%Y-%m-%d %H:%M:%S")
    tail -n 1 public_html/data/diff.csv | grep -E "[0-9]{8},([0-9]+,){47}[0-9]+" > /dev/null

    if [ $? -eq 0 ]
      then
        echo ": diff.sh [ok]"
      else
        echo ": diff.sh [error]"
        echo -e "Subject: diff.sh [error]\n\nChecking of diff.csv failed." | /usr/sbin/exim -odf -i  maintgraph.maintainers@tools.wmflabs.org
    fi
fi
