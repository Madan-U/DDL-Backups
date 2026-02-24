-- Object: PROCEDURE dbo.rpt_acccostsumcategory
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumcategory    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsumcategory    Script Date: 11/28/2001 12:23:46 PM ******/



/* 
    finds category wise debit and credit amounts as on a particular date
    rpt_acccostwisedrcr view  also has records whose category is '' 
    so don't take them
*/


CREATE PROCEDURE rpt_acccostsumcategory

@userdate datetime

AS


select category,catcode, dramt=sum(dramt),cramt=sum(cramt) from rpt_acccostwisedrcr 
where  vdt <= @userdate + ' 23:59:59'
and category <> ''
group by category,catcode
order by category

GO
