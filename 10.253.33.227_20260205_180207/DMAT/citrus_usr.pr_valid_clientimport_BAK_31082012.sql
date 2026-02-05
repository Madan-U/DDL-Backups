-- Object: PROCEDURE citrus_usr.pr_valid_clientimport_BAK_31082012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_valid_clientimport '3',''
 
CREATE proc [citrus_usr].[pr_valid_clientimport_BAK_31082012](@pa_exch numeric,@pa_out varchar(1000) out)
as
begin
    SET NOCOUNT ON   

  declare @l_validmsg varchar(1000) 
  ,@l_validmsg1 varchar(1000)
  set @l_validmsg1 = ''
  set @l_validmsg  = 'Response Upload Pending For Following Batch No : '
  

  if exists(select dpam_sba_no from dp_acct_mstr where dpam_sba_no = dpam_acct_no and dpam_batch_no is not null and dpam_deleted_ind = 1 and dpam_excsm_id = @pa_exch)
  begin 
    select distinct convert(varchar(50),dpam_batch_no)  dpam_batch_no into #temp_pending_response  from dp_acct_mstr where dpam_sba_no = dpam_acct_no and dpam_batch_no is not null and dpam_deleted_ind = 1 and dpam_excsm_id = @pa_exch
 
  select @l_validmsg1 = @l_validmsg1 + dpam_batch_no + ',' from #temp_pending_response
 end 
  if  @l_validmsg1 = ''
  set @l_validmsg1 = ''
  else 
  set @l_validmsg1 = substring(@l_validmsg1,1,len(@l_validmsg1)-1)

  if @l_validmsg1 <>''
  set @pa_out = ''--@l_validmsg + @l_validmsg1
  else 
  set @pa_out = ''

  print @pa_out
end

GO
