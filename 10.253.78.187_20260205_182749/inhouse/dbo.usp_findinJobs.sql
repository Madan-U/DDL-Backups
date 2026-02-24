-- Object: PROCEDURE dbo.usp_findinJobs
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

	Create Procedure usp_findinJobs(@Str as varchar(500))  
as  
select b.name,  
Case when b.enabled=1 then 'Active' else 'Deactive' end as Status,  
date_created,date_modified,a.step_id,a.step_name,a.command  
from msdb.dbo.sysjobsteps a, msdb.dbo.sysjobs b  
where command like '%'+@Str+'%'  
and a.job_id=b.job_id

GO
