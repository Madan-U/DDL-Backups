-- Object: PROCEDURE dbo.rpt_acccostsumnextcostdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumnextcostdrcr    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsumnextcostdrcr    Script Date: 11/28/2001 12:23:46 PM ******/


/* cost center summary report  */
/*finds debit and credit of a cost centers below a particular level */


CREATE PROCEDURE rpt_acccostsumnextcostdrcr

@catcode smallint ,
@grpcode varchar(20),
@vdt datetime


 AS



select costname,catcode,grpcode , dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)
from rpt_acccostwisedrcr 
where catcode= @catcode 
and grpcode like ltrim(@grpcode) 
and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costname

GO
