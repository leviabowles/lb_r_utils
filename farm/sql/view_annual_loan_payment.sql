create view annual_loan_payment as 
select l.field_key, 
	lp.year_key, 
    sum(lp.total_payment) as total_payment, 
    sum(lp.interest_payment) as interest_payment, 
    sum(lp.principal_payment) as principal_payment
from farm_db.loan_payment lp 
	inner join farm_db.loan l on l.loan_key = lp.loan_key
group by l.field_key, lp.year_key