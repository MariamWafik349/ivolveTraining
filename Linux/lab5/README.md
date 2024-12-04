# Lab 5: Attach a 15GB disk to your VM, partition it into 5GB, 5GB, 3GB, and 2GB sections. Use the first 5GB partition as a file system, configure the 2GB partition as swap, initialize the second 5GB as a Volume Group (VG) with a Logical Volume (LV), then extend the LV by adding the 3GB partition.
## Overview:
### Disk Partitioning and Logical Volume Management (LVM) in a Virtual Machine
This lab demonstrates attaching a new 15GB disk to a virtual machine, partitioning it into multiple sections, and configuring these partitions for various purposes:

1- A 5GB partition for a file system.
2- A 2GB partition as swap space.
3- A 5GB partition initialized as a Volume Group (VG) with a Logical Volume (LV).
4- Extending the LV by adding a 3GB partition.
This provides hands-on experience with disk management, partitioning, and using LVM for scalable storage.
## Step-by-Step Guide
### Step 1: Attach the 15GB Disk
#### 1- Attach the disk to your VM using your virtualization platform (e.g., VirtualBox, VMware, AWS, etc.). Ensure the disk is recognized as a secondary disk (e.g., /dev/sdb).
#### 2-Confirm the disk is attached:
```
lsblk
```
### Step 2: Partition the Disk
#### 1- Open the disk for partitioning:
```
sudo fdisk /dev/sdb
```
#### 2-Create partitions:

- Enter n to create new partitions.
- For each partition, specify the size:
 - Partition 1: 5GB
 - Partition 2: 5GB
 - Partition 3: 3GB
 - Partition 4: 2GB
- Save and exit by typing w.
#### 3- Verify the partitions:
lsblk
### Step 3: Format and Configure Partitions
#### 1- Format the first 5GB partition as a file system:
```
sudo mkfs.ext4 /dev/sdb1
```
#### 2- Configure the 2GB partition as swap:
```
sudo mkswap /dev/sdb4
sudo swapon /dev/sdb4
```
#### 3- Verify swap:
```
free -h
```
### Step 4: Configure LVM
#### 1- Initialize the second 5GB partition as a physical volume:
```
sudo pvcreate /dev/sdb2
```
#### 2- Create a Volume Group (VG) using the 5GB partition:
```
sudo vgcreate my_vg /dev/sdb2
```
#### 3- Create a Logical Volume (LV) of 4GB within the VG:
```
sudo lvcreate -L 4G -n my_lv my_vg
```
#### 4- Format and mount the Logical Volume:
```
sudo mkfs.ext4 /dev/my_vg/my_lv
sudo mkdir /mnt/lv_mount
sudo mount /dev/my_vg/my_lv /mnt/lv_mount
```
#### 5- Verify:
```
df -h
```
### Step 5: Extend the Logical Volume
#### 1- Initialize the 3GB partition as a physical volume:
```
sudo pvcreate /dev/sdb3
```
#### 2- Add the 3GB partition to the Volume Group:
```
sudo vgextend my_vg /dev/sdb3
```
#### 3- Extend the Logical Volume by 3GB:
```
sudo lvextend -L +3G /dev/my_vg/my_lv
```
#### 4- Resize the file system to use the added space:
```
sudo resize2fs /dev/my_vg/my_lv
```
#### 5- Verify:
```
df -h
```
### Step 6: Add Persistent Mounts
#### 1- Add the new file systems and swap to /etc/fstab:
```
sudo nano /etc/fstab
```
- Add entries:
```
/dev/sdb1       /mnt/sdb1   ext4    defaults        0 0
/dev/my_vg/my_lv /mnt/lv_mount ext4 defaults        0 0
/dev/sdb4       swap        swap    defaults        0 0
```
#### 2- Test:
```
sudo mount -a
```
# Outcome
- A 5GB partition (/dev/sdb1) is formatted and mounted.
- A 2GB partition (/dev/sdb4) is configured as swap.
- A Logical Volume (my_lv) is created from a 5GB partition, extended by 3GB, and mounted.
This setup showcases practical skills for disk management and storage scaling using LVM.
# 🙏 Thank You
Thank you for using this script. Your feedback and support mean a lot to us!

