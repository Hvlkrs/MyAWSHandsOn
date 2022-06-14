# Part 2 - Connecting and Configuring MariaDB Database

# Connect to the MariaDB Server and open MySQL CLI with root user, no password set as default.
mysql -u root

# Show default databases in the MariaDB Server.
SHOW DATABASES;

# Choose a database (mysql db) to work with. ⚠️ Caution: We have chosen mysql db as demo purposes, normally database mysql is used by server itself, it shouldn't be changed or altered by the user.
USE mysql;

# Show tables within the mysql db. We need user table
SHOW TABLES;

# Show users defined in the db server currently. All users are here
SELECT Host, User, Password FROM user;
# My output: 
 localhost                    | root |          |
| ip-172-31-91-21.ec2.internal | root |          |
| 127.0.0.1                    | root |          |
| ::1                          | root |          |
| localhost                    |      |          |
| ip-172-31-91-21.ec2.internal


#Close the mysql terminal.
EXIT;

# Setup secure installation of MariaDB.
# No root password for root so 'Enter' for first question,
# Then set root password: 'root1234' and yes 'y' to all remaining ones.
sudo mysql_secure_installation
#My answers:(Enter, y, password:root1234, y, root remotely:y, remove test db:y, reload privilege tables: y)

# Show that you can not log into mysql terminal without password anymore.
mysql -u root
#I could not enter because I selected enter with password

#Firstly we entered as root user, then we create a password and exit. Secondly we entered root user and with password.
#Connect to the MariaDB Server and open MySQL CLI with root user and password (pw:root1234).
mysql -u root -p
#Enter password: root1234

# Show that test db is gone.
SHOW DATABASES;

#I have to select an DB
# List the users defined in the server and show that it has now password and its encrypted.
USE mysql;
SELECT Host, User, Password FROM user;

# Create new database named 'clarusdb'.
CREATE DATABASE clarusdb;
# Deleting is with Drop

# Show newly created database.
SHOW DATABASES;
#My output:
| Database           |
+--------------------+
| information_schema |
| clarusdb           |
| mysql              |
| performance_schema 

#Firstly we entered as root user, then we create a password and exit. Secondly we entered root user and with password.
# Create a user named 'clarususer'. Thirdly we will enter as clarususer
CREATE USER clarususer IDENTIFIED BY 'clarus1234';

# Grant permissions to the user clarususer for database clarusdb.
GRANT ALL ON clarusdb.* TO clarususer IDENTIFIED BY 'clarus1234' WITH GRANT OPTION;

# Update privileges.
FLUSH PRIVILEGES;

# Close the mysql terminal.
EXIT;