-- Object: PROCEDURE dbo.rpt_acccostsumcostdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumcostdrcr    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_acccostsumcostdrcr    Script Date: 01/04/1980 5:06:25 AM ******/


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
