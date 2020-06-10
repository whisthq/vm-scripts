#!/bin/bash

# update Linux scripts
aws s3 cp linux/utils.sh s3://fractal-cloud-setup-s3bucket/utils.sh && \
aws s3 cp linux/creative.sh s3://fractal-cloud-setup-s3bucket/creative.sh && \
aws s3 cp linux/softwaredev.sh s3://fractal-cloud-setup-s3bucket/softwaredev.sh && \
aws s3 cp linux/engineering.sh s3://fractal-cloud-setup-s3bucket/engineering.sh && \
aws s3 cp linux/productivity.sh s3://fractal-cloud-setup-s3bucket/productivity.sh && \
aws s3 cp linux/datascience.sh s3://fractal-cloud-setup-s3bucket/datascience.sh && \
aws s3 cp linux/gaming.sh s3://fractal-cloud-setup-s3bucket/gaming.sh && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Linux Setup-Scripts Updated in AWS S3\", \"icon_emoji\": \":fractal:\"}" https://hooks.slack.com/services/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

# update Windows scripts
aws s3 cp windows/utils.psm1 s3://fractal-cloud-setup-s3bucket/utils.psm1 && \
aws s3 cp windows/creative.ps1 s3://fractal-cloud-setup-s3bucket/creative.ps1 && \
aws s3 cp windows/softwaredev.ps1 s3://fractal-cloud-setup-s3bucket/softwaredev.ps1 && \
aws s3 cp windows/engineering.ps1 s3://fractal-cloud-setup-s3bucket/engineering.ps1 && \
aws s3 cp windows/productivity.ps1 s3://fractal-cloud-setup-s3bucket/productivity.ps1 && \
aws s3 cp windows/datascience.ps1 s3://fractal-cloud-setup-s3bucket/datascience.ps1 && \
aws s3 cp windows/gaming.ps1 s3://fractal-cloud-setup-s3bucket/gaming.ps1 && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Windows Setup-Scripts Updated in AWS S3\", \"icon_emoji\": \":fractal:\"}" https://hooks.slack.com/services/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

# update Linux service
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/FractalServer.sh && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Linux Service Updated in AWS S3\", \"icon_emoji\": \":fractal:\"}" https://hooks.slack.com/services/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
