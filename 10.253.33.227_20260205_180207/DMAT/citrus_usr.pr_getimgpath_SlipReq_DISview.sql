-- Object: PROCEDURE citrus_usr.pr_getimgpath_SlipReq_DISview
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


Create Procedure [citrus_usr].[pr_getimgpath_SlipReq_DISview](@pa_id varchar(10),@pa_slip_no varchar(10),@pa_case varchar(10))
as
--Select 
--case when @pa_case='1' then imagepathbinary
--when @pa_case='2' then imagepath1binary
--when @pa_case='3' then imagepath2binary else imagepathbinary end
--from dis_req_dtls_mak 
--where case when @pa_slip_no='' then convert(varchar,id) else req_slip_no end = case when @pa_slip_no='' then @pa_id else @pa_slip_no  end 

select 
case when @pa_case='1' then scanimage
when @pa_case='2' then scanimage_Annx1
when @pa_case='3' then scanimage_Annx2 
when @pa_case='4' then scanimage_Annx3 
when @pa_case='5' then scanimage_Annx4
when @pa_case='6' then scanimage_Annx5 else scanimage end
from maker_scancopy where deleted_ind=1 and slip_no=@pa_slip_no

GO
