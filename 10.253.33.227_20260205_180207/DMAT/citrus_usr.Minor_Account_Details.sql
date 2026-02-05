-- Object: VIEW citrus_usr.Minor_Account_Details
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


Create view Minor_Account_Details 
as 
select distinct a.*,t.NISE_PARTY_CODE as parent_code  from 
(select client_code,NISE_PARTY_CODE ,FIRST_HOLD_NAME,pangir as gaurdain_pan ,rtrim(ltrim(name ))+' '+rtrim(ltrim(middlename)) as gaurdian_name ,ITPAN as minor_pan 
from TBL_CLIENT_MASTER t (nolock),dps8_pc7 s (nolock) where  sub_type  like '%minor%'
and status<>'closed' and client_code=boid and pangir <>''
)a
left outer join
TBL_CLIENT_MASTER t (nolock)
on gaurdain_pan=ITPAN and status<>'closed'

GO
