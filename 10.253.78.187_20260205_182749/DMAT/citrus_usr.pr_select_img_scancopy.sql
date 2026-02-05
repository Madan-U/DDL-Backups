-- Object: PROCEDURE citrus_usr.pr_select_img_scancopy
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------






--create procedure  [citrus_usr].[pr_select_img_scancopy_bak12082013] (@pa_acctno numeric)
--as
--begin
-- select imagepath from Dis_req_Dtls  
-- where deleted_ind = 1  and boid= @pa_acctno
--and slip_yn = 'S'
--end


CREATE procedure  [citrus_usr].[pr_select_img_scancopy] (@pa_acctno numeric,@pa_id numeric)--,@pa_slipno varchar(20)
as
begin
 select imagepath,imagepathbinary from Dis_req_Dtls  
 where deleted_ind = 1  and boid= @pa_acctno
and slip_yn in('S','L')
and id = @pa_id 
--and req_slip_no = @pa_slipno
end

GO
