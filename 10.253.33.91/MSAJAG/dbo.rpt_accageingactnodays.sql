-- Object: PROCEDURE dbo.rpt_accageingactnodays
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingactnodays    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingactnodays    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingactnodays 

@cltcode varchar(12),
@maxamt money,
@openentrydate datetime,
@userdate datetime

as

select actnodays= isnull(actnodays,0) 
from account.dbo.ledger 
where cltcode=@cltcode and balamt=@maxamt  and balamt >0 and vdt>=@openentrydate and vdt<=@userdate + ' 23:59:59'

GO
