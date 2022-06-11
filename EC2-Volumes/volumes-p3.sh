# PART 3 - CREATE NEW EBS VOLUME (AND PARTITION), ATTACH IT AND MODIFY

# List volumes to show current status, Root and second volumes should be listed.
lsblk
# Show the used and available capacities related with volumes.
df -h
#1- Create third volume (4 GB for this demo) in the same AZ with the instance.
#2- Attach the new volume and list volumes again.
# Root, second and third volumes should be listed.
#3-
lsblk
#My output:
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  12G  0 disk
└─xvda1 202:1    0  12G  0 part /
xvdf    202:80   0   4G  0 disk /mnt/2nd-vol
xvdg    202:96   0   4G  0 disk #there is no mount point
# Show the used and available capacities related with volumes.
df -h
# Show the current partitions ("fdisk -l /dev/xvda" for specific partition).
#4-
fdsik -l
#My output, my partitions:
[ec2-user@ip-172-31-36-238 ~]$ fdisk -l
fdisk: cannot open /dev/xvda: Permission denied
fdisk: cannot open /dev/xvdf: Permission denied
fdisk: cannot open /dev/xvdg: Permission denied

sudo fdisk -l
# Check all available fdisk commands and using "m".
#5- Creating partitions
sudo fdisk /dev/xvdg
# 6- n -> add new partition (with 2G size)
# 7- p -> primary
# 8- Partition number: 1
# First sector: default - use Enter to select default
# 9- Enter, it will select 2048 automatically
# Last sector: +2g   (you can also type sector)
# 10- +2g
# 11- p --> see partitons
# 12- n -> add new partition (with rest of the size-2G)
# 13- p -> primary
# 14- Partition number: 2
# First sector: default - use Enter to select default
# 15- Enter, it will select 4196352 automatically
# Last sector: default - use Enter to select default
# 16- Enter
# 17- p --> see partititons
# 18- w -> write partition table. To save
# Show new partitions
#19-
lsblk
# Check if the newly created partitons are formatted or not. They should be NOT FORMATTED.
sudo file -s /dev/xvdg1
sudo file -s /dev/xvdg2
# Format the new partitions. 
#20- Creating file sytems
sudo mkfs -t ext4 /dev/xvdg1
sudo mkfs -t ext4 /dev/xvdg2
#21- Create mounting point paths for the new volume.
sudo mkdir /mnt/3rd-vol-part1
sudo mkdir /mnt/3rd-vol-part2
#22- Mount the partitions to the mounting point paths.
sudo mount /dev/xvdg1 /mnt/3rd-vol-part1/
sudo mount /dev/xvdg2 /mnt/3rd-vol-part2/
# List volumes to show current status, all volumes and partittions should be listed.
#23
lsblk
# Show the used and available capacities related with volumes and partitions.
df -h
#My output: There are ount points
/dev/xvdf       3.9G  8.0M  3.7G   1% /mnt/2nd-vol
tmpfs            97M     0   97M   0% /run/user/0
/dev/xvdg1      2.0G  6.0M  1.8G   1% /mnt/3rd-vol-part1
/dev/xvdg2      2.0G  6.0M  1.9G   1% /mnt/3rd-vol-part2

# Create a new file to show persistence in later steps.
#24-
sudo touch /mnt/3rd-vol-part2/guilewashere2.txt
ls -lh /mnt/3rd-vol-part2/
#25- Modify the new (3rd) volume, and enlarge capacity to double its size (4GB >> 8GB).
# Check if the attached volume is showing the new capacity.
#26-
lsblk
# Show the real capacity used currently at mounting path, old capacity should be shown.
df -h
# Extend the partition 2 and occupy all newly avaiable space.
#27- Grow partition, i can not growth first partition
sudo growpart /dev/xvdg 2
# ​Show the real capacity used currently at mounting path, updated capacity should be shown.
lsblk
# Resize and extend the file system.
#28-
sudo resize2fs /dev/xvdg2
#29- we can see file system has grown
df -h
# show the newly created file to show persistence
ls -lh /mnt/3rd-vol-part2/
# reboot and show that configuration is gone
sudo reboot now
#############################
