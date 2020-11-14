create view yearly_agg_financials as

select trans.field_key, 
	trans.year_key,
    trans.costs,
    trans.revenue,
    alp.interest_payment,
    alp.principal_payment
from 
		(select fyt.field_key,
			fyt.year_key,
			sum(fyt.paid_amount) as costs,
			sum(fyt.received_amount) as revenue
		from field_year_transaction fyt 
		group by fyt.field_key, fyt.year_key) trans
	left join  annual_loan_payment alp on alp.field_key = trans.field_key
		and alp.year_key = trans.year_key