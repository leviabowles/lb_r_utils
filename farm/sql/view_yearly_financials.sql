drop view if exists farm_db.yearly_financials;
create view farm_db.yearly_financials AS 
select field_key,
	year_key,
	trans_type,
	object_type,
	paid_amount,
	received_amount 
from farm_db.field_year_transaction;
