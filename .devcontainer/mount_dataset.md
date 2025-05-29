# Run on Docker Host

```bash
mkdir -p /NAS
export NAS_ADDRESS=$(getent hosts NAS01.local | awk '{ print $1 }')
sudo mount -t cifs -o username=viridis,vers=2.0 "//${NAS_ADDRESS}/My Drive" /NAS
```