#!/bin/bash

aws s3 cp linux/utils.sh s3://fractal-cloud-setup-s3bucket/utils.sh && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"setup-scripts utils.sh updated in AWS S3\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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

