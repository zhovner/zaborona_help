#!/bin/bash
iptables -w -t nat -nL dnsmapltd | awk '{if (NR<3) {next}; sub(/to\:/, "", $6); print $5,$6}'
