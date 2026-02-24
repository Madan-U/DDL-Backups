-- Object: PROCEDURE dbo.MARGIN_REPORT
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--EXEC MARGIN_REPORT 'MAR 22 2018'  
  
CREATE proc [dbo].[MARGIN_REPORT]  ( @SDATE DATETIME)   
AS  
  
  
  
CREATE TABLE #MARGIN (    
PARTY_CODE varchar(10) ,  
MARGINDATE VARCHAR(20) ,  
EXCHANGE varchar(10) ,  
SEGMENT varchar(10) ,   
LED_MARGIN_AMT MONEY ,  
NONCASH_AMT MONEY ,  
BGFD_AMT MONEY ,  
OTHER_MARGIN MONEY ,  
TOTAL_MARGIN_AVL MONEY ,  
INITIALMARGIN MONEY ,  
EXPOSURE_MARGIN MONEY ,  
TOTAL_MARGIN MONEY ,  
EXCESS_SHORTFALL MONEY ,  
ADD_MARGIN MONEY ,  
MARGIN_STATUS MONEY ,  
PARTYNAME VARCHAR(200) ,  
L_ADDRESS1 VARCHAR(200) ,  
L_ADDRESS2 VARCHAR(200) ,  
L_ADDRESS3 VARCHAR(200) ,  
L_CITY VARCHAR(200) ,  
L_ZIP VARCHAR(200) ,  
L_STATE VARCHAR(200) ,  
L_NATION VARCHAR(200) ,  
RES_PHONE VARCHAR(200) ,  
OFF_PHONE VARCHAR(200) ,  
EMAIL VARCHAR(200) ,  
PAN_GIR_NO VARCHAR(200) ,  
BRANCH_CD VARCHAR(200) ,  
SUB_BROKER VARCHAR(200) ,  
RPT_ORD VARCHAR(200) ,  
SCRIP_CD VARCHAR(20) ,  
SERIES VARCHAR(5) ,  
QTY NUMERIC(18,4) ,  
SEC_CLRATE NUMERIC(18,4) ,  
SEC_AMOUNT NUMERIC(18,4) ,  
SEC_HAIRCUT NUMERIC(18,4) ,  
SEC_FAMOUNT NUMERIC(18,4) ,  
BGNO VARCHAR(20) ,  
BG_AMOUNT NUMERIC(18,4) ,  
BG_EXPIRYDATE VARCHAR(20) ,  
FDRNO VARCHAR(20) ,  
FDR_AMOUNT NUMERIC(18,4) ,  
FDR_EXPIRYDATE VARCHAR(20) ,  
SCRIPNAME VARCHAR(100) ,  
ISIN VARCHAR(12) )  
  
INSERT INTO  #MARGIN  
  
EXEC MSAJAG.DBO.RPT_DAILYMARGINSTATEMENT_TEXT @SDATE ,'A00','AZZZZ','mum','mum','BRANCHGROUP','','zzzzzzzzzzz','broker','broker',1,0,'C','ALL'  
  
  
  
CREATE TABLE #MTF (  
PROCESSDATE VARCHAR(11) ,  
PARTY_CODE VARCHAR(10) ,  
LONG_NAME VARCHAR(100) ,  
SCRIP_NAME VARCHAR(100) ,  
SCRIP_CD VARCHAR(15) ,  
SERIES VARCHAR(10) ,  
BSECODE VARCHAR(15) ,  
ISIN VARCHAR(12) ,  
QTY NUMERIC(18,4) ,  
TRADE_VALUE NUMERIC(18,4) ,  
FUNDED_VALUE NUMERIC(18,4) ,  
CL_RATE NUMERIC(18,4) ,  
MARKET_VALUE NUMERIC(18,4) ,  
HAIRCUT NUMERIC(18,4) ,  
MARG_REQ NUMERIC(18,4) ,  
MTOM_LOSS NUMERIC(18,4) ,  
FIN_MARG_REQ NUMERIC(18,4) ,  
FLAG VARCHAR(20) ,  
MTFLEDBAL NUMERIC(18,4) ,  
TOT_FUND_AMT NUMERIC(18,4) ,  
TOT_MTOM_LOSS NUMERIC(18,4) ,  
TOT_MARG_REQ NUMERIC(18,4) ,  
TOT_FIN_MARG_REQ NUMERIC(18,4) ,  
TOT_MTFCASHCOLLATERAL NUMERIC(18,4) ,  
TOT_MTFCASHEQCOLLATERAL NUMERIC(18,4) ,  
TOT_MTFNONCASHCOLLATERAL NUMERIC(18,4) ,  
TOT_AVAL_COLL_MTF NUMERIC(18,4) ,  
TOT_EXCESS_SHORT NUMERIC(18,4) ,  
OPENDAY VARCHAR(20) ,  
FILENAME VARCHAR(200) ,  
COMPANYHEADER1 VARCHAR(MAX) ,  
COMPANYHEADER2 VARCHAR(MAX) ,  
COMPANYHEADER3 VARCHAR(MAX) ,  
COMPANYHEADER4 VARCHAR(MAX) ,  
COMPANYHEADER5 VARCHAR(MAX) ,  
COMPANYHEADER6 VARCHAR(MAX) ,  
COMPANYHEADER7 VARCHAR(MAX)   
)  
  
INSERT INTO #MTF  
EXEC MTFTRADE..RPT_CLIENT_SCRIP_DETAIL  @StatusId='broker', @StatusName='broker', @FROMCODE='A000', @TOCODE='AZZZZ', @sauda_date=@SDATE   
   
  
 --SELECT * FROM #MTF  
 --SELECT * FROM #MARGIN  
   
 -- SELECT DISTINCT PARTY_CODE,'2',CONVERT(VARCHAR,MTFLEDBAL) + '|' + CONVERT(VARCHAR,TOT_FUND_AMT)    
 -- +'|'+ CONVERT(VARCHAR,TOT_MTOM_LOSS)+'|'+ CONVERT(VARCHAR,TOT_MARG_REQ)+'|'+ CONVERT(VARCHAR,TOT_FIN_MARG_REQ)+'|'+ CONVERT(VARCHAR,TOT_MTFCASHCOLLATERAL)+'|'+   
 -- CONVERT(VARCHAR,TOT_MTFCASHEQCOLLATERAL) +'|'+CONVERT(VARCHAR,TOT_MTFNONCASHCOLLATERAL) +'|'+CONVERT(VARCHAR,TOT_AVAL_COLL_MTF)+'|'+ CONVERT(VARCHAR,TOT_EXCESS_SHORT)+'| MTF BALANCE'   
 -- FROM #MTF    
  
 --  SELECT PARTY_CODE,'3', ISIN+'-'+SCRIP_NAME+ '|' + CONVERT(VARCHAR,QTY)+ '|' + CONVERT(VARCHAR,TRADE_VALUE)+ '|' +   
 --  CONVERT(VARCHAR,FUNDED_VALUE)+ '|' + CONVERT(VARCHAR,CL_RATE)+ '|' +  
 --   CONVERT(VARCHAR,MARKET_VALUE)+ '|' + CONVERT(VARCHAR,HAIRCUT) + '|' + CONVERT(VARCHAR,MARG_REQ)+ '|' + CONVERT(VARCHAR,MTOM_LOSS)+ '|' + CONVERT(VARCHAR,FIN_MARG_REQ)+ '|' + FLAG+ '| MTF HOLDINGS'  
 --FROM #MTF   
  
  
  
 CREATE TABLE #FINAL   
 (PARTY_CODE VARCHAR(10),SORT_BY INT,TEXT_DATA VARCHAR(MAX))   
  
  
   
  
  
   
  
   INSERT INTO #FINAL  
  
 SELECT PARTY_CODE,'1',RTRIM(LTRIM(PARTY_CODE)) + '|'+EXCHANGE+ '|' + CONVERT(VARCHAR,LED_MARGIN_AMT)+ '|' +CONVERT(VARCHAR,NONCASH_AMT)+ '|' +CONVERT(VARCHAR,BGFD_AMT)+ '|' +CONVERT(VARCHAR,OTHER_MARGIN)  
 + '|' +CONVERT(VARCHAR,TOTAL_MARGIN_AVL)+ '|' +CONVERT(VARCHAR, INITIALMARGIN)+ '|' +CONVERT(VARCHAR,EXPOSURE_MARGIN)+ '|' +CONVERT(VARCHAR,TOTAL_MARGIN)+ '|'   
 +CONVERT(VARCHAR,EXCESS_SHORTFALL)+ '|' +CONVERT(VARCHAR, ADD_MARGIN)+ '|' +CONVERT(VARCHAR,MARGIN_STATUS) FROM  #MARGIN WHERE RPT_ORD ='1DET'  
  
  INSERT INTO #FINAL  
   SELECT DISTINCT PARTY_CODE,'2',PARTY_CODE + '|'+CONVERT(VARCHAR,MTFLEDBAL) + '|' + CONVERT(VARCHAR,TOT_FUND_AMT)    
  +'|'+ CONVERT(VARCHAR,TOT_MTOM_LOSS)+'|'+ CONVERT(VARCHAR,TOT_MARG_REQ)+'|'+ CONVERT(VARCHAR,TOT_FIN_MARG_REQ)+'|'+ CONVERT(VARCHAR,TOT_MTFCASHCOLLATERAL)+'|'+   
  CONVERT(VARCHAR,TOT_MTFCASHEQCOLLATERAL) +'|'+CONVERT(VARCHAR,TOT_MTFNONCASHCOLLATERAL) +'|'+CONVERT(VARCHAR,TOT_AVAL_COLL_MTF)+'|'+ CONVERT(VARCHAR,TOT_EXCESS_SHORT)+'| MTF BALANCE'   
  FROM #MTF    
  
    INSERT INTO #FINAL  
  SELECT PARTY_CODE,'3',PARTY_CODE+ '|'+ISIN+'-'+SCRIPNAME+ '|'+ CONVERT(VARCHAR,QTY) + '|'+ CONVERT(VARCHAR,SEC_CLRATE) + '|'+ CONVERT(VARCHAR,SEC_AMOUNT)+ '|'+  
   CONVERT(VARCHAR,SEC_HAIRCUT)+ '|'+ CONVERT(VARCHAR,SEC_FAMOUNT)+ '|'+EXCHANGE  
  FROM  #MARGIN WHERE RPT_ORD = '2SEC'  
  
    INSERT INTO #FINAL  
    SELECT PARTY_CODE,'4',PARTY_CODE+ '|'+ISIN+'-'+SCRIPNAME+ '|'+ CONVERT(VARCHAR,QTY) + '|'+ CONVERT(VARCHAR,SEC_CLRATE) + '|'+ CONVERT(VARCHAR,SEC_AMOUNT)+ '|'+  
   CONVERT(VARCHAR,SEC_HAIRCUT)+ '|'+ CONVERT(VARCHAR,SEC_FAMOUNT)+ '|'+'PLEDGE' FROM  #MARGIN WHERE RPT_ORD = '3PLD'  
  
      INSERT INTO #FINAL  
   SELECT PARTY_CODE,'5', PARTY_CODE + '|'+ISIN+'-'+SCRIP_NAME+ '|' + CONVERT(VARCHAR,QTY)+ '|' + CONVERT(VARCHAR,TRADE_VALUE)+ '|' +   
   CONVERT(VARCHAR,FUNDED_VALUE)+ '|' + CONVERT(VARCHAR,CL_RATE)+ '|' +  
    CONVERT(VARCHAR,MARKET_VALUE)+ '|' + CONVERT(VARCHAR,HAIRCUT) + '|' + CONVERT(VARCHAR,MARG_REQ)+ '|' + CONVERT(VARCHAR,MTOM_LOSS)+ '|' + CONVERT(VARCHAR,FIN_MARG_REQ)+ '|' + FLAG+ '| MTF HOLDINGS'  
 FROM #MTF   
  
 SELECT * FROM #FINAL order by PARTY_CODE,SORT_BY   
   
 insert into tbl_Margin(PARTY_CODE,SORT_BY,TEXT_DATA)  
 select * from #FINAL  
  
   
   DECLARE   @FILENAME_1      AS VARCHAR(100)  ,  @s1 VARCHAR(MAX) = ''            
   SET @FILENAME_1 ='Margin_File_' + CONVERT(VARCHAR, Getdate(),112) + '.txt'          
   --'ORU_File_' + CONVERT(VARCHAR, Getdate(),112) + '.txt'                                      
   SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
   SET @s1 = @s1 + 'bcp "select TEXT_DATA from [AngelNseCM].INHOUSE.dbo.tbl_Margin " queryout \\196.1.115.183\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                       
                         
   SET @s1 = @s1 + ''''                                                          
   EXEC(@s1)    
     
   select  @FILENAME_1 as 'MSG'    
    
  --      DECLARE @filename1 as varchar(100)  
  --      DECLARE @MESS AS VARCHAR(4000),@emailto as varchar(1000),@emailcc as varchar(1000),@emailbcc as varchar(1000),@sub as varchar(100)       
  --      DECLARE @BCPCOMMAND VARCHAR(250)              
  --DECLARE @FILENAME VARCHAR(250)       
  --declare @s1 as varchar(max)       
               
               
  ----SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'              
  --SET @FILENAME = 'I:\Adv_Chart_email\Margin_rpt'+replace(convert(varchar(25),getdate(),102),'.','')+replace(convert(varchar(25),getdate(),108),':','')+'.csv'                                                                     
  --SET @BCPCOMMAND = 'BCP "select TEXT_DATA from inhouse.dbo.tbl_Margin" QUERYOUT "'              
  --SET @BCPCOMMAND = @BCPCOMMAND + @filename1 + '" -c -t, -Sintranet -U -Pdd$$gnfDTVs244648ysjgZAcc'              
  --EXEC MASTER..XP_CMDSHELL @BCPCOMMAND                  
         
                                 
  --SET @MESS='Dear All,<br><Br>Please refer the attached NOC Bulk Upload file for the day.'                                      
  --SET @MESS=@MESS+'<BR>This is a System generated Message. Please do not Reply.<BR><BR>Regards,<br><Br>(In-house system)'         
  --set @sub ='Margin Report File '+replace(CONVERT(char(10),getdate(),103),'/','-')+''                                                                     
  -- --print @filename1                    
                          
  --DECLARE @s varchar(500)                      
  --SET @s = @filename1                 
                          
  --EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL                                  
  --@RECIPIENTS ='Prashant.patade@angelbroking.com;',                                  
  --@COPY_RECIPIENTS ='Prashant.patade@angelbroking.com;',--harshada.dsouza@angelbroking.com;neha.naiwar@angelbroking.com;akshay.mahadik@angelbroking.com',                              
  --@PROFILE_NAME = 'AngelBroking',                                  
  --@BODY_FORMAT ='HTML',                                  
  --@SUBJECT = @sub ,                                  
  --@FILE_ATTACHMENTS =@s,                                  
  --@BODY =@MESS        
    
   
  --truncate table tbl_Margin

GO
