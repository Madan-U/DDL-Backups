-- Object: PROCEDURE dbo.ConsolidatedSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ConsolidatedSP    Script Date: 02/22/2002 5:06:47 PM ******/

/****** Object:  Stored Procedure dbo.ConsolidatedSP    Script Date: 01/24/2002 12:11:36 PM ******/
CREATE Proc ConsolidatedSP

As

select grpname,grpcode,acname,cltcode ,
openentry=isnull(sum(openentry),0),
dramt = isnull(sum(dramt),0),
cramt = isnull(sum(cramt),0)
from ConsolidatedTable
group by  grpname,grpcode,acname,cltcode
order by grpcode,cltcode

GO
