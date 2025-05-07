#!/bin/bash
echo ""
echo ""
qstat -u mariana | awk 'NR>5 {printf "%-10s %-5s %-15s %-2s %-11s\n", $1, $3, $4, $10, $11}' | sed 's/.diracgw//'
echo ""
echo ""
