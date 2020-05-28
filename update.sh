#!/bin/bash

aws s3 cp linux/utils.sh s3://arn:aws:s3:us-east-1:747391415460:accesspoint/fractal-cloud-setup/utils.sh

curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"setup-scripts utils.sh updated in AWS S3\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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

