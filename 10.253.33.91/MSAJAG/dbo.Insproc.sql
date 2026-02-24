-- Object: PROCEDURE dbo.Insproc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Procedure [dbo].[Insproc]  @Settno  Varchar (7) , @Sett_Type Char(3)  As  
  
Exec Delpositionup  @Settno, @Sett_Type, '', ''    
Delete From Deliveryclt Where Sett_No = @Settno And Sett_Type =  @Sett_Type    
  
--Delete From Deliveryclt_Report Where Sett_No = @Settno And Sett_Type =  @Sett_Type    

If UPPER(LTRIM(RTRIM(@Sett_Type))) NOT IN ('W', 'Z') /* For Sett Type = 'C' Condition Is Different So This If Loop Is Required For All Other Settlement */  
Begin  
Insert Into Deliveryclt   
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Abs(Sum(Pqty)-Sum(Sqty)) 'Tradeqty', Inout = Case  
  When (Sum(Pqty)-Sum(Sqty)) > 0  
  Then  
  'O'  
    When (Sum(Pqty)-Sum(Sqty))< 0  
     Then   
  'I'  
    Else  
  'N'  
    End, 'Ho' , Partipantcode, ''  
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type   
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode  
Having Sum(Pqty) <> Sum(Sqty)  

update DELIVERYCLT 
set i_isin = m.isin 
from multiisin m
where DELIVERYCLT.SETT_NO = @SettnO
aND DELIVERYCLT.Sett_Type= @Sett_Type
aND m.scrip_cd = deliveryclt.scrip_Cd 
and m.series in ('eq','be','bz')
and deliveryclt.series in ('eq','be','bz')
and valid = 1 


update DELIVERYCLT 
set i_isin = m.isin 
from multiisin m
where DELIVERYCLT.SETT_NO = @SettnO
aND DELIVERYCLT.Sett_Type= @Sett_Type
aND m.scrip_cd = deliveryclt.scrip_Cd 
and m.series =  deliveryclt.series 
and valid = 1 

/*
update DELIVERYCLT 
set i_isin = m.isin 
from multiisin_new m, sett_mst s
where s.SETT_NO = @SettnO
aND s.Sett_Type= @Sett_Type
aND m.scrip_cd = deliveryclt.scrip_Cd 
and m.series =  deliveryclt.series 
and valid = 1 and s.sett_no = DeliveryClt.Sett_No
and s.sett_type = DeliveryClt.sett_type 
and Start_Date between EFF_FROM and EFF_TO
*/
 

--Insert Into DELIVERYCLT_REPORT   
--Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Abs(Sum(Pqty)-Sum(Sqty)) 'Tradeqty', Inout = Case  
--  When (Sum(Pqty)-Sum(Sqty)) > 0  
--  Then  
--  'O'  
--    When (Sum(Pqty)-Sum(Sqty))< 0  
--     Then   
--  'I'  
--    Else  
--  'N'  
--    End, 'Ho' , Partipantcode  ,''
--From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type   
--Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode  
--Having Sum(Pqty) <> Sum(Sqty)
  
End  
  
Else /* For Sett Type = 'C' Condition Cause In 'C' Settlement All The Trades Treated As Delivery Trades */  
Begin   
  
Insert Into Deliveryclt   
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Pqty) 'Tradeqty', Inout = 'O', 'Ho' , Partipantcode, ''  
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type   
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode  
Having Sum(Pqty) > 0  
  
Insert Into Deliveryclt   
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Sqty) 'Tradeqty', Inout = 'I', 'Ho' , Partipantcode, ''  
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type  
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode  
Having Sum(Sqty) > 0  
 
 
 update DELIVERYCLT 
set i_isin = m.isin 
from multiisin m
where DELIVERYCLT.SETT_NO = @SettnO
aND DELIVERYCLT.Sett_Type= @Sett_Type
aND m.scrip_cd = deliveryclt.scrip_Cd 
and m.series in ('eq','be','bz')
and deliveryclt.series in ('eq','be','bz')
and valid = 1 


update DELIVERYCLT 
set i_isin = m.isin 
from multiisin m
where DELIVERYCLT.SETT_NO = @SettnO
aND DELIVERYCLT.Sett_Type= @Sett_Type
aND m.scrip_cd = deliveryclt.scrip_Cd 
and m.series =  deliveryclt.series 
and valid = 1 


update DELIVERYCLT 
set i_isin = m.isin 
from multiisin_new m, sett_mst s
where s.SETT_NO = @SettnO
aND s.Sett_Type= @Sett_Type
aND m.scrip_cd = deliveryclt.scrip_Cd 
and m.series =  deliveryclt.series 
and valid = 1 and s.sett_no = DeliveryClt.Sett_No
and s.sett_type = DeliveryClt.sett_type 
and Start_Date between EFF_FROM and EFF_TO
and i_isin = ''

--Insert Into Deliveryclt_Report
--Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Pqty) 'Tradeqty', Inout = 'O', 'Ho' , Partipantcode ,'' 
--From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type   
--Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode 
--Having Sum(Pqty) > 0  
  
--Insert Into Deliveryclt_Report
--Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Sqty) 'Tradeqty', Inout = 'I', 'Ho' , Partipantcode ,''
--From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type  
--Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode  
--Having Sum(Sqty) > 0  

End

IF UPPER(LTRIM(RTRIM(@Sett_Type))) = 'L'    
BEGIN    
    
DELETE FROM DELTRANS     
WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE       
AND FILLER2 = 1 AND HOLDERNAME = 'ROLLOVER ADJUSTMENT'
AND FROMNO IN ( SELECT ORDER_NO FROM NSESLBS.DBO.TRD_SETT_POS_ROLL T    
WHERE LEFT(DELTRANS.TRANSDATE,11) = LEFT(T.SAUDA_DATE,11)    
AND DELTRANS.SCRIP_CD = T.SCRIP_CD    
AND DELTRANS.FROMNO = T.ORDER_NO  )
    
INSERT INTO DELTRANS    
SELECT     
SETT_NO,SETT_TYPE,REFNO=110,TCODE=SETT_NO,TRTYPE=904,PARTY_CODE,SCRIP_CD,SERIES='EQ',    
QTY=SUM(TRADEQTY),    
FROMNO=ORDER_NO,TONO=ORDER_NO,CERTNO='',FOLIONO=ORDER_NO,HOLDERNAME='ROLLOVER ADJUSTMENT',REASON='ROLLOVER ADJUSTMENT',    
DRCR=(CASE WHEN SELL_BUY = 1 THEN 'D' ELSE 'C' END),    
DELIVERED=(CASE WHEN SELL_BUY = 1 THEN 'D' ELSE '0' END),    
ORGQTY=SUM(TRADEQTY),DPTYPE='',DPID='',CLTDPID='',BRANCHCD='HO',PARTIPANTCODE=MEMBERCODE,SLIPNO='0',BATCHNO='0',    
ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',TRANSDATE=LEFT(SAUDA_DATE,11),FILLER1='0',FILLER2=1,    
FILLER3='',BDPTYPE='NSDL',BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''    
FROM NSESLBS.DBO.SETTLEMENT S, DELIVERYDP DP, OWNER    
WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE       
AND EXISTS (SELECT ORDER_NO FROM NSESLBS.DBO.TRD_SETT_POS_ROLL T    
WHERE LEFT(S.SAUDA_DATE,11) = LEFT(T.SAUDA_DATE,11)    
AND S.SCRIP_CD = T.SCRIP_CD    
AND S.ORDER_NO = T.ORDER_NO)    
AND DP.DPTYPE = 'NSDL'    
AND DP.DESCRIPTION LIKE '%POOL%'    
AND ACCOUNTTYPE = 'POOL'  
AND TRADEQTY > 0      
GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE, SCRIP_CD, SERIES, ORDER_NO, SELL_BUY, MEMBERCODE, DP.DPID, DP.DPCLTNO, LEFT(SAUDA_DATE,11)    
    
INSERT INTO DELTRANS    
SELECT     
SETT_NO,SETT_TYPE,REFNO=110,TCODE=SETT_NO,TRTYPE=906,PARTY_CODE='EXE',SCRIP_CD,SERIES='EQ',    
QTY=SUM(TRADEQTY),    
FROMNO=ORDER_NO,TONO=ORDER_NO,CERTNO='',FOLIONO=ORDER_NO,HOLDERNAME='ROLLOVER ADJUSTMENT',REASON='ROLLOVER ADJUSTMENT',    
DRCR=(CASE WHEN SELL_BUY = 1 THEN 'C' ELSE 'D' END),    
DELIVERED=(CASE WHEN SELL_BUY = 1 THEN '0' ELSE 'D' END),    
ORGQTY=SUM(TRADEQTY),DPTYPE='',DPID='',CLTDPID='',BRANCHCD='HO',PARTIPANTCODE=MEMBERCODE,SLIPNO='0',BATCHNO='0',    
ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',TRANSDATE=LEFT(SAUDA_DATE,11),FILLER1='0',FILLER2=1,    
FILLER3='',BDPTYPE='NSDL',BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''    
FROM NSESLBS.DBO.SETTLEMENT S, DELIVERYDP DP, OWNER    
WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE       
AND EXISTS (SELECT ORDER_NO FROM NSESLBS.DBO.TRD_SETT_POS_ROLL T    
WHERE LEFT(S.SAUDA_DATE,11) = LEFT(T.SAUDA_DATE,11)    
AND S.SCRIP_CD = T.SCRIP_CD    
AND S.ORDER_NO = T.ORDER_NO)    
AND DP.DPTYPE = 'NSDL'    
AND DP.DESCRIPTION LIKE '%POOL%'  
AND ACCOUNTTYPE = 'POOL'    
AND TRADEQTY > 0     
GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE, SCRIP_CD, SERIES, ORDER_NO, SELL_BUY, MEMBERCODE, DP.DPID, DP.DPCLTNO, LEFT(SAUDA_DATE,11)    

UPDATE DELTRANS SET CERTNO = ISIN
FROM MULTIISIN M
WHERE SETT_NO = @SETTNO AND SETT_TYPE =  @SETT_TYPE       
AND FILLER2 = 1
AND M.SCRIP_CD = DELTRANS.SCRIP_CD
AND M.SERIES = DELTRANS.SERIES    
AND VALID = 1 
AND CERTNO = ''
AND REASON='ROLLOVER ADJUSTMENT'

END


--delete from deliveryclt_report where sett_no = @settno and sett_Type =  @sett_type    

--insert into deliveryClt_report
--select * from deliveryClt where sett_no = @settno and sett_Type =  @sett_type

GO
