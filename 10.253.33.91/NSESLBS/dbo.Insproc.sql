-- Object: PROCEDURE dbo.Insproc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

  
CREATE Procedure [dbo].[Insproc]  @Settno  Varchar (7) , @Sett_Type Char(3)  As    
  
DECLARE @START_DATE VARCHAR(11)  
  
SELECT @START_DATE =  START_DATE FROM MSAJAG.DBO.Sett_Mst  
Where Sett_No = @Settno And Sett_Type =  @Sett_Type     
  
Exec Delpositionup  @Settno, @Sett_Type, '', ''      
Delete From  MSAJAG.DBO.Deliveryclt Where Sett_No = @Settno And Sett_Type =  @Sett_Type      
    
---Delete From MSAJAG.DBO.Deliveryclt_Report Where Sett_No = @Settno And Sett_Type =  @Sett_Type      
  
SELECT * INTO #DEL  FROM MSAJAG.DBO.Deliveryclt   WHERE 1=2  
  
Insert Into #DEL    
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Pqty) 'Tradeqty', Inout = 'O', 'Ho' , Partipantcode,''    
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type     
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode   
Having Sum(Pqty) > 0    
    
Insert Into #DEL  
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Sqty) 'Tradeqty', Inout = 'I', 'Ho' , Partipantcode,''  
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type    
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode   
Having Sum(Sqty) > 0    
     
UPDATE #DEL SET I_ISIN = M.ISIN FROM MSAJAG.DBO.MULTIISIN_NEW M  
WHERE @START_DATE BETWEEN EFF_FROM AND EFF_TO  
AND M.Scrip_cd=#DEL.scrip_cd  
AND M.Series=#DEL.series  
  
UPDATE #DEL SET I_ISIN = M.ISIN FROM MSAJAG.DBO.MULTIISIN M  
WHERE  M.Scrip_cd=#DEL.scrip_cd  
AND M.Series=#DEL.series  
AND Valid=1  
AND I_ISIN =''  
  
Insert Into MSAJAG.DBO.Deliveryclt   
SELECT * FROM #DEL   
  
--Insert Into MSAJAG.DBO.Deliveryclt_Report   
--SELECT * FROM #DEL   
  
----IF UPPER(LTRIM(RTRIM(@Sett_Type))) = 'L'      
----BEGIN      
      
----DELETE   DE  
----FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS  DE     
----WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE         
----AND FILLER2 = 1 AND HOLDERNAME = 'ROLLOVER ADJUSTMENT'  
----AND FROMNO IN ( SELECT ORDER_NO FROM NSESLBS.DBO.TRD_SETT_POS_ROLL T      
----WHERE LEFT(DE.TRANSDATE,11) = LEFT(T.SAUDA_DATE,11)      
----AND DE.SCRIP_CD = T.SCRIP_CD      
----AND DE.FROMNO = T.ORDER_NO  )  
  
      
----INSERT INTO [ANGELDEMAT].MSAJAG.DBO.DELTRANS      
----SELECT       
----SETT_NO,SETT_TYPE,REFNO=110,TCODE=SETT_NO,TRTYPE=904,PARTY_CODE,SCRIP_CD,SERIES='EQ',      
----QTY=SUM(TRADEQTY),      
----FROMNO=ORDER_NO,TONO=ORDER_NO,CERTNO='',FOLIONO=ORDER_NO,HOLDERNAME='ROLLOVER ADJUSTMENT',REASON='ROLLOVER ADJUSTMENT',      
----DRCR=(CASE WHEN SELL_BUY = 1 THEN 'D' ELSE 'C' END),      
----DELIVERED=(CASE WHEN SELL_BUY = 1 THEN 'D' ELSE '0' END),      
----ORGQTY=SUM(TRADEQTY),DPTYPE='',DPID='',CLTDPID='',BRANCHCD='HO',PARTIPANTCODE=MEMBERCODE,SLIPNO='0',BATCHNO='0',      
----ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',TRANSDATE=LEFT(SAUDA_DATE,11),FILLER1='0',FILLER2=1,      
----FILLER3='',BDPTYPE='NSDL',BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''      
----FROM NSESLBS.DBO.SETTLEMENT S, [ANGELDEMAT].MSAJAG.DBO.DELIVERYDP DP, OWNER      
----WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE         
----AND EXISTS (SELECT ORDER_NO FROM NSESLBS.DBO.TRD_SETT_POS_ROLL T      
----WHERE LEFT(S.SAUDA_DATE,11) = LEFT(T.SAUDA_DATE,11)      
----AND S.SCRIP_CD = T.SCRIP_CD      
----AND S.ORDER_NO = T.ORDER_NO)      
----AND DP.DPTYPE = 'NSDL'      
----AND DP.DESCRIPTION LIKE '%POOL%'      
----AND ACCOUNTTYPE = 'POOL'    
----AND TRADEQTY > 0        
----GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE, SCRIP_CD, SERIES, ORDER_NO, SELL_BUY, MEMBERCODE, DP.DPID, DP.DPCLTNO, LEFT(SAUDA_DATE,11)      
      
------INSERT INTO [AngelDemat].MSAJAG.DBO.DELTRANS      
------SELECT       
------SETT_NO,SETT_TYPE,REFNO=110,TCODE=SETT_NO,TRTYPE=906,PARTY_CODE='EXE',SCRIP_CD,SERIES='EQ',      
------QTY=SUM(TRADEQTY),      
------FROMNO=ORDER_NO,TONO=ORDER_NO,CERTNO='',FOLIONO=ORDER_NO,HOLDERNAME='ROLLOVER ADJUSTMENT',REASON='ROLLOVER ADJUSTMENT',      
------DRCR=(CASE WHEN SELL_BUY = 1 THEN 'C' ELSE 'D' END),      
------DELIVERED=(CASE WHEN SELL_BUY = 1 THEN '0' ELSE 'D' END),      
------ORGQTY=SUM(TRADEQTY),DPTYPE='',DPID='',CLTDPID='',BRANCHCD='HO',PARTIPANTCODE=MEMBERCODE,SLIPNO='0',BATCHNO='0',      
------ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',TRANSDATE=LEFT(SAUDA_DATE,11),FILLER1='0',FILLER2=1,      
------FILLER3='',BDPTYPE='NSDL',BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''      
------FROM NSESLBS.DBO.SETTLEMENT S, [AngelDemat].MSAJAG.DBO.DELIVERYDP DP, OWNER      
------WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE         
------AND EXISTS (SELECT ORDER_NO FROM NSESLBS.DBO.TRD_SETT_POS_ROLL T      
------WHERE LEFT(S.SAUDA_DATE,11) = LEFT(T.SAUDA_DATE,11)      
------AND S.SCRIP_CD = T.SCRIP_CD      
------AND S.ORDER_NO = T.ORDER_NO)      
------AND DP.DPTYPE = 'NSDL'      
------AND DP.DESCRIPTION LIKE '%POOL%'    
------AND ACCOUNTTYPE = 'POOL'      
------AND TRADEQTY > 0       
------GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE, SCRIP_CD, SERIES, ORDER_NO, SELL_BUY, MEMBERCODE, DP.DPID, DP.DPCLTNO, LEFT(SAUDA_DATE,11)      
  
------UPDATE [AngelDemat].MSAJAG.DBO.DELTRANS SET CERTNO = ISIN  
------FROM MSAJAG..MULTIISIN M  
------WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE         
------AND FILLER2 = 1  
------AND M.SCRIP_CD = MSAJAG.DBO.DELTRANS.SCRIP_CD  
------AND M.SERIES = MSAJAG.DBO.DELTRANS.SERIES      
------AND VALID = 1   
------AND CERTNO = ''  
------AND REASON='ROLLOVER ADJUSTMENT'  
  
----END

GO
