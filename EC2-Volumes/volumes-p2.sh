# PART 2 - CREATE NEW EBS VOLUME, ATTACH IT AND MODIFY

# 1- Create a new volume "in the SAME AZ with the INSTANCE" (2 GB for this demo).
# 2- Attach the new volume to the instance and then list block storages again.
# To attach instance; select volume-->Actions-->Attach, Select instance-->Attach volume

# Root volume and the newly created second volumes should be listed.
#3-
lsblk
df -h
#My output:
xvda    202:0    0  12G  0 disk
└─xvda1 202:1    0  12G  0 part /
xvdf    202:80   0   2G  0 disk
[ec2-user@ip-172-31-36-238 ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       12G  1.6G   11G  13% /
# !We see that we have new volume and attach to instance but file system can not see it


# Check if the attached volume is already formatted or not. It should be NOT FORMATTED.
#4-To control, is there file system or data
sudo file -s /dev/xvdf
# My output:
# /dev/xvdf: data

# Format the new volume.
#5-
sudo mkfs -t ext4 /dev/xvdf
# Check the format of the volume again after formatting.
#6-
sudo file -s /dev/xvdf
#My output:
/dev/xvdf: Linux rev 1.0 ext4 filesystem data, UUID=82c94d1b-2d4f-4f54-9c02-dd61d08a5fd9 (extents) (64bit) (large files) (huge files)
#We see now there is file


# Create a mounting point path for new volume
#7-
sudo mkdir /mnt/2nd-vol
# Mount the new volume to the mounting point path.
#8-
sudo mount /dev/xvdf /mnt/2nd-vol/
# Check if the attached volume is mounted to the mounting point path.
#9-
lsblk
# My output:
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  12G  0 disk
└─xvda1 202:1    0  12G  0 part /
xvdf    202:80   0   2G  0 disk /mnt/2nd-vol
# Show the available space, on the mounting point path.
#10-
df -h
# My output, we can see mounting point
/dev/xvdf       2.0G  6.0M  1.8G   1% /mnt/2nd-vol

# Check if there is data on it or not.
#11-
ls -lh /mnt/2nd-vol/
#My output: we see file
drwx------ 2 root root 16K Jun 10 15:56 lost+found
# Create a new file to show persistence in later steps.
cd /mnt/2nd-vol
sudo touch guilewashere.txt
ls
# 12- Modify the new volume in aws console, and enlarge capacity to double its size (2GB >> 4GB).
# Check if the attached volume shows the new capacity.
lsblk
# Show the real capacity used currently at mounting path, old capacity should be displayed.
df -h
# New volume is 4GB, file system still see 2GB

# Resize the EXT4 file system on the new volume to cover all available space.
#13-
sudo resize2fs /dev/xvdf
# Show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
#14-
df -h
#My output: We see file system is resized
/dev/xvdf       3.9G  8.0M  3.7G   1% /mnt/2nd-vol

# Show that the data still persists on the newly enlarged volume.
ls -lh /mnt/2nd-vol/
# Show that mounting point path is gone when instance reboots.
sudo reboot now
# Show the new volume is still attached, but not mounted.
lsblk
# Check if the attached volume is formatted or not.
#15-
sudo file -s /dev/xvdf
# Mount the new volume to the mounting point path again.
sudo mount /dev/xvdf /mnt/2nd-vol/
# show the used and available capacity is same as the disk size.
#16-
lsblk
df -h
# if there is data on it, check if the data still persists.
ls -lh /mnt/2nd-vol/