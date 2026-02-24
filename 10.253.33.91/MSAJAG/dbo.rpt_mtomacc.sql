-- Object: PROCEDURE dbo.rpt_mtomacc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomacc    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomacc    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomacc    Script Date: 20-Mar-01 11:39:00 PM ******/


/****** Object:  Stored Procedure dbo.rpt_mtomacc    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomacc    Script Date: 12/27/00 8:58:55 PM ******/

/* Report : mtom
   File : allclients.asp
displays the debit & credit amount of a party
*/
CREATE PROCEDURE rpt_mtomacc
@clcode varchar(6)
AS
SELECT  dramt=isnull((case drcr when 
'd' then SUM(vamt)end),0), cramt=isnull((case drcr when 
'c' then SUM(vamt)end),0) 
from account.dbo.ledger,client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
WHERE CL_CODE = @clcode)and cltcode=party_code 
group by drcr

GO
