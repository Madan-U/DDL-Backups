-- Object: PROCEDURE dbo.CBO_BulkDealReportDate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROCEDURE CBO_BulkDealReportDate  
                 
AS  
  
  		SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED  
		
		SELECT DISTINCT  
			left(convert(varchar,(convert(smalldatetime, sauda_date)),103),11) 
			as sauda_date , 
			day(convert(datetime,sauda_date)),
			month(convert(datetime,sauda_date)),  
			year(convert(datetime,sauda_date)) 
		FROM
			settlement  
		WHERE 
			Tradeqty <> 0 
		
		UNION
		
		SELECT DISTINCT  
				left(convert(varchar,(convert(smalldatetime, sauda_date)),103),11) as sauda_date , 
				day(convert(datetime,sauda_date)),month(convert(datetime,sauda_date)), 
				year(convert(datetime,sauda_date)) 
		FROM 
			isettlement  
		WHERE
			Tradeqty <> 0 
		
		ORDER BY  
			year(convert(datetime,sauda_date)),
			month(convert(datetime,sauda_date)),
			day(convert(datetime,sauda_date)), 
			left(convert(varchar,(convert(smalldatetime,sauda_date)),103),11)

GO
