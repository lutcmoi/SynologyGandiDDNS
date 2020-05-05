# Synology Cloudflare DDNS Script 📜

These are scripts to be used to add [Cloudflare](https://www.cloudflare.com/) and [Gandi](https://www.gandi.net) as a DDNS to [Synology](https://www.synology.com/) NAS. The script used an updated API, Cloudflare API v4. And Gandi v5 API for LiveDNS.

## How to use

### Access Synology via SSH

1. Login to your DSM
2. Go to Control Panel > Terminal & SNMP > Enable SSH service
3. Use your client to access Synology via SSH.
4. Use your Synology admin account to connect.

### Run commands in Synology
This applies for both scrips

1. Download `cloudflareddns.sh` from this repository to `/sbin/cloudflareddns.sh`

```
wget https://raw.githubusercontent.com/lutcmoi/SynologyGandiDDNS/master/cloudflareddns.sh -O /sbin/cloudflareddns.sh
```

It is not a must, you can put I whatever you want. If you put the script in other name or path, make sure you use the right path.

2. Give others execute permission

```
chmod +x /sbin/cloudflareddns.sh
```

3. Add `cloudflareddns.sh` to Synology

```
cat >> /etc.defaults/ddns_provider.conf << 'EOF'
[Cloudflare]
        modulepath=/sbin/cloudflareddns.sh
        queryurl=https://www.cloudflare.com
        website=https://www.cloudflare.com
E*.
```

`queryurl` does not matter because we are going to use our script but it is needed.

### Get Cloudflare parameters

1. Go to your domain overview page and copy your zone ID.
2. Go to your profile > **API Tokens** > **Create Token**. It should have the permissions of `Zone > DNS > Edit`. Copy the api token.

### Setup DDNS

1. Login to your DSM
2. Go to Control Panel > External Access > DDNS > Add
3. Enter the following:
   - Service provider: `Cloudflare`
   - Hostname: `www.example.com`
   - Username/Email: `<Zone ID>`
   - Password Key: `<API Token>`
