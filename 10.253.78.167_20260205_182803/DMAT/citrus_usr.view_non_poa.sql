-- Object: VIEW citrus_usr.view_non_poa
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


Create View view_non_poa
as
select  boid,[ACTIVATION DATE] as active_Date 
from vw_nonpoaclient (nolock)

GO
