-- Object: PROCEDURE dbo.LOGINDEACTIVATE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[LOGINDEACTIVATE]
AS 

INSERT INTO DEACTIVELOGIN
select a.*,           
Case when b.emp_no is null then 'Quit' else 'Chng' end as [Type] ,GETDATE()           
from INTRANET.ROLEMGM.DBO.AIAAS_BoExEmpActiveLogin a left outer join intranet.risk.dbo.Emp_CostCodeChange b           
on a.emp_no=b.emp_no           
order by segment

GO
