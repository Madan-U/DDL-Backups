-- Object: PROCEDURE dbo.rpt_ConAMarQrySettList
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_ConAMarQrySettList    Script Date: 04/21/2001 6:05:18 PM ******/

CREATE Procedure rpt_ConAMarQrySettList AS
/*
REPORT		-	ALBM MARGIN
FILE		-	//asp/cgi-bin/backoffice/Consolidated/ConALBMMargin/Main.asp
CREATED BY	-	Shyam
CREATE DATE	-	MAR 30 2001
FUNCTION	-	Query To Retreive ALBM Settlement Numbers From History & Settlement Tables
*/
Select Distinct Sett_No,sett_type From settlement
Where Sett_Type In ('n','w')
Union
Select Distinct Sett_No, sett_type From History
Where Sett_Type In ('n','w')
Order By Sett_No

GO
