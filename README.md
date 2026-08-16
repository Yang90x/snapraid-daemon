### Docker Compose
```
version: '3.8'
services:
  caddy:
    image: ghcr.io/yang90x/snapraid-daemon:latest
    container_name: snapraid
    restart: unless-stopped
    privileged: true
    volumes:
      - /mnt/diskp:/mnt/diskp
      - /mnt/disk1:/mnt/disk1
      - /mnt/disk2:/mnt/disk2
      - ./snapraid.conf:/etc/snapraid.conf
      - ./snapraidd.conf:/etc/snapraidd.conf
    ports:
      - 7627:7627
```
