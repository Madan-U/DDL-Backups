-- Object: PROCEDURE citrus_usr.pr_select_img_scancopy_bak12082013
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create procedure  [citrus_usr].[pr_select_img_scancopy_bak12082013] (@pa_acctno numeric)
as
begin
 select imagepath from Dis_req_Dtls  
 where deleted_ind = 1  and boid= @pa_acctno
and slip_yn = 'S'
end

GO
