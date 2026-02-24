-- Object: PROCEDURE dbo.rpt_acccostsumcategory
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumcategory    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_acccostsumcategory    Script Date: 01/04/1980 5:06:25 AM ******/



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
