# Part 4 - Creating a Client Instance and Connecting to MariaDB Server Instance Remotely

# Launch EC2 Instance (Ubuntu 20.04) and name it as MariaDB-Client on Ubuntu.

# AMI: Ubuntu 20.04
# Instance Type: t2.micro
# Security Group
#   - SSH           -----> 22    -----> Anywhere

# Connect to EC2 instance with SSH. Important not with ec2-user@....
# My connection is ssh -i "PrivatePirate.cer" ubuntu@ec2-3-92-182-228.compute-1.amazonaws.com
# Update instance.
sudo apt update && sudo apt upgrade -y

# Install the mariadb-client.
sudo apt-get install mariadb-client -y

# Connect the clarusdb on MariaDB Server on the other EC2 instance (pw:clarus1234).
mysql -h ec2-3-94-163-77.compute-1.amazonaws.com -u clarususer -p
#mysql -h (HERE IS FROM FIRST INSTANCE'S Public IPv4 DNS) -u clarususer -p
#mysql -h ec2-54-157-8-231.compute-1.amazonaws.com -u clarususer -p


# Show that clarususer can do same db operations on MariaDB Server instance.
SHOW DATABASES;
#My output:
+--------------------+
| Database           |
+--------------------+
| information_schema |
| clarusdb           |
+--------------------+

USE clarusdb;
SHOW TABLES;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT first_name, last_name, salary, city, state FROM employees INNER JOIN offices ON employees.office_id=offices.office_id WHERE employees.salary > 100000;

#My output:
+------------+-----------+--------+---------------+-------+
| first_name | last_name | salary | city          | state |
+------------+-----------+--------+---------------+-------+
| Keriann    | Alloisi   | 110150 | Cincinnati    | OH    |
| North      | de Clerc  | 114257 | New York City | NY    |
| Guthrey    | Iacopetti | 117690 | Richmond      | VA    |
| Mirilla    | Janowski  | 119241 | Richmond      | VA    |
+------------+-----------+--------+---------------+-------+

# make soem changes and observe from the server. Client sent deletion message to server, server deleted.
DELETE FROM employees WHERE salary > 60000;

#We can control it on server(linux) there is no one have salary more than 60000
SELECT *FROM employees;
#If connection down; mysql -u clarususer -p --> USE clarusdb; --> SELECT *FROM employees;

#It shows all connections
SHOW processlist;
#My output:
-----+---------+------+-------+------------------+----------+
| Id  | User       | Host                               | db       | Command | Time | State | Info             | Progress |
+-----+------------+------------------------------------+----------+---------+------+-------+------------------+----------+
| 325 | clarususer | ip-172-31-82-20.ec2.internal:55578 | clarusdb | Query   |    0 | NULL  | show processlist |    0.000 |
| 326 | clarususer | localhost                          | clarusdb | Sleep   |  164 |       | NULL             |    0.000 |
+-----+------------+------------------------------------+----------+---------+------+-------+------------------+----------+



# Close the mysql terminal.
EXIT;

#Backup is possible!

# DO NOT FORGET TO TERMINATE THE INSTANCES YOU CREATED!!!!!!!!!!

Ref: https://mariadb.org/documentation/