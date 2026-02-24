-- Object: PROCEDURE dbo.mimansa_usp_ucc_nse_cm_load_new_client_data
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE proc

	[dbo].[mimansa_usp_ucc_nse_cm_load_new_client_data] (
		@from_date varchar(11), 
		@to_date varchar(11) 
	)

as

/*

	exec [mimansa_usp_ucc_nse_cm_load_new_client_data]
		@from_date = 'MAr 06 2013',
		@to_date = 'Mar 07 2013'
*/
set nocount on


set implicit_transactions off 
set transaction isolation level read uncommitted 

insert into 
	mimansa_angel_tbl_ucc_nse_cm_trade
select distinct
	party_code
from
	(
		select 
			c2.party_code,
			active = case when activefrom >= convert(datetime, left(convert(varchar, getdate(), 109), 11) + ' 00:00:00') then 'Y' else 'N' end,
			added_date = activefrom
		from 
			AngelNseCM.msajag.dbo.client2 c2 with(nolock),
			AngelNseCM.msajag.dbo.client5 c5 with(nolock)
		where
			ltrim(rtrim(c2.cl_code)) = ltrim(rtrim(c5.cl_code)) and
			activefrom >= convert(datetime, @from_date + ' 00:00:00') and
			activefrom < convert(datetime, @to_date + ' 23:59:59') and
			inactivefrom>=GETDATE() -- Added by prasanna on Jul 3 2013 for considerring only Active clienst from client5  
	) new_clients
order by
	party_code

GO
