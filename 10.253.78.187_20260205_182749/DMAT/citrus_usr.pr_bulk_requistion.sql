-- Object: PROCEDURE citrus_usr.pr_bulk_requistion
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


--exec pr_bulk_requistion 'TKYC1328'
CREATE procedure pr_bulk_requistion (@pa_login_name varchar(30))
as
begin
declare  @ben cursor
,@c_ben_acct_no1  varchar(20)  
,@c_ben_acct_no2  numeric   
,@c_ben_acct_no3  varchar(20)   

set @ben  = CURSOR fast_forward FOR 
SELECT DISTINCT BOID,ID,GEN_ID FROM DIS_REQ_DTLS_MAK WHERE GEN_ID>='6810' AND DELETED_IND=0 ORDER BY GEN_ID

open @ben  
  
fetch next from @ben into @c_ben_acct_no1,  @c_ben_acct_no2 ,@c_ben_acct_no3
WHILE @@fetch_status = 0                                                                                                          
BEGIN --#cursor                                                                                                          
--  
--exec pr_ins_upd_reqdtls 'APP','TKYC1328',@c_ben_acct_no2,'N','N',1,'N','N','N','N','','N','N',@c_ben_acct_no1,'N','N','D','N',0,0,0

exec pr_ins_upd_reqdtls @pa_action=N'APP',@pa_login_name=N'TKYC1328',@pa_id=@c_ben_acct_no2,@pa_boname=N'',@pa_sholder=N'',@pa_chk_yn=1,@pa_rmks=N'',
@pa_imagepath=N'',@pa_imagepath1=N'',@pa_imagepath2=N'',@pa_error='',@pa_req_slip_no=N'',@pa_req_date=N'',@pa_boid=@c_ben_acct_no1,@pa_tholder=N'',@pa_chk_rmks=N'',@pa_slip_yn=N'D',@pa_type=N'',@pa_imagepathBinary=0,@pa_imagepath1Binary=0,@pa_imagepath2Binary=0


fetch next from @ben into @c_ben_acct_no1   ,@c_ben_acct_no2,@c_ben_acct_no3

end

close @ben    
deallocate  @ben
end

GO
