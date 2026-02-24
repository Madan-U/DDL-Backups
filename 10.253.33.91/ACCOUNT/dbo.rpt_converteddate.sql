-- Object: PROCEDURE dbo.rpt_converteddate
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_todaydate    Script Date: 20-Mar-01 11:39:03 PM ******/



CREATE PROCEDURE rpt_converteddate
AS
select  substring(convert(varchar,getdate(),103),4,2)+ "/" + substring(convert(varchar,getdate(),103),1,2)+ "/" + substring(convert(varchar,getdate(),103),7,4)

GO
