use farm_db;
call run_staging_upsert();

drop temporary table if exists rev_anal;
CREATE TEMPORARY TABLE rev_anal as 
select field_key, 
	year_key, 
    sum(paid_amount) as expenses, 
    sum(received_amount) as revenue
from field_year_transaction
group by field_key, year_key;

select field_key, 
	year_key, 
    expenses, 
    revenue, 
    (revenue-expenses)/revenue as margin_percent
from rev_anal;