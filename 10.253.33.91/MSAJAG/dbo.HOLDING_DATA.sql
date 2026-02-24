-- Object: PROCEDURE dbo.HOLDING_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE [dbo].[HOLDING_DATA]
(
 @DATE VARCHAR(15),---= '06/25/2019'
 @ISIN VARCHAR(15) --='INE312H01016'
)
AS
BEGIN
 
 
SELECT * INTO #HOLD1 FROM [AGMUBODPL3].dmat.DBO.SYNERGY_HOLDING WHERE HLD_HOLD_DATE =@DATE
  
SELECT * INTO #CLOSIN1 FROM [AGMUBODPL3].dmat.CITRUS_USR.VW_ISIN_RATE_MASTER A,
(SELECT ISIN AS ISIN_NO,MAX(RATE_DATE) RATE  FROM AGMUBODPL3.dmat.CITRUS_USR.VW_ISIN_RATE_MASTER WHERE  RATE_DATE <=@DATE GROUP BY ISIN )B
WHERE A.ISIN=B.ISIN_NO  AND A.RATE_DATE =B.RATE 

  
 
SELECT HLD_AC_CODE,HLD_isin_CODE,HLD_AC_POS,CLOSE_PRICE,SUM(HLD_AC_POS*CLOSE_PRICE)VALUE into #data1  FROM #HOLD1 H, #CLOSIN1 WHERE ISIN=HLD_ISIN_CODE
and HLD_isin_CODE=@ISIN
GROUP BY HLD_AC_CODE,HLD_isin_CODE,HLD_AC_POS,CLOSE_PRICE



---select nise_party_code,client_code into #client  from [AGMUBODPL3].dmat.citrus_usr.tbl_client_master where nise_party_Code in(select * from #s)


select a.*,b.nise_party_code INTO #TEMP1 from #data1 a
left outer join
[AGMUBODPL3].dmat.citrus_usr.tbl_client_master b
on a.HLD_AC_CODE=b.client_code


select a.*,b2c =case when b2c='y' then 'B2C' ELSE 'B2B' end from #TEMP1 a
left outer join
INTRANET.risk.dbo.client_details b
on a.nise_party_code=b.cl_code
where     b2c='y'

ORDER BY A.NISE_PARTY_cODE
 

 END

GO
