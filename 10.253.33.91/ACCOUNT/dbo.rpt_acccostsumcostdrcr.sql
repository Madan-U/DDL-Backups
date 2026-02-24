-- Object: PROCEDURE dbo.rpt_acccostsumcostdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumcostdrcr    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsumcostdrcr    Script Date: 11/28/2001 12:23:46 PM ******/


/* calculates drcr for a given level and below that */

CREATE PROCEDURE rpt_acccostsumcostdrcr

@catcode  smallint,
@grpcode varchar(20),
@vdt datetime


AS

/* finds for drcr same grpcode */

select catcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0) , amt= ( isnull(sum(dramt),0) -  isnull(sum(cramt),0))
from rpt_acccostwisedrcr 
where catcode= @catcode  and grpcode like ltrim(@grpcode) + '%'  and vdt <= @vdt + ' 23:59:59'
group by catcode

GO
