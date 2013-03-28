#!/bin/bash

perl $1/memreport-to-csv.pl < $2 | $1/memreport-csv-column-sort.sh | $1/memreport-csv-trim-extra-columns.sh | perl $1/memreport-csv-access-totals.pl
