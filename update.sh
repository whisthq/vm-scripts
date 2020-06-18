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

# update Linux service on all branches
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/dev/Linux/FractalServer.sh && \
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/staging/Linux/FractalServer.sh && \
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/master/Linux/FractalServer.sh && \
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/dev/Linux/fractal.service && \
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/staging/Linux/fractal.service && \
aws s3 cp linux/FractalServer.sh s3://fractal-cloud-setup-s3bucket/master/Linux/fractal.service && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Linux Service Updated in AWS S3\", \"icon_emoji\": \":fractal:\"}" https://hooks.slack.com/services/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

# update Linux configuration
aws s3 cp linux/custom.conf s3://fractal-cloud-setup-s3bucket/custom.conf && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Linux custom.conf Updated in AWS S3\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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

# update Windows Auto-update scripts on all branches
aws s3 cp windows/dev/update.bat s3://fractal-cloud-setup-s3bucket/dev/Windows/update.bat && \
aws s3 cp windows/staging/update.bat s3://fractal-cloud-setup-s3bucket/staging/Windows/update.bat && \
aws s3 cp windows/master/update.bat s3://fractal-cloud-setup-s3bucket/master/Windows/update.bat && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Windows Auto-Update Scripts Updated in AWS S3\", \"icon_emoji\": \":fractal:\"}" https://hooks.slack.com/services/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

# update Linux Auto-update scripts on all branches
aws s3 cp linux/dev/update.sh s3://fractal-cloud-setup-s3bucket/dev/Linux/update.sh && \
aws s3 cp linux/staging/update.sh s3://fractal-cloud-setup-s3bucket/staging/Linux/update.sh && \
aws s3 cp linux/master/update.sh s3://fractal-cloud-setup-s3bucket/master/Linux/update.sh && \
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"fractal-bot\", \"text\": \"Linux Auto-Update Scripts Updated in AWS S3\", \"icon_emoji\": \":fractal:\"}" https://hooks.slack.com/services/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
