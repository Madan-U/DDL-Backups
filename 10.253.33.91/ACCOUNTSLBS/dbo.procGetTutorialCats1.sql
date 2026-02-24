-- Object: PROCEDURE dbo.procGetTutorialCats1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROCEDURE procGetTutorialCats1
AS
select 
	Defaultclient
from 
	msajag..multicompany 
where 
	Exchange = 'NSE' and Segment = 'Capital'

GO
