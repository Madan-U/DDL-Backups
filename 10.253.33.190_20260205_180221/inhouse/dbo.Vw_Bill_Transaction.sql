-- Object: VIEW dbo.Vw_Bill_Transaction
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------

CREATE View Vw_Bill_Transaction  
 as  
 select * from dmat.dbo.Vw_Bill_Transaction  
 UNION ALL
 SELECT * FROM DMAT.CITRUS_USR.VW_BILL_TRANSACTION

GO
