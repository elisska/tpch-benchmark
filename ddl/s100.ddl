DROP TABLE IF EXISTS lineitem;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS nation;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS partsupp;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS supplier;

-- create tables and load data
create external table if not exists part 
(P_PARTKEY INT, 
P_NAME STRING, 
P_MFGR STRING, 
P_BRAND STRING, 
P_TYPE STRING, 
P_SIZE INT, 
P_CONTAINER STRING, 
P_RETAILPRICE DECIMAL(12,4), 
P_COMMENT STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/part';

create external table if not exists supplier 
(S_SUPPKEY INT, 
S_NAME STRING, 
S_ADDRESS STRING, 
S_NATIONKEY INT, 
S_PHONE STRING, 
S_ACCTBAL DECIMAL(12,4), 
S_COMMENT STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/supplier';

create external table IF NOT EXISTS partsupp 
(PS_PARTKEY INT, 
PS_SUPPKEY INT, 
PS_AVAILQTY INT, 
PS_SUPPLYCOST DECIMAL(12,4), 
PS_COMMENT STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/partsupp';

create external table IF NOT EXISTS customer 
(
    C_CUSTKEY INT, C_NAME STRING, C_ADDRESS STRING, C_NATIONKEY INT, C_PHONE STRING, 
    C_ACCTBAL DECIMAL(12,4), 
    C_MKTSEGMENT STRING, C_COMMENT STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/customer';

create external table IF NOT EXISTS orders 
(
    O_ORDERKEY INT, O_CUSTKEY INT, O_ORDERSTATUS STRING, 
    O_TOTALPRICE DECIMAL(12,4), 
    O_ORDERDATE TIMESTAMP, 
    O_ORDERPRIORITY STRING, O_CLERK STRING, O_SHIPPRIORITY INT, 
    O_COMMENT STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/orders';

Create external table IF NOT EXISTS lineitem 
(
    L_ORDERKEY INT, 
    L_PARTKEY INT, 
    L_SUPPKEY INT, 
    L_LINENUMBER INT, 
    L_QUANTITY DECIMAL(12,4), 
    L_EXTENDEDPRICE DECIMAL(12,4), 
    L_DISCOUNT DECIMAL(12,4), 
    L_TAX DECIMAL(12,4), 
    L_RETURNFLAG STRING, 
    L_LINESTATUS STRING, 
    L_SHIPDATE TIMESTAMP, 
    L_COMMITDATE TIMESTAMP, 
    L_RECEIPTDATE TIMESTAMP, 
    L_SHIPINSTRUCT STRING, 
    L_SHIPMODE STRING, 
    L_COMMENT STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/lineitem';

create external table IF NOT EXISTS nation 
(
    N_NATIONKEY INT, N_NAME STRING, N_REGIONKEY INT, N_COMMENT STRING
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/nation';

create external table IF NOT EXISTS region 
(R_REGIONKEY INT, R_NAME STRING, R_COMMENT STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' 
STORED AS TEXTFILE LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/region';
