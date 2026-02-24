-- Object: PROCEDURE dbo.rpt_acccostsummary
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsummary    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsummary    Script Date: 11/28/2001 12:23:46 PM ******/


/*inserts catcodewise,coscenterwise total debit and credit and balance till a particular date */


CREATE PROCEDURE rpt_acccostsummary

@vdt datetime

AS

select catcode,costcode,costname , Amount = Sum(DrAmt)-Sum(CrAmt),
dramt = Sum(DrAmt),  Cramt = Sum(CrAmt),category,grpcode
From rpt_acccostwisedrcr   l where  vdt <= @vdt + ' 23:59:59'  
group by catcode,category,l.costcode,l.costname,grpcode

GO
