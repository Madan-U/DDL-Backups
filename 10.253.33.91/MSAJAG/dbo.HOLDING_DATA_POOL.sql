-- Object: PROCEDURE dbo.HOLDING_DATA_POOL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 
--- HOLDING_DATA_POOL  'JUN 17 2019','INE312H01016'
CREATE PROCEDURE [dbo].[HOLDING_DATA_POOL]
(
 
@date varchar(15) , @ISIN VARCHAR(15) 

)
AS
BEGIN
 
DECLARE @FromDate DATETIME=CAST(@date  AS DATETIME)
DECLARE @ToDate DATETIME=DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, @date)))  

 
SELECT party_Code,exchange,scrip_cd,accno,ISIN,QTY,CLSRATE,SUM(QTY*CLSRATE) as holding 
into #b2b
 FROM [CSOKYC-6].GENERAL.DBO.RMS_Holding where isin=@ISIN and upd_date>=@FromDate AND UPD_DATE<=@ToDate
 and exchange<>'poa'
 group by party_Code,exchange,scrip_cd,accno,ISIN,QTY,CLSRATE
 union 
 SELECT party_Code,exchange,scrip_cd,accno,ISIN,QTY,CLSRATE,SUM(QTY*CLSRATE) as holding 
 FROM [CSOKYC-6].history.DBO.RMS_Holding where isin=@ISIN  and upd_date>=@FromDate AND UPD_DATE<=@ToDate
 and exchange<>'poa'
 group by party_Code,exchange,scrip_cd,accno,ISIN,QTY,CLSRATE


 select a.*,b2c =case when b2c='y' then 'B2C' ELSE 'B2B' end from #b2b a
 left outer join
 INTRANET.risk.dbo.client_details b
 on a.party_code=b.cl_code
 where     b2c='y'
 

 END

GO
