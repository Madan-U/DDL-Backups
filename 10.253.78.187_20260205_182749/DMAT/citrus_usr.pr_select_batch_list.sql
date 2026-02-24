-- Object: PROCEDURE citrus_usr.pr_select_batch_list
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_select_batch_list]
as
begin
	
	Declare @l_batchlist	varchar(8000)

	set @l_batchlist = ''

	select @l_batchlist =  convert(varchar,DPAM_BATCH_NO) + ',' + @l_batchlist 
	from dp_acct_mstr 
	where DPAM_BATCH_NO is not null and dpam_acct_no = dpam_sba_no
	
	select @l_batchlist

end

GO
