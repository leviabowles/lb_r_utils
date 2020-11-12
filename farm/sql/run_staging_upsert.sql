use farm_db;
drop procedure if exists run_staging_upsert;
DELIMITER //
CREATE PROCEDURE run_staging_upsert()
BEGIN
insert into field_year_crop (field_key, year_key, crop_key)
select
	sfyc.field_key,
	sfyc.year_key,
    sfyc.crop_key 
from staging_field_year_crop sfyc 
	left join field_year_crop fyc on fyc.field_key = sfyc.field_key
		and fyc.year_key = sfyc.year_key
where pushed = 0
	and fyc.id is null;

select *
from staging_field_year_crop sfyc 
	left join field_year_crop fyc on fyc.field_key = sfyc.field_key
		and fyc.year_key = sfyc.year_key
where pushed = 0
	and fyc.id is null;
    
insert into field_year_transaction (field_key,year_key ,trans_type ,object_type ,invoice_date ,paid_date ,vendor ,expense_category,paid_amount,received_amount)
select
	sfyt.field_key,
    sfyt.year_key ,
    sfyt.trans_type,
    sfyt.object_type,
    sfyt.invoice_date,
    sfyt.paid_date ,
    sfyt.vendor ,
    sfyt.expense_category,
    sfyt.paid_amount,
    sfyt.received_amount 
from staging_field_year_transaction sfyt
	left join field_year_transaction fyt on fyt.field_key = sfyt.field_key
		and fyt.year_key = sfyt.year_key
        and fyt.object_type = sfyt.object_type
where pushed = 0
	and fyt.id is null
    and sfyt.object_type in (select object_type from staging_legit_transaction_objects);
    
    
select
	sfyt.*
from staging_field_year_transaction sfyt
	left join field_year_transaction fyt on fyt.field_key = sfyt.field_key
		and fyt.year_key = sfyt.year_key
        and fyt.object_type = sfyt.object_type
where pushed = 0
	and fyt.id is null;

END //

DELIMITER ;
