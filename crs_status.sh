#!/bin/sh
# Credit to :
# Steve Howard
# http://appcrawler.com/wordpress/2011/04/01/format-output-of-crsctl-status-for-rac-11gr2/
# To modify the CRS_HOME via sed use the following
# export GRID_HOME=/u01/app/19.0.0.0/grid
# sed -i '/^CRS_HOME/ s~CRS_HOME=$~CRS_HOME='${GRID_HOME}'~' ${HOME}/working/crs_status.sh
 
CRS_HOME=
 
$CRS_HOME/bin/crsctl stat res -t \
  | awk -v t="$t" '$0 !~ "Cluster Resources" && $0 !~ "Local Resources" \
      { \
        if ($0 ~ "Name") { \
          printf "%-45s %-10s %-15s %-25s %s %s\n", $1, $2, $3, $4, $5, $6
          while (++k <= 120) { \
            printf("-") \
          } \
          printf ("\n") \
        } \
        if (NF == 1) {\
          rs=$0 \
        } \
        else if (NR != 2) { \
          if ($1 ~ "^[0-9]") { \
            if ($0 ~ "Shutdown" || (rs ~ "svc$" && $3 == "OFFLINE" )) { \
              l = "$CRS_HOME/olsnodes -n"
              cmd[NR] = l
              while (l | getline line) {
                split(line,r," ")
                if (r[2] == $1) {
                  NODE = r[1]
                }
              }
              printf "%-45s %-10s %-15s %-25s %s %s\n", rs, $2, $3, NODE, $4, $5, "", $6, $7 \
            } \
            else { \
              printf "%-45s %-10s %-15s %-25s %s %s\n", rs, $2, $3, $4, $5, $6, $7 \
            } \
          } \
          else { \
            printf "%-45s %-10s %-15s %-25s %s %s\n", rs, $1, $2, $3, $4, $5, $6, $7 \
          } \
        } \
      }'
