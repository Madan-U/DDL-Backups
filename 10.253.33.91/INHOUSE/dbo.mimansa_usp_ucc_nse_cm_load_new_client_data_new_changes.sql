-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_load_new_client_data_new_changes
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_load_new_client_data_new_chnages] (
		@from_date varchar(11), 
		@to_date varchar(11) 
	)

as
begin
/*

	exec [mimansa_usp_ucc_nse_cm_load_new_client_data_new_chnages]
		@from_date = 'Jun 14 2013',
		@to_date = 'Jun 14 2013'
*/
set nocount on


set implicit_transactions off 
set transaction isolation level read uncommitted 

insert into 
	mimansa_angel_tbl_ucc_nse_cm_trade_new_changes
select distinct
	party_code,added_date
from
	(
		select 
			c2.party_code,
			--active = case when activefrom >= convert(datetime, left(convert(varchar, getdate(), 109), 11) + ' 00:00:00') then 'Y' else 'N' end,
			added_date = active_date
			
		from 
			anand1.msajag.dbo.Client_Details c2 with(nolock),
			anand1.msajag.dbo.Client_Brok_Details c5 with(nolock)
		where
			c2.cl_code = c5.cl_code and
			c5.active_date >= convert(datetime, @from_date + ' 00:00:00') and
			c5.active_date < convert(datetime, @to_date + ' 23:59:59') and 
			c5.exchange='NSE' and
			c5.segment='CAPITAL' and
			left(c5.cl_code,2) <> '98'
	) new_clients
order by
	party_code

insert into mimansa_angel_tbl_ucc_nse_cm_trade_new_changes_log select *,@from_date,@to_date,getdate() from mimansa_angel_tbl_ucc_nse_cm_trade_new_changes with(nolock)

end

GO
