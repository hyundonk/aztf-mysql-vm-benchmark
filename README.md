# Benchmark test mySQL on Azure VM 

## Currently in preparation... Test environment not yet configured!

Ref) 
https://techcommunity.microsoft.com/t5/azure-database-for-mysql-blog/benchmarking-azure-database-for-mysql-flexible-server-using/ba-p/3108799

### mysql install

```
$ sudo apt install net-tools
$ sudo apt update
$ sudo apt install mysql-server
$ sudo mysql_secure_installation
```

## Add user

```
$ sudo mysql
mysql> CREATE USER 'calvin'@'%' IDENTIFIED BY 'password';
mysql> GRANT PRIVILEGE ON database.table TO 'username'@'host';
```

# Check variables


```
mysql> show variables like 'max_prepared_stmt_count';
+-------------------------+-------+
| Variable_name           | Value |
+-------------------------+-------+
| max_prepared_stmt_count | 16382 |
+-------------------------+-------+
1 row in set (0.01 sec)

mysql> show variables like 'max_connections';
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 151   |
+-----------------+-------+
1 row in set (0.01 sec)
```

# Change bind-address, max_prepared_stmt_count value on mysql server configuration and restart mysql server

```
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address           = 0.0.0.0
max_connections = 350
max_prepared_stmt_count = 655350

$ systemctl stop mysql.service
$ systemctl start mysql.service
```

# Run sysbench command

```
date ; sysbench oltp_write_only.lua  --tables=10 --table-size=1000000 --threads=10 --thread-init-timeout=120 --time=720000 --mysql-host=10.10.1.4 --mysql-db=testdb --mysql-user=calvin --mysql-password='password!' --mysql-port=3306 --report-interval=10 --percentile=95 --mysql-ssl=required prepare ; date

# Install latest sysbench
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash
sudo apt -y install sysbench

## Create a test database for the benchmark
$ mysql -h servername.mysql.database.azure.com -u username -p​
mysql> create database testdb;

$ cd /usr/share/sysbench
$ date ; sysbench oltp_write_only.lua  --tables=10 --table-size=1000000 --threads=10 --time=720000 --mysql-host=10.10.1.4 --mysql-db=testdb --mysql-user=calvin --mysql-password='password!' --mysql-port=3306 --report-interval=1
0 --percentile=95 prepare ; date
Fri Feb 18 08:22:29 UTC 2022
sysbench 1.0.20 (using bundled LuaJIT 2.1.0-beta2)

Initializing worker threads...

Creating table 'sbtest4'...
Creating table 'sbtest6'...
Creating table 'sbtest2'...
Creating table 'sbtest10'...
Creating table 'sbtest7'...
Creating table 'sbtest3'...
Creating table 'sbtest5'...
Creating table 'sbtest8'...
Creating table 'sbtest1'...
Creating table 'sbtest9'...
Inserting 1000000 records into 'sbtest2'
Inserting 1000000 records into 'sbtest3'
Inserting 1000000 records into 'sbtest7'
Inserting 1000000 records into 'sbtest6'
Inserting 1000000 records into 'sbtest4'
Inserting 1000000 records into 'sbtest5'
Inserting 1000000 records into 'sbtest10'
Inserting 1000000 records into 'sbtest8'
Inserting 1000000 records into 'sbtest1'
Inserting 1000000 records into 'sbtest9'


Creating a secondary index on 'sbtest4'...
Creating a secondary index on 'sbtest10'...
Creating a secondary index on 'sbtest7'...
Creating a secondary index on 'sbtest6'...
Creating a secondary index on 'sbtest8'...
Creating a secondary index on 'sbtest3'...
Creating a secondary index on 'sbtest5'...
Creating a secondary index on 'sbtest1'...
Creating a secondary index on 'sbtest9'...
Creating a secondary index on 'sbtest2'...
Fri Feb 18 08:31:44 UTC 2022

## Run performance benchmark test

##  70% read/30% write workload

$ sysbench oltp_read_write.lua --tables=10 --table-size=1000000 --db-driver=mysql --threads=310 --time=360 --mysql-host=10.10.1.4 --mysql-db=testdb --mysql-user=calvin --mysql-password='password!' --mysql-port=3306 --report-interval=1 --percentile=95  run | tee ~/test_read_write.log
[ 1s ] thds: 310 tps: 510.94 qps: 15496.71 (r/w/o: 11394.26/2771.23/1331.23) lat (ms,95%): 733.00 err/s: 0.00 reconn/s: 0.00
[ 2s ] thds: 310 tps: 408.06 qps: 6886.00 (r/w/o: 4880.71/1189.17/816.12) lat (ms,95%): 1280.93 err/s: 0.00 reconn/s: 0.00
...
[ 360s ] thds: 310 tps: 749.23 qps: 14191.26 (r/w/o: 10463.15/2229.65/1498.46) lat (ms,95%): 1069.86 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            3104486
        write:                           886996
        other:                           443498
        total:                           4434980
    transactions:                        221749 (615.51 per sec.)
    queries:                             4434980 (12310.10 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          360.2699s
    total number of events:              221749

Latency (ms):
         min:                                   18.89
         avg:                                  503.49
         max:                                 4927.42
         95th percentile:                     1109.09
         sum:                            111647346.67

Threads fairness:
    events (avg/stddev):           715.3194/18.43
    execution time (avg/stddev):   360.1527/0.05

## read_only workload
sysbench oltp_read_only.lua --tables=10 --table-size=1000000 --db-driver=mysql --threads=310 --time=360 --mysql-host=servername.mysql.database.azure.com --mysql-db=testdb --mysql-user=username --mysql-password='password' --mysql-port=3306 --report-interval=1 --percentile=95 --mysql-ssl=required run | tee ~/test_readOnly.log​


## write_only workload
sysbench oltp_write_only.lua --tables=10 --table-size=1000000 --db-driver=mysql --threads=310 --time=360 --mysql-host=servername.mysql.database.azure.com --mysql-db=testdb --mysql-user=username --mysql-password='password' --mysql-port=3306 --report-interval=1 --percentile=95 --mysql-ssl=required run | tee ~/test_writeOnly.log​
```


