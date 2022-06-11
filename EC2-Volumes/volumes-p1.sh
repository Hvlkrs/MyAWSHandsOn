# PART 1 - EXTEND ROOT VOLUME

# 1-Launch an Amazon Linux 2 instance with default ebs volume and ssh to it.
# 2-Connect with instance
# List block devices (lsblk) and file system disk space usage (df) of the instance. 
# Only root volume should be listed with the default capacity.

# 3-
lsblk
df -h
# My output:
# xvda    202:0    0   8G  0 disk
# └─xvda1 202:1    0   8G  0 part /
# [ec2-user@ip-172-31-36-238 ~]$ df -h
# Filesystem      Size  Used Avail Use% Mounted on
# devtmpfs        474M     0  474M   0% /dev
# tmpfs           483M     0  483M   0% /dev/shm
# tmpfs           483M  404K  482M   1% /run
# tmpfs           483M     0  483M   0% /sys/fs/cgroup
# /dev/xvda1      8.0G  1.6G  6.5G  20% /
# tmpfs            97M     0   97M   0% /run/user/1000
# Check file system of the root volume's partition.

#4-
sudo file -s /dev/xvda1
# My output: (I saw my file system is XFS)
# /dev/xvda1: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)
# 5-Go to Volumes, select instance's root volume and modify it (increase capacity 8 GB >> 12 GB).
# List block devices (lsblk) and file system disk space usage (df) of the instance again.
# Root volume should be listed as increased but partition and file system should be listed same as before.

#6-
lsblk
# My output: (Root volume increased, but partition did not. So i still can use 8GB)
# xvda    202:0    0  12G  0 disk
# └─xvda1 202:1    0   8G  0 part /
#7- 
df -h


#8-
# Extend partition 1 on the modified volume and occupy all newly avaiable space.
sudo growpart /dev/xvda 1
# My output: 
# [ec2-user@ip-172-31-36-238 ~]$ sudo growpart /dev/xvda 1
# CHANGED: partition=1 start=4096 old: size=16773087 end=16777183 new: size=25161695 end=25165791
# [ec2-user@ip-172-31-36-238 ~]$ lsblk
# NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
# xvda    202:0    0  12G  0 disk
# └─xvda1 202:1    0  12G  0 part /
# [ec2-user@ip-172-31-36-238 ~]$
# Now Partition is 12gb but file system still not use it we have to increase it too

#9-
# Resize the xfs file system on the extended partition to cover all available space.
sudo xfs_growfs /dev/xvda1
# List block devices (lsblk) and file system disk space usage (df) of the instance again.
# Partition and file system should be extended.
lsblk
df -h
# My output: 
# [ec2-user@ip-172-31-36-238 ~]$ sudo xfs_growfs /dev/xvda1
# [ec2-user@ip-172-31-36-238 ~]$ df -h
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/xvda1       12G  1.6G   11G  13% /

