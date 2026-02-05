-- Object: PROCEDURE citrus_usr.pr_bill_block_process
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*create table blocked_client_dtls      
(blocd_id numeric      
,blocd_dpam_sba_no varchar(100)      
,blocd_blocked_from datetime      
,blocd_blocked_to   datetime      
,blocd_blocked_narr   varchar(2500)      
,blocd_blocked_rmks   varchar(2500)      
,blocd_blocked_flag   varchar(20)      
,blocd_created_by   varchar(20)      
,blocd_created_dt   datetime      
,blocd_lst_upd_by   varchar(20)      
,blocd_lst_upd_dt   datetime      
,blocd_deleted_ind   smallint      
)*/      
    
--pr_bill_block_process 0,'SELECT','',0,9999999999999999,'','','','','',''    
--pr_bill_block_process 0,'INS','B','10/03/2010 10/03/2010 10000001   s  HH   
--pr_bill_block_process	0,'SEARCH','B','10000003','10000020','Mar  1 2010','Mar 31 2010','','','',''

--	0	SEARCH	B	10000004 	10000020	Mar  1 2010	Mar 31 2010								
    
CREATE procedure [citrus_usr].[pr_bill_block_process]    
(@pa_id numeric      
,@pa_action varchar(10)      
,@pa_block_act varchar(1)      
,@pa_from_acct varchar(16)      
,@pa_to_acct varchar(16)      
,@pa_block_from datetime      
,@pa_block_to   datetime      
,@pa_narr     varchar(2500)      
,@pa_rmks     varchar(2500)      
,@pa_login_name varchar(100)      
,@pa_out varchar(8000) out )      
as      
begin       
      
 if @pa_Action = 'SELECT'      
 begin       
      
  select dpam_sba_no from dp_Acct_mstr       
  where dpam_sba_no between @pa_from_acct and @pa_to_acct      
  and not exists (select blocd_dpam_sba_no       
      from blocked_client_dtls       
      where blocd_dpam_sba_no = dpam_sba_no       
      and blocd_blocked_flag = 'B'       
      and blocd_blocked_to is null      
      and blocd_deleted_ind = 1)      
 end       
 if @pa_Action = 'SEARCH'      
 begin       
        select blocd_id,
blocd_dpam_sba_no,
convert(varchar(11),blocd_blocked_from,103) blocd_blocked_from,
convert(varchar(11),blocd_blocked_to,103) blocd_blocked_to,
blocd_blocked_narr,
blocd_blocked_rmks,
blocd_blocked_flag,
blocd_created_by,
blocd_created_dt,
blocd_lst_upd_by,
blocd_lst_upd_dt,
blocd_deleted_ind from blocked_client_dtls      
        where blocd_blocked_flag = @pa_block_act      
        and   blocd_blocked_from between @pa_block_from and @pa_block_to      
        --and   blocd_blocked_to between @pa_block_from and @pa_block_to      
  and  blocd_dpam_sba_no between @pa_from_acct and @pa_to_acct  
        and  blocd_deleted_ind = 1       
    end       
    if @pa_action = 'INS'        
    begin       
      declare @l_blocd_id numeric      
      select @l_blocd_id = isnull(max(blocd_id),0) + 1 from blocked_client_dtls where blocd_deleted_ind = 1       
      
      insert into blocked_client_dtls      
      select @l_blocd_id , @pa_from_acct,@pa_block_from,null,@pa_narr,@pa_rmks      
   ,@pa_block_act,@pa_login_name ,getdate(),@pa_login_name , getdate(),1      
      
          
         
    end       
    if @pa_action = 'EDT'      
    begin       
            
      update blocked_client_dtls       
      set    blocd_blocked_flag   = @pa_block_act      
   ,blocd_blocked_narr   = @pa_narr      
   ,blocd_blocked_rmks   = @pa_rmks      
   ,blocd_blocked_from   = @pa_block_from       
   ,blocd_blocked_to     = case when @pa_block_act = 'B' then null else @pa_block_to end       
   ,blocd_lst_upd_by     = @pa_login_name      
   ,blocd_lst_upd_dt     = getdate()      
      where  blocd_id = @pa_id      
      and    blocd_deleted_ind = 1       
      
    end       
    if @pa_action = 'DEL'      
    begin       
      
      update blocked_client_dtls       
      set    blocd_deleted_ind = 0       
            ,blocd_lst_upd_by     = @pa_login_name      
   ,blocd_lst_upd_dt     = getdate()      
      where  blocd_id = @pa_id      
      and    blocd_deleted_ind = 1       
      
    end       
       
      
      
end

GO
