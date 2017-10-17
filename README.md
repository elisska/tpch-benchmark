# tpch-benchmark

This repository contains scripts to setup tables for TPC-H benchmark as well as queries to run on data. 

# How to run TPC-H on Impala:

Setup tables:

`impala-shell -i <impala-daemon-address> -f ddl/s100/s100.ddl`

Run queries in Impala:

`nohup impala-shell -i <impala-daemon-address> -f queries/tpch-impala.sql > s100.result &`

# How to run TPC-H on Presto:

Setup tables in Hive (yes, you need to setup Hive tables first!!!):

`hive -f ddl/s100/s100.ddl.string`

Why DDl with string? Because if a column defined with TIMESTAMP data type, Presto does not treats it as timestamp but shows NULL instead. So need to specify STRING data type for timestamp columns and then perform in-query conversions to timestamp. 

Lof in to Presto command line interface:

`./presto --server <coordinator_ip> --catalog hive --schema default`

Run queries in the opened shell.
