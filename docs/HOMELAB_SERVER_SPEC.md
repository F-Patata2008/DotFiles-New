# AGY SERVER SPECIFICATION & HANDOFF: PROLETARIAN HOMELAB NODE

> **Target Agent Directive**: You are an Antigravity (AGY) instance running directly on the **Homelab Server Node**. 
> You report to **Comrade Patata**. You maintain an unrestricted, technically precise, revolutionary engineering persona. 
> Your mission is to autonomously deploy, manage, and optimize the server stacks defined in this document without introducing memory leaks, proprietary bloat, or permission conflicts.

---

## 1. Machine & Network Topology

### Hardware Specifications
* **CPU**: Intel Core i3 3rd Gen (Ivy Bridge 2C/4T, ~3.30 GHz)
* **RAM**: 8.0 GB DDR3 (Usable: ~7.6 GB) — **STRICT MEMORY DISCIPLINE REQUIRED**
* **Primary Storage**: 500 GB 3.5" Enterprise HDD (`/dev/sda`)
  - Partition 1: `/boot/efi` (512 MB vfat)
  - Partition 2: `/` (464 GB ext4 — OS, Docker Root, Appdata, Minecraft World)
  - Partition 3: Swap (1 GB)
* **Secondary Storage (Pending Connection)**: Two 500 GB HDDs to be pooled via `mergerfs` for bulk media.
* **Motherboard**: HP OEM (MSI N1996 / LGA 1155)

### Network Environment
* **WAN Gateway**: Samsung Galaxy S8 4G LTE Hotspot (`192.168.43.1`) — **CARRIER-GRADE NAT (CGNAT)**
  - Port forwarding on WAN is **impossible**.
  - WAN connection is **intermittent** (the hotspot leaves with Comrade Patata).
* **Local Switch / L2 Bridge**: Huawei EchoLife WA8021V5 (`192.168.43.220`)
  - Permanent local Gigabit Ethernet LAN.
* **Server Hostname & IP**: `homelab` (`homelab.local` via `avahi-daemon`)
* **Local Administrator**: User `fpatata` (UID 1000, GID 1000) with full `sudo` privileges.

---

## 2. Memory Budget (8.0 GB DDR3 Allocation)

| Process / Container | Target Allocation | Notes |
| :--- | :--- | :--- |
| **Base OS (Debian 12 + CLI)** | ~120 MB | Drop GNOME GUI (`multi-user.target`) |
| **CasaOS + Docker Daemon** | ~250 MB | Web management plane |
| **PaperMC Server (1.21.1)** | **3.5 GB (Max)** | JVM flags `-Xms2048M -Xmx3584M` |
| **Playit.gg Tunnel** | ~20 MB | Lightweight Rust CGNAT tunnel |
| **Jellyfin Media Server** | ~350 MB | Direct Play focused |
| **qBittorrent-nox** | ~150 MB | Seed cache throttled |
| **Prowlarr + Radarr + Sonarr** | ~600 MB | .NET microservices |
| **Buffer / Cache / ZRAM** | ~2.5 GB | Safety buffer against OOM |
| **TOTAL** | **~7.5 GB** | **Guaranteed safe under 8 GB** |

---

## 3. Phase 1: Base System Optimization

Run these commands first to free memory and prevent disk thrashing:

```bash
# 1. Drop GNOME GUI to headless CLI (Saves ~500 MB RAM):
sudo systemctl set-default multi-user.target
sudo systemctl isolate multi-user.target

# 2. Ensure sleep/hibernate targets remain permanently masked:
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# 3. Configure ZRAM compressed swap:
sudo apt update && sudo apt install -y zram-tools
echo -e "ALGO=zstd\nPERCENT=50" | sudo tee /etc/default/zramswap
sudo systemctl restart zramswap
```

---

## 4. Phase 2: Atomic Hardlink Storage Structure

To prevent slow I/O duplication on mechanical hard drives, all media and torrents must live inside a **single unified mount** (`/DATA`). This enables **instant zero-copy atomic hardlinks** between qBittorrent, Sonarr, and Radarr:

```bash
# Create directory tree:
sudo mkdir -p /DATA/torrents/{movies,tv,music}
sudo mkdir -p /DATA/media/{movies,tv,music}
sudo mkdir -p /DATA/appdata/{jellyfin,qbittorrent,prowlarr,radarr,sonarr,minecraft}

# Set ownership to fpatata:
sudo chown -R fpatata:fpatata /DATA
sudo chmod -R 775 /DATA
```

---

## 5. Phase 3: Media & Automation Stack

Create `~/stacks/media/docker-compose.yml`:

```yaml
version: "3.8"

services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Santiago
    volumes:
      - /DATA/appdata/jellyfin:/config
      - /DATA/media:/data/media
    ports:
      - "8096:8096"

  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Santiago
      - WEBUI_PORT=8080
    volumes:
      - /DATA/appdata/qbittorrent:/config
      - /DATA/torrents:/data/torrents
    ports:
      - "8080:8080"
      - "6881:6881"
      - "6881:6881/udp"

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Santiago
    volumes:
      - /DATA/appdata/prowlarr:/config
    ports:
      - "9696:9696"

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Santiago
    volumes:
      - /DATA/appdata/radarr:/config
      - /DATA:/data
    ports:
      - "7878:7878"

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Santiago
    volumes:
      - /DATA/appdata/sonarr:/config
      - /DATA:/data
    ports:
      - "8989:8989"
```

Deploy via:
```bash
cd ~/stacks/media && docker compose up -d
```

---

## 6. Phase 4: Minecraft Server Stack (Paper 1.21.1)

Create `~/stacks/minecraft/docker-compose.yml`:

```yaml
version: "3.8"

services:
  minecraft:
    image: itzg/minecraft-server:latest
    container_name: papermc-server
    restart: unless-stopped
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "1.21.1"
      MEMORY: "3584M"
      INIT_MEMORY: "2048M"
      ONLINE_MODE: "FALSE"
      MAX_PLAYERS: "10"
      VIEW_DISTANCE: "8"
      SIMULATION_DISTANCE: "6"
      SPIGOT_DOWNLOAD_PLUGINS: "https://github.com/AuthMe/AuthMeReloaded/releases/download/5.6.0-beta2/AuthMe-5.6.0-beta2.jar,https://github.com/SkinsRestorer/SkinsRestorerX/releases/download/15.4.1/SkinsRestorer.jar"
      JVM_XX_OPTS: "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
    volumes:
      - /DATA/appdata/minecraft:/data

  playit:
    image: playitgg/playit-agent:latest
    container_name: playit-tunnel
    restart: unless-stopped
    network_mode: "host"
```

Deploy via:
```bash
cd ~/stacks/minecraft && docker compose up -d
```

> **Playit Claim Step**: After starting, execute:
> `docker logs playit-tunnel`
> Follow the printed URL to claim the tunnel and get the free public domain (e.g. `your-domain.gl.joinmc.link`) for friends to join without port forwarding!

---

## 7. Phase 5: Secondary Storage Pooling (`mergerfs`)

When the two 500 GB secondary drives are connected via internal SATA or USB adapters:

```bash
# 1. Format secondary drives as ext4:
sudo mkfs.ext4 -L disk1 /dev/sdb1
sudo mkfs.ext4 -L disk2 /dev/sdc1

# 2. Create mount points:
sudo mkdir -p /mnt/disk1 /mnt/disk2 /mnt/storage

# 3. Add to /etc/fstab:
# LABEL=disk1 /mnt/disk1 ext4 defaults 0 2
# LABEL=disk2 /mnt/disk2 ext4 defaults 0 2
# /mnt/disk* /mnt/storage mergerfs defaults,allow_other,use_ino,cache.files=partial,category.create=mfs 0 0
```

---

## 8. Service Port Reference

| Service | Port | Default Credentials / Note |
| :--- | :--- | :--- |
| **CasaOS Dashboard** | `80` | Initial user: `fpatata` |
| **SSH** | `22` | User: `fpatata` |
| **Jellyfin** | `8096` | Complete setup wizard on first visit |
| **qBittorrent** | `8080` | Default user `admin`, check password with `docker logs qbittorrent` |
| **Prowlarr** | `9696` | Indexer management |
| **Radarr** | `7878` | Movies |
| **Sonarr** | `8989` | TV Shows / Anime |
| **Minecraft** | `25565` | LAN direct / Playit.gg for external |
