#!/bin/bash

test $# -lt 2 && {
  echo "Usage: $0 <bridge> <from_device>";
  exit 1;
}

CONFIG='/etc/sysconfig/network-scripts/ifcfg-'

bridge="$1"
from_device="$2"

# create bridge scaffold
echo -e "DEVICE=$bridge\nTYPE=Bridge" \
> $CONFIG$bridge

# update bridge scaffold with values from $from_device
cat "$CONFIG$from_device" | while read line; do
  echo "$line" | egrep -v 'DEVICE|HWADDR' >> $CONFIG$bridge
done

# link from_device 
echo -e "DEVICE=$from_device\nONBOOT=yes\nBRIDGE=$bridge" \
> $CONFIG$from_device

# update
echo HWADDR=`facter macadress_$from_device` \
>> $CONFIG$from_device
