-- Object: PROCEDURE citrus_usr.pr_getimgpath_SlipReq
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE Procedure [citrus_usr].[pr_getimgpath_SlipReq](@pa_id varchar(10),@pa_slip_no varchar(10),@pa_case varchar(10))
as
Select 
case when @pa_case='1' then imagepathbinary
when @pa_case='2' then imagepath1binary
when @pa_case='3' then imagepath2binary else imagepathbinary end
from dis_req_dtls_mak 
where case when @pa_slip_no='' then convert(varchar,id) else req_slip_no end = case when @pa_slip_no='' then @pa_id else @pa_slip_no  end

GO
