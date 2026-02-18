#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

# Mount points
DOCKER_MOUNT="/mnt/foxnas-docker"
NVME_MOUNT="/mnt/foxnas-nvme"

# Mount NFS shares
info "Checking NFS mounts..."

# Check if already mounted, if not create mount point and mount
if mountpoint -q "$DOCKER_MOUNT"; then
  info "$DOCKER_MOUNT already mounted"
else
  info "Creating mount point and mounting $DOCKER_MOUNT..."
  sudo mkdir -p "$DOCKER_MOUNT"
  sudo mount -t nfs foxnas-v2.local:/volume3/docker "$DOCKER_MOUNT"
  info "Mounted foxnas-v2.local:/volume3/docker to $DOCKER_MOUNT"
fi

if mountpoint -q "$NVME_MOUNT"; then
  info "$NVME_MOUNT already mounted"
else
  info "Creating mount point and mounting $NVME_MOUNT..."
  sudo mkdir -p "$NVME_MOUNT"
  sudo mount -t nfs foxnas-v2.local:/volume3/nvme "$NVME_MOUNT"
  info "Mounted foxnas-v2.local:/volume3/nvme to $NVME_MOUNT"
fi

# Sync functions
sync_calibre() {
  info "Syncing Calibre..."
  rsync -av --delete --exclude='.caltrash/' "$NVME_MOUNT/ebooks/" /home/masonfox/Calibre/prod-copy/
  info "Calibre sync complete!"
}

sync_tome() {
  info "Syncing Tome..."
  rsync -av --exclude='backups/' --exclude='*.zip' "$DOCKER_MOUNT/tome/nightly/" /home/masonfox/git/tome/data/
  info "Tome sync complete!"
}

# Prompt user for sync choice
echo ""
echo "What would you like to sync?"
echo "1) Calibre"
echo "2) Tome"
echo "3) Both"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
1)
  sync_calibre
  ;;
2)
  sync_tome
  ;;
3)
  info "Syncing both Calibre and Tome..."
  sync_calibre
  sync_tome
  info "All syncs complete!"
  ;;
*)
  error "Invalid choice. Exiting."
  exit 1
  ;;
esac

info "Done!"
