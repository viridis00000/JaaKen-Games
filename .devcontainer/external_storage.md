# External Storage Mount Instructions

This document provides instructions for mounting external storage to the Docker host.

## NAS Mount Example

```bash
mkdir -p /NAS
export NAS_ADDRESS=$(getent hosts YOUR_NAS_HOST.local | awk '{ print $1 }')
sudo mount -t cifs -o username=YOUR_USERNAME,vers=2.0 "//${NAS_ADDRESS}/YOUR_SHARE" /NAS
```

Replace `YOUR_NAS_HOST`, `YOUR_USERNAME`, and `YOUR_SHARE` with your actual values.