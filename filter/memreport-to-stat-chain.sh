#!/bin/bash

perl $1/ini-to-csv.pl "$1" < $2 | perl $1/memreport-csv-access-totals.pl
