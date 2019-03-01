printf "\nWhat is the IP address or Name of the Domain or SMS you want to check?\n"
read DOMAIN

printf "\nListing Global Policy Names\n"
mgmt_cli -r true -d $DOMAIN show access-layers limit 500 --format json | jq --raw-output '."access-layers"[] | select(.domain."domain-type" == "global domain") | .name'

printf "\nWhich Global Policy is being used?\n"
read GPOLICY

GLOBAL=$(mgmt_cli -r true -d $DOMAIN show access-rulebase name "$GPOLICY" details-level full --format json |jq --raw-output '.rulebase[] | select(.type == "place-holder") | ."rule-number"')

printf "\nListing Local Domain  Policy Names\n"
mgmt_cli -r true -d $DOMAIN show access-layers limit 500 --format json |jq --raw-output '."access-layers"[] | select(.domain."domain-type" == "domain") | .name'

printf "\nWhich Domain Policy do you want to modify?\n"
read DPOLICY

mgmt_cli -r true -d $DOMAIN show access-rulebase name "$DPOLICY" details-level full --format json | jq --raw-output --arg GLOBAL "$GLOBAL"  '.rulebase[] | ."rule-number" = $GLOBAL + "." + (."rule-number"|tostring)' > $DPOLICY-modified.json

printf "\nYou can view the modified rule base in $DPOLICY-modified.json\n"
