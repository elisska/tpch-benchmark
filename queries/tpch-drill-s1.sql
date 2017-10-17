--Pricing Summary Report Query (Q1)
SELECT 
  L_RETURNFLAG, L_LINESTATUS, SUM(L_QUANTITY), SUM(L_EXTENDEDPRICE), SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)), SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1+L_TAX)), AVG(L_QUANTITY), AVG(L_EXTENDEDPRICE), AVG(L_DISCOUNT), cast(COUNT(1) as int)
FROM 
  `s3-mckp-data-test`.`tcph-benchmark/s1/lineitem` 
WHERE 
  L_SHIPDATE<='1998-09-02' 
GROUP BY L_RETURNFLAG, L_LINESTATUS 
ORDER BY L_RETURNFLAG, L_LINESTATUS;

-- Minimum Cost Supplier Query (Q2)
select
s_acctbal,
s_name,
n_name,
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key,
p_mfgr,
s_address,
s_phone,
s_comment
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`,
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/part`supp,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
`s3-mckp-data-test`.`tcph-benchmark/s1/region`
where
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = ps_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and s_suppkey = ps_suppkey
and p_size = 15
and p_type like '%BRASS'
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and n_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key = r_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key
and r_name = 'EUROPE'
and ps_supplycost = (
select min(ps_supplycost)
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`supp, `s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`, `s3-mckp-data-test`.`tcph-benchmark/s1/region`
where
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = ps_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and s_suppkey = ps_suppkey
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and n_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key = r_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key
and r_name = 'EUROPE'
)
order by
s_acctbal desc,
n_name,
s_name,
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key;

-- Shipping Priority Query (Q3)
select
l_orderkey,
sum(l_extendedprice*(1-l_discount)) as revenue,
o_orderdate,
o_shippriority
from
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
c_mktsegment = 'BUILDING'
and c_custkey = o_custkey
and l_orderkey = o_orderkey
and o_orderdate < to_date('1995-03-15')
and l_shipdate > to_date('1995-03-15')
group by
l_orderkey,
o_orderdate,
o_shippriority
order by
revenue desc,
o_orderdate;

--Order Priority Checking Query (Q4)
select
o_orderpriority,
count(*) as order_count
from
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`
where
o_orderdate >= cast('1993-07-01' as timestamp)
and o_orderdate < cast('1993-07-01' as timestamp) + interval 3 month
and exists (
select
*
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
l_orderkey = o_orderkey
and l_commitdate < l_receiptdate
)
group by
o_orderpriority
order by
o_orderpriority;

--Local Supplier Volume Query (Q5)
select
n_name,
sum(l_extendedprice * (1 - l_discount)) as revenue
from
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
`s3-mckp-data-test`.`tcph-benchmark/s1/region`
where
c_custkey = o_custkey
and l_orderkey = o_orderkey
and l_suppkey = s_suppkey
and c_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and n_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key = r_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key
and r_name = 'ASIA'
and o_orderdate >= cast('1994-01-01' as timestamp)
and o_orderdate < cast('1994-01-01' as timestamp) + interval 1 year
group by
n_name
order by
revenue desc;

--Forecasting Revenue Change Query (Q6)
select
sum(l_extendedprice*l_discount) as revenue
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
l_shipdate >= cast('1994-01-01' as timestamp)
and l_shipdate < cast('1994-01-01' as timestamp) + interval 1 year
and l_discount between 0.06 - 0.01 and 0.06 + 0.01
and l_quantity < 24;

--Volume Shipping Query (Q7)
select
supp_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
cust_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
l_year, sum(volume) as revenue
from (
select
n1.n_name as supp_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
n2.n_name as cust_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
extract(year from l_shipdate) as l_year,
l_extendedprice * (1 - l_discount) as volume
from
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation` n1,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation` n2
where
s_suppkey = l_suppkey
and o_orderkey = l_orderkey
and c_custkey = o_custkey
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n1.n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and c_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n2.n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and (
(n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY')
or (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE')
)
and l_shipdate between cast('1995-01-01' as timestamp) and cast('1996-12-31' as timestamp)
) as shipping
group by
supp_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
cust_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
l_year
order by
supp_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
cust_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
l_year;

-- National Market Share Query (Q8)
select
o_year,
sum(case
when `s3-mckp-data-test`.`tcph-benchmark/s1/nation` = 'BRAZIL'
then volume
else 0
end) / sum(volume) as mkt_share
from (
select
extract(year from o_orderdate) as o_year,
l_extendedprice * (1-l_discount) as volume,
n2.n_name as `s3-mckp-data-test`.`tcph-benchmark/s1/nation`
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`,
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation` n1,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation` n2,
`s3-mckp-data-test`.`tcph-benchmark/s1/region`
where
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and s_suppkey = l_suppkey
and l_orderkey = o_orderkey
and o_custkey = c_custkey
and c_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n1.n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and n1.n_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key = r_`s3-mckp-data-test`.`tcph-benchmark/s1/region`key
and r_name = 'AMERICA'
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n2.n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and o_orderdate between cast('1995-01-01' as timestamp) and cast('1996-12-31' as timestamp)
and p_type = 'ECONOMY ANODIZED STEEL'
) as all_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`s
group by
o_year
order by
o_year;

--Product Type Profit Measure Query (Q9)
select
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
o_year,
sum(amount) as sum_profit
from (
select
n_name as `s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
extract(year from o_orderdate) as o_year,
l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`,
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/part`supp,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`
where
s_suppkey = l_suppkey
and ps_suppkey = l_suppkey
and ps_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and o_orderkey = l_orderkey
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and p_name like '%green%'
) as profit
group by
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
o_year
order by
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`,
o_year desc;

--Returned Item Reporting Query (Q10)
select
c_custkey,
c_name,
sum(l_extendedprice * (1 - l_discount)) as revenue,
c_acctbal,
n_name,
c_address,
c_phone,
c_comment
from
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`
where
c_custkey = o_custkey
and l_orderkey = o_orderkey
and o_orderdate >= cast('1993-10-01' as timestamp)
and o_orderdate < cast('1993-10-01' as timestamp) + interval 3 month
and l_returnflag = 'R'
and c_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
group by
c_custkey,
c_name,
c_acctbal,
c_phone,
n_name,
c_address,
c_comment
order by
revenue desc;

--Shipping Modes and Order Priority Query (Q12)
select
l_shipmode,
sum(case
when o_orderpriority ='1-URGENT'
or o_orderpriority ='2-HIGH'
then 1
else 0
end) as high_line_count,
sum(case
when o_orderpriority <> '1-URGENT'
and o_orderpriority <> '2-HIGH'
then 1
else 0
end) as low_line_count
from
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
o_orderkey = l_orderkey
and l_shipmode in ('MAIL', 'SHIP')
and l_commitdate < l_receiptdate
and l_shipdate < l_commitdate
and l_receiptdate >= cast('1994-01-01' as timestamp)
and l_receiptdate < cast('1994-01-01' as timestamp) + interval 1 year
group by
l_shipmode
order by
l_shipmode;

--Customer Distribution Query (Q13)
select c_count, count(*) as custdist
from 
    (
        select c_custkey, count(o_orderkey) as c_count
        from `s3-mckp-data-test`.`tcph-benchmark/s1/customer` 
        left outer join `s3-mckp-data-test`.`tcph-benchmark/s1/orders` 
            on c_custkey = o_custkey
            and o_comment not like '%special%requests%'
        group by c_custkey
    )as c_`s3-mckp-data-test`.`tcph-benchmark/s1/orders`
group by c_count
order by custdist desc, c_count desc;

--Promotion Effect Query (Q14)
select
100.00 * sum(case
when p_type like 'PROMO%'
then l_extendedprice*(1-l_discount)
else 0
end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/part`
where
l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and l_shipdate >= cast('1995-09-01' as timestamp)
and l_shipdate < cast('1995-09-01' as timestamp) + interval 1 month;

--Top Supplier Query (Q15)
create view revenue1 (`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`_no, total_revenue) as
select
l_suppkey,
sum(l_extendedprice * (1 - l_discount))
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
l_shipdate >= cast('1996-01-01' as timestamp)
and l_shipdate < cast('1996-01-01' as timestamp) + interval 3 month
group by
l_suppkey;
select
s_suppkey,
s_name,
s_address,
s_phone,
total_revenue
from
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
revenue1
where
s_suppkey = `s3-mckp-data-test`.`tcph-benchmark/s1/supplier`_no
and total_revenue = (
select
max(total_revenue)
from
revenue1
)
order by
s_suppkey;
drop view revenue1;

--Parts/Supplier Relationship Query (Q16)
select
p_brand,
p_type,
p_size,
count(distinct ps_suppkey) as `s3-mckp-data-test`.`tcph-benchmark/s1/supplier`_cnt
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`supp,
`s3-mckp-data-test`.`tcph-benchmark/s1/part`
where
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = ps_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and p_brand <> 'Brand#45'
and p_type not like 'MEDIUM POLISHED%'
and p_size in (49, 14, 23, 45, 19, 3, 36, 9)
and ps_suppkey not in (
select
s_suppkey
from
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`
where
s_comment like '%Customer%Complaints%'
)
group by
p_brand,
p_type,
p_size
order by
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`_cnt desc,
p_brand,
p_type,
p_size;

--Small-Quantity-Order Revenue Query (Q17)
select
sum(l_extendedprice) / 7.0 as avg_yearly
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/part`
where
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and p_brand = 'Brand#23'
and p_container = 'MED BOX'
and l_quantity < (
select
0.2 * avg(l_quantity)
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
);

--Large Volume Customer Query (Q18)
select
c_name,
c_custkey,
o_orderkey,
o_orderdate,
o_totalprice,
sum(l_quantity)
from
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
o_orderkey in (
select
l_orderkey
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
group by
l_orderkey having
sum(l_quantity) > 300
)
and c_custkey = o_custkey
and o_orderkey = l_orderkey
group by
c_name,
c_custkey,
o_orderkey,
o_orderdate,
o_totalprice
order by
o_totalprice desc,
o_orderdate;

--Discounted Revenue Query (Q19)
select
sum(l_extendedprice * (1 - l_discount) ) as revenue
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`,
`s3-mckp-data-test`.`tcph-benchmark/s1/part`
where
(
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and p_brand = 'Brand#12'
and p_container in ( 'SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
and l_quantity >= 1 and l_quantity <= 1 + 10
and p_size between 1 and 5
and l_shipmode in ('AIR', 'AIR REG')
and l_shipinstruct = 'DELIVER IN PERSON'
)
or
(
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and p_brand = 'Brand#23'
and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
and l_quantity >= 10 and l_quantity <= 10 + 10
and p_size between 1 and 10
and l_shipmode in ('AIR', 'AIR REG')
and l_shipinstruct = 'DELIVER IN PERSON'
)
or
(
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and p_brand = 'Brand#24'
and p_container in ( 'LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
and l_quantity >= 20 and l_quantity <= 20 + 10
and p_size between 1 and 15
and l_shipmode in ('AIR', 'AIR REG')
and l_shipinstruct = 'DELIVER IN PERSON'
);

--Potential Part Promotion Query (Q20)
select
s_name,
s_address
from
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`, `s3-mckp-data-test`.`tcph-benchmark/s1/nation`
where
s_suppkey in (
select
ps_suppkey
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`supp
where
ps_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key in (
select
p_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
from
`s3-mckp-data-test`.`tcph-benchmark/s1/part`
where
p_name like 'forest%'
)
and ps_availqty > (
select
0.5 * sum(l_quantity)
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem`
where
l_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key = ps_`s3-mckp-data-test`.`tcph-benchmark/s1/part`key
and l_suppkey = ps_suppkey
and l_shipdate >= cast('1994-01-01' as timestamp)
and l_shipdate < cast('1994-01-01' as timestamp) + interval 1 year
)
)
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and n_name = 'CANADA'
order by
s_name;

--Suppliers Who Kept Orders Waiting Query (Q21)
select
s_name,
count(*) as numwait
from
`s3-mckp-data-test`.`tcph-benchmark/s1/supplier`,
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem` l1,
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`,
`s3-mckp-data-test`.`tcph-benchmark/s1/nation`
where
s_suppkey = l1.l_suppkey
and o_orderkey = l1.l_orderkey
and o_`s3-mckp-data-test`.`tcph-benchmark/s1/orders`tatus = 'F'
and l1.l_receiptdate > l1.l_commitdate
and exists (
select
*
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem` l2
where
l2.l_orderkey = l1.l_orderkey
and l2.l_suppkey <> l1.l_suppkey
)
and not exists (
select
*
from
`s3-mckp-data-test`.`tcph-benchmark/s1/lineitem` l3
where
l3.l_orderkey = l1.l_orderkey
and l3.l_suppkey <> l1.l_suppkey
and l3.l_receiptdate > l3.l_commitdate
)
and s_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key = n_`s3-mckp-data-test`.`tcph-benchmark/s1/nation`key
and n_name = 'SAUDI ARABIA'
group by
s_name
order by
numwait desc,
s_name;

--Global Sales Opportunity Query (Q22)
select
cntrycode,
count(*) as numcust,
sum(c_acctbal) as totacctbal
from (
select
substring(c_phone,1,2) as cntrycode,
c_acctbal
from
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`
where
substring(c_phone,1,2) in
('13','31','23','29','30','18','17')
and c_acctbal > (
select
avg(c_acctbal)
from
`s3-mckp-data-test`.`tcph-benchmark/s1/customer`
where
c_acctbal > 0.00
and substring(c_phone,1,2) in
('13','31','23','29','30','18','17')
)
and not exists (
select
*
from
`s3-mckp-data-test`.`tcph-benchmark/s1/orders`
where
o_custkey = c_custkey
)
) as custsale
group by
cntrycode
order by
cntrycode;


