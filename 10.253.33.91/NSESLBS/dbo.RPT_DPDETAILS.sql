-- Object: PROCEDURE dbo.RPT_DPDETAILS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DPDETAILS  
 (       
 @PARTYCODE VARCHAR(10)       
 )      

AS

--RPT_DPDETAILS '50006'
      
Select m.DPTYPE, b.BankName, m.dpid, m.cltdpno, M.DEF
from multicltid m join bank b
on (m.dpid = b.bankid)
where party_code = @partycode

UNION

Select m.DPTYPE, b.BankName, m.dpid, m.cltdpno, M.DEF
from BSEDB.DBO.Multicltid m join BSEDB.DBO.bank b
on (m.dpid = b.bankid)
where party_code = @partycode



Order by 5 Desc

GO
