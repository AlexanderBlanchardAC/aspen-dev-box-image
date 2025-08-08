#!/usr/bin/env bash
#

# This script is used to run the docker container
# cp -R /test.localhostaspen /usr/local/aspen-discovery/sites

service cron start

./usr/local/aspen-discovery/install/setup_aspen_user_debian.sh

mkdir -p /data/aspen-discovery/test.localhostaspen/covers/{small,large,medium,original}

mkdir -p /usr/local/aspen-discovery/tmp/smarty/compile/

mkdir -p /var/log/aspen-discovery/test.localhostaspen

chmod -R a+wr /var/log/

chmod -R a+wr /usr/local/aspen-discovery/

chmod -R a+wr /data/aspen-discovery/test.localhostaspen/

chown -R aspen /data/aspen-discovery/test.localhostaspen/solr7

service apache2 start

curl -k http://localhost/API/SystemAPI?method=runPendingDatabaseUpdates

crontab /etc/cron.d/cron

# --- Selenium IDE Config Setup ---

SELENIUM_DIR="/usr/local/aspen-discovery/tests/e2e/selenium-ide/sites"
SITE_NAME="test.localhostaspen"
SITE_DIR="${SELENIUM_DIR}/${SITE_NAME}"
CONFIG_FILE="${SITE_DIR}/${SITE_NAME}-test-config.json"
TEMPLATE_FILE="${SELENIUM_DIR}/example/example-test-config.json"

rm -f "$CONFIG_FILE"

# Create the config file

echo "Generating Selenium IDE config for $SITE_NAME"
mkdir -p "$SITE_DIR"
cp "$TEMPLATE_FILE" "$CONFIG_FILE"
chmod a+rw "$CONFIG_FILE"


# --- Replace placeholders in the config file ---
sed -i "s/\"siteName\": \"example\"/\"siteName\": \"${SITE_NAME}\"/g" "$CONFIG_FILE"
sed -i "s|\"url\": \"https://example.library.org\"|\"url\": \"http://${SITE_NAME}\"|g" "$CONFIG_FILE"
sed -i "s/\"username\": \"1234567\"/\"username\": \"42\"/g" "$CONFIG_FILE"
sed -i "s/\"password\": \"example_password\"/\"password\": \"koha\"/g" "$CONFIG_FILE"
sed -i "s/\"invalidPassword\": \"wrong_password\"/\"invalidPassword\": \"wrongpass\"/g" "$CONFIG_FILE"

# --- Selenium IDE CONF Config Setup ---

CONF_DIR="${SITE_DIR}/conf"
CONF_CONFIG_FILE="${CONF_DIR}/${SITE_NAME}-test-config.json"
CONF_TEMPLATE_FILE="${SELENIUM_DIR}/example/conf/example-test-config.json"

rm -f "$CONF_CONFIG_FILE"

# Create the conf config file
echo "Generating Selenium IDE conf config for $SITE_NAME"
mkdir -p "$CONF_DIR"
cp "$CONF_TEMPLATE_FILE" "$CONF_CONFIG_FILE"
chmod a+rw "$CONF_CONFIG_FILE"


# --- Replace placeholders in the conf config file ---
sed -i "s/\"siteName\": \"example\"/\"siteName\": \"${SITE_NAME}\"/g" "$CONF_CONFIG_FILE"
sed -i "s|\"url\": \"https://example.library.org\"|\"url\": \"http://${SITE_NAME}\"|g" "$CONF_CONFIG_FILE"
sed -i "s/\"username\": \"1234567\"/\"username\": \"42\"/g" "$CONF_CONFIG_FILE"
sed -i "s/\"password\": \"example_password\"/\"password\": \"koha\"/g" "$CONF_CONFIG_FILE"
sed -i "s/\"invalidPassword\": \"wrong_password\"/\"invalidPassword\": \"wrongpass\"/g" "$CONF_CONFIG_FILE"
sed -i 's/"groupedWorkId": "[^"]*"/"groupedWorkId": "3be4323c-ca84-dc1d-9548-0d119f0fea4f-eng"/g' "$CONF_CONFIG_FILE"
sed -i 's/"bibRecordId": "[^"]*"/"bibRecordId": "180"/g' "$CONF_CONFIG_FILE"


/bin/bash -c "trap : TERM INT; sleep infinity & wait"
