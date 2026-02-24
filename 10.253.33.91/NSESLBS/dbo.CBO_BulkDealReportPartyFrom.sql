-- Object: PROCEDURE dbo.CBO_BulkDealReportPartyFrom
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROCEDURE CBO_BulkDealReportPartyFrom  
                 
AS  
  
  		SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED  
		
			SELECT DISTINCT
				party_code 
			FROM 
				settlement 
			WHERE 
				Tradeqty <> 0 and  party_code like '%' 
			UNION
 
			SELECT DISTINCT
				party_code 
			FROM 
				isettlement 
			WHERE 
				Tradeqty <> 0 and  party_code like '%' 
			ORDER BY 1 ASC

GO
