drop view if exists yearly_agg_financials;
create view yearly_agg_financials as

select fy.field_key, 
	fy.year_key,
    trans.costs,
    trans.revenue,
    alp.interest_payment,
    alp.principal_payment,
    yy.capital_payment
from field_year fy 
	left join (select fyt.field_key,
			fyt.year_key,
			sum(fyt.paid_amount) as costs,
			sum(fyt.received_amount) as revenue
		from field_year_transaction fyt 
		group by fyt.field_key, fyt.year_key) trans on trans.field_key = fy.field_key
			and trans.year_key = fy.year_key
	left join  annual_loan_payment alp on alp.field_key = fy.field_key
		and alp.year_key = fy.year_key
	left join (select cp.field_key, 
			cp.year_key,
			sum(cp.total_payment) as capital_payment
        from capital_payment cp
        group by cp.field_key, cp.year_key) yy on yy.field_key = fy.field_key
			and yy.year_key = fy.year_key;