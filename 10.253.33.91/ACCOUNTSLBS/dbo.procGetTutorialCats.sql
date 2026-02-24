-- Object: PROCEDURE dbo.procGetTutorialCats
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE procGetTutorialCats
AS
select 
	companyname,Exchange 
from 
	msajag..multicompany 
where 
	Exchange = 'NSE' and Segment = 'Capital'

GO
