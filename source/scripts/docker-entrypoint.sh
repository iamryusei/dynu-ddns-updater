#!/bin/sh
echo "Dynu DDNS Updater - Verifying configuration..." \

# Validate $CROND_INTERVAL_MINUTES...
export CROND_INTERVAL_MINUTES="${CROND_INTERVAL_MINUTES:=10}"
if ! echo "$CROND_INTERVAL_MINUTES" | grep -qE '^[1-9][0-9]{0,2}$'; then
  echo "Dynu DDNS Updater - Error: optional environment variable \$CROND_INTERVAL_MINUTES was set to an invalid value (must be a number between 1 and 999)" >&2
  exit 1
fi
# Validate $CROND_LOG_LEVEL...
export CROND_LOG_LEVEL="${CROND_LOG_LEVEL:=8}"
if ! echo "$CROND_LOG_LEVEL" | grep -qE '^[0-8]$'; then
  echo "Dynu DDNS Updater - Error: optional environment variable \$CROND_LOG_LEVEL was set to an invalid value (must be a number between 0 and 8)" >&2
  exit 1
fi

# Validate $DYNU_DDNS_GROUP...
if [ -n "$DYNU_DDNS_GROUP" ] ; then
	if ! echo "$DYNU_DDNS_GROUP" | grep -qE '^[a-zA-Z0-9]{1,50}$'; then
		echo "Dynu DDNS Updater - Error: optional environment variable \$DYNU_DDNS_GROUP was set to an invalid value (must be a valid group string)" >&2
		exit 1
	else
		DYNU_UPDATE_QUERY_STRING=$DYNU_UPDATE_QUERY_STRING"group=${DYNU_DDNS_GROUP}\&"
	fi
fi
# Validate $DYNU_DDNS_HOSTNAME...
if [ -n "$DYNU_DDNS_HOSTNAME" ]; then
	if ! echo "$DYNU_DDNS_HOSTNAME" | grep -qE '^[a-zA-Z0-9.-]+$'; then
		echo "Dynu DDNS Updater - Error: optional environment variable \$DYNU_DDNS_HOSTNAME was set to an invalid value (must be a valid hostname string)" >&2
		exit 1
	else
		DYNU_UPDATE_QUERY_STRING=$DYNU_UPDATE_QUERY_STRING"hostname=${DYNU_DDNS_HOSTNAME}\&"
	fi
fi
# Validate $DYNU_DDNS_ALIAS...
if [ -n "$DYNU_DDNS_ALIAS" ]; then
	if ! echo "$DYNU_DDNS_ALIAS" | grep -qE '^[a-zA-Z0-9.-]+$'; then
		echo "Dynu DDNS Updater - Error: optional environment variable \$DYNU_DDNS_ALIAS was set to an invalid value (must be a valid alias string)" >&2
		exit 1
	else
		DYNU_UPDATE_QUERY_STRING=$DYNU_UPDATE_QUERY_STRING"alias=${DYNU_DDNS_ALIAS}\&"
	fi
fi
# Validate $DYNU_DDNS_IPV4...
if [ -n "$DYNU_DDNS_IPV4" ] ; then
	if ! echo "$DYNU_DDNS_IPV4" | grep -qE '^(no)|(((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])\.?\b){4})$'; then
		echo "Dynu DDNS Updater - Error: optional environment variable \$DYNU_DDNS_IPV4 was set to an invalid value (must be a valid IPv4 address string)" >&2
		exit 1
	else
		DYNU_UPDATE_QUERY_STRING=$DYNU_UPDATE_QUERY_STRING"myip=${DYNU_DDNS_IPV4}\&"
	fi
fi
# Validate $DYNU_DDNS_IPV6...
if [ -n "$DYNU_DDNS_IPV6" ] ; then
	if ! echo "$DYNU_DDNS_IPV6" | grep -qE '^(no)|(([a-fA-F0-9]{0,4}(\.|\:)?)+)$'; then
		echo "Dynu DDNS Updater - Error: optional environment variable \$DYNU_DDNS_IPV6 was set to an invalid value (must be a valid IPv6 address string)" >&2
		exit 1
	else
		DYNU_UPDATE_QUERY_STRING=$DYNU_UPDATE_QUERY_STRING"myipv6=${DYNU_DDNS_IPV6}\&"
	fi
fi
# Validate $DYNU_AUTH_USERNAME...
if [ -n "$DYNU_AUTH_USERNAME" ] ; then
	if ! echo "$DYNU_AUTH_USERNAME" | grep -qE '^([a-zA-Z0-9]{4,20})$'; then
		echo "Dynu DDNS Updater - Error: optional environment variable \$DYNU_AUTH_USERNAME was set to an invalid value (must be a valid username string)" >&2
		exit 1
	else
		DYNU_UPDATE_QUERY_STRING=$DYNU_UPDATE_QUERY_STRING"username=${DYNU_AUTH_USERNAME}\&"
	fi
fi
# Validate $DYNU_AUTH_PASSWORD_SHA256...
if [ -z "$DYNU_AUTH_PASSWORD_SHA256" ]; then
  echo "Dynu DDNS Updater - Error: mandatory environment variable \$DYNU_AUTH_PASSWORD_SHA256 was not set" >&2
  exit 1	
elif ! echo "$DYNU_AUTH_PASSWORD_SHA256" | grep -qE '^[a-fA-F0-9]{64}$'; then
  echo "Dynu DDNS Updater - Error: mandatory environment variable \$DYNU_AUTH_PASSWORD_SHA256 was set to an invalid value (must be a valid SHA256 digest string)" >&2
  exit 1
fi
# Create the query string for the wget HTTP request...
DYNU_UPDATE_QUERY_STRING="?"$DYNU_UPDATE_QUERY_STRING"password=$DYNU_AUTH_PASSWORD_SHA256"
sed -i "s/\$DYNU_UPDATE_QUERY_STRING/$DYNU_UPDATE_QUERY_STRING/g" /home/worker/update-dynu-ddns.sh
sed -i "s/\$CROND_INTERVAL_MINUTES/$CROND_INTERVAL_MINUTES/g" /etc/crontabs/worker
echo -e "Dynu DDNS Updater - Configured successfully!\n\tdns_group...: ${DYNU_DDNS_GROUP:=(none)}\n\tdns_hostname: ${DYNU_DDNS_HOSTNAME:=(all)}\n\tdns_alias...: ${DYNU_DDNS_ALIAS:=(none)}\n\tipv4_addr...: ${DYNU_DDNS_IPV4:=(auto)}\n\tipv6_addr...: ${DYNU_DDNS_IPV6:=(auto)}\n\tinterval....: $CROND_INTERVAL_MINUTES minutes" \

exec "$@"