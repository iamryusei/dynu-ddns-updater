#!/bin/sh
wget -q -O - "https://api.dynu.com/nic/update$DYNU_UPDATE_QUERY_STRING" && echo ""