create external table customer_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/customer_parquet/'
as select * from customer;

create external table lineitem_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/lineitem_parquet/'
as select * from lineitem;

create external table nation_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/nation_parquet/'
as select * from nation;

create external table orders_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/orders_parquet/'
as select * from orders;

create external table part_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/part_parquet/'
as select * from part;

create external table partsupp_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/partsupp_parquet/'
as select * from partsupp;

create external table region_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/region_parquet/'
as select * from region;

create external table supplier_parquet
STORED AS PARQUET 
LOCATION 's3a://mckp-data-test/tcph-benchmark/s100/supplier_parquet/'
as select * from supplier;
