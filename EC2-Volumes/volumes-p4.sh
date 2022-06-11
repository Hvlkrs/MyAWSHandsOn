# PART 4 - AUTOMOUNT EBS VOLUMES AND PARTITIONS ON REBOOT


# Back up the /etc/fstab file.
#1- back up
sudo cp /etc/fstab /etc/fstab.bak
# Open /etc/fstab file and add the following info to the existing.(UUID's can also be used)
#2-
sudo nano /etc/fstab  # sudo vim /etc/fstab   >>> for vim

/dev/xvdf       /mnt/2nd-vol        ext4    defaults,nofail        0       0
/dev/xvdg1      /mnt/3rd-vol-part1   ext4   defaults,nofail        0       0
/dev/xvdg2      /mnt/3rd-vol-part2   ext4   defaults,nofail        0       0

# more info for fstab >> https://wiki.debian.org/fstab
# Reboot and show that configuration exists (NOTE)
sudo reboot now 
#3- sudo reboot now OR sudo mount -a
# List volumes to show current status, all volumes and partittions should be listed
#4-
lsblk
# Show the used and available capacities related with volumes and partitions
#5-
df -h
#6- Check if the data still persists.
ls -lh /mnt/2nd-vol/
ls -lh /mnt/3rd-vol-part2/

#7-Go to console--> volumes-->select volume-->actions-->detach
# !We can not detach root volume.
#8- Delete volumes on console, except root volume
#9- Terminate instance on console
#10- Go to root volume and we can see root volume gone after termination of instance

# NOTE: You can use "sudo mount -a" to mount volumes and partitions after editing fstab file without rebooting.

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
# https://www.tecmint.com/fdisk-commands-to-manage-linux-disk-partitions/

##################-----DON'T FORGET TO TERMINATE YOUR INSTANCES AND DELETE VOLUMES-----####################