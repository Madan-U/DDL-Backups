-- Object: PROCEDURE dbo.spx_GetMarginDataForLeadSquare
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- =============================================            
--EXEC [spx_GetMarginDataForLeadSquare]    'DIYD85223','2019-09-03 15:16:30.243','15'        
CREATE PROCEDURE [dbo].[spx_GetMarginDataForLeadSquare]            
(            
@ClientCode varchar(20)=null,          
@ActivationDate datetime=null,          
@Days varchar(10)          
)            
AS      
Return 0      
/*      
      
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 -- interfering with SELECT statements.            
 SET NOCOUNT ON;            
            
    -- Insert statements for procedure here            
        
-- To include activation date transactions         
SET @ActivationDate = cast(Convert(varchar(11),@ActivationDate,106) as datetime)         
             
DECLARE @15Days datetime          
          
If(@Days = '7')          
BEGIN        
 SET @15Days = DATEADD(day, 7, @ActivationDate)          
 SET @15Days = DATEADD(MS, -3, @15Days)        
END        
Else If(@Days = '15')          
BEGIN        
 SET @15Days = DATEADD(day, 15, @ActivationDate)          
 SET @15Days = DATEADD(MS, -3, @15Days)        
END        
Else         
BEGIN          
 SET @15Days = DATEADD(day, 30, @ActivationDate)          
 SET @15Days = DATEADD(MS, -3, @15Days)        
END           
                
    SELECT EXCHANGE,CLTCODE,ACNAME,BRANCH_CD,vtyp,(case when VTYP='2' THEN 'PAYIN' ELSE 'PAYOUT' END) AS TYPE,DRCR,VDT,VNO,VAMT,NARRATION             
into #party            
FROM (            
SELECT distinct 'NSE' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM LEDGER(NOLOCK) A JOIN MSAJAG..CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode             
AND VDT >=@ActivationDate AND VDT < = @15Days            
UNION ALL            
SELECT distinct 'BSE' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER A JOIN [AngelBSECM].BSEDB_AB.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode            
AND VDT >=@ActivationDate AND VDT < = @15Days            
UNION ALL            
SELECT distinct 'NSEFO' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM [AngelFO].ACCOUNTFO.DBO.LEDGER A JOIN [AngelFO].NSEFO.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode            
AND VDT >=@ActivationDate AND VDT < = @15Days            
UNION ALL            
SELECT distinct 'NSECURFO' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER A JOIN [AngelFO].NSECURFO.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode            
AND VDT >=@ActivationDate AND VDT < = @15Days            
UNION ALL            
SELECT distinct 'NCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER A JOIN [AngelCommodity].NCDX.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode            
AND VDT >=@ActivationDate AND VDT < = @15Days            
UNION ALL            
SELECT distinct 'MCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER A JOIN [AngelCommodity].MCDX.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode            
AND VDT >=@ActivationDate AND VDT < = @15Days            
UNION ALL            
SELECT distinct 'MCDXCDS' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT,NARRATION             
FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER A JOIN [AngelCommodity].MCDXCDS.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE            
WHERE a.VTYP IN ('2','3') and CLTCODE = @ClientCode            
AND VDT >=@ActivationDate AND VDT < = @15Days            
) A ORDER BY EXCHANGE            
            
SELECT EXCHANGE,CLTCODE,ACNAME,VDT,BRANCH_CD,[TYPE],NARRATION ,case when VTYP='2' then 'REPBNK'             
when  vtyp='3' then 'PAYBNK'             
when vtyp='17' then 'Cheque return' end as voucher_type,vtyp,(CASE WHEN DRCR='D' THEN VAMT ELSE 0 END )AS DEBIT,            
(CASE WHEN DRCR='C' THEN VAMT ELSE 0 END )AS CREDIT,VNO,VAMT             
INTO #PAYIN_PAYOUT_DATA            
FROM #party            
            
SELECT DISTINCT * FROM #PAYIN_PAYOUT_DATA            
            
DROP TABLE #party            
DROP TABLE #PAYIN_PAYOUT_DATA            
                
                
            
END         
  */

GO
