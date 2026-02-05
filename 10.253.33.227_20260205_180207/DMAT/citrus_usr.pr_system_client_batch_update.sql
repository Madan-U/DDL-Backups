-- Object: PROCEDURE citrus_usr.pr_system_client_batch_update
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--rollback
--begin tran
--pr_system_client_batch_update 4,'update','',''  
--select * from dp_acct_mstr where dpam_id in( 61349,64140)  
--pr_system_client_batch_update '61349*|~*64140*|~*','update','',''
--select top 2 * from dp_acct_mstr_hst order by dpam_lst_upd_dt desc 
CREATE procedure [citrus_usr].[pr_system_client_batch_update]( @pa_id         varchar(1000) 
															, @pa_tab      varchar(20)  
															, @pa_from_dt  varchar(11)  
															, @pa_to_dt    varchar(11)  
															)  
as  
--  
begin  
--  
declare @c_cursor    cursor  
       ,@c_dpam_id   numeric  
       ,@l_counter   numeric  
       ,@l_count     numeric  
--  
--  
if @pa_tab = 'select'  
begin  
--  
select dpam_id
     , dpam_acct_no  
     , dpam_sba_name  
     , dpam_sba_no  
     , dpam_batch_no  
from dp_acct_mstr   
where dpam_batch_no is null  
and dpam_id not in (select dpam_id from dp_acct_mstr_mak where dpam_deleted_ind=0)  
and dpam_Deleted_ind = 1   
AND dpam_created_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'  
--  
--  
end  
--  
if @pa_tab = 'update'  
begin  
--
--
--
SELECT @l_count = convert(numeric,citrus_usr.ufn_CountString(@pa_id , '*|~*'))
--SELECT @l_count = convert(numeric,citrus_usr.fn_splitval(@pa_id , '|*~|'))  
--  
SET @l_counter = 1   
--  
WHILE @l_counter < = @l_count  
BEGIN  
--  
--  
update dp_acct_mstr   
set dpam_batch_no = 1   
--where dpam_id = citrus_usr.FN_SPLITVAL_ROW(@pa_id,@l_counter)  
where dpam_id = convert(numeric,citrus_usr.FN_SPLITVAL_row(@pa_id,@l_counter))  
--
SET @l_counter = @l_counter  + 1  
--
--  
end  
--  
end  
--  
--  
--  
--  
end  
--

GO
