-- Object: PROCEDURE dbo.V2_PROCESSEOD_T1Change_25022022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




--EXEC V2_PROCESSEOD '', 'SURESH', 'OCT 12 2020'



 Create PROC [dbo].[V2_PROCESSEOD_T1Change_25022022](      
           @PROCESSFLAG VARCHAR(15),      
           @UNAME       VARCHAR(50),      
        @PROCESSDATE VARCHAR(11))      
AS      
      
  IF @PROCESSDATE = ''       
   SELECT @PROCESSDATE = LEFT(GETDATE()-1,11)      
       
  DECLARE @NEWPROCESSDATE VARCHAR(11)      
      
  SELECT @NEWPROCESSDATE = isnull(LEFT(MIN(START_DATE),11),'JAN  1 2000') FROM SETT_MST      
  WHERE START_DATE > @PROCESSDATE + ' 23:59:59' AND SETT_TYPE IN ('N', 'W', 'A', 'X','H','T','BX','DX','TX')   
  --  WHERE START_DATE > @PROCESSDATE + ' 23:59:59' AND SETT_TYPE IN ('N', 'W', 'A', 'X','T','BX','DX','TX')    
      
      INSERT INTO V2_PROCESS_STATUS_LOG      
      SELECT EXCHANGE = 'NSE',      
                  SEGMENT = 'CAPITAL',      
                  BUSINESSDATE=LEFT(START_DATE,11),      
                  SETT_NO,      
                  SETT_TYPE,      
                  PROCESSNAME='EOD',      
                  FILENAME='',      
                  START_END_FLAG=1,      
                  PROCESSDATE=GETDATE(),      
                  PROCESSBY=@UNAME,      
                  MACHINEIP=''      
 FROM SETT_MST S      
 WHERE LEFT(START_DATE,11) = @NEWPROCESSDATE      
 AND NOT EXISTS (SELECT SETT_NO FROM V2_Business_Process B      
 WHERE S.SETT_NO = B.SETT_NO      
 AND S.SETT_TYPE = B.SETT_TYPE     
 AND LEFT(B.Business_Date,11) = @NEWPROCESSDATE )      
 AND S.SETT_TYPE IN ('N', 'W', 'A', 'X','H','T','BX','DX','AF','F','TX')  
 -- AND S.SETT_TYPE IN ('N', 'W', 'A', 'X','T','BX','DX','AF','F','TX')     
      
 INSERT INTO V2_Business_Process      
 SELECT Business_Date=LEFT(START_DATE,11),Sett_Type,Sett_No,Import_Trade=0,Billing=0,      
        VBB=0,STT=0,Valan=0,Contract=0,Posting=0,Open_Close=0,ProcessDate=GETDATE(),ProcessBy=@UNAME,      
        LastUpdateDate=GETDATE(),LastUpdateBy=@UNAME,MachineIP=''      
 FROM SETT_MST S      
 WHERE LEFT(START_DATE,11) = @NEWPROCESSDATE      
 AND NOT EXISTS (SELECT SETT_NO FROM V2_Business_Process B      
 WHERE S.SETT_NO = B.SETT_NO      
 AND S.SETT_TYPE = B.SETT_TYPE     
 AND LEFT(B.Business_Date,11) = @NEWPROCESSDATE )      
 AND S.SETT_TYPE IN ('N', 'W', 'A', 'X','H','T','BX','DX','AF','F','TX') 
 -- AND S.SETT_TYPE IN ('N', 'W', 'A', 'X','T','BX','DX','AF','F','TX')     
     
 INSERT INTO V2_PROCESS_STATUS_LOG    
     (EXCHANGE,    
      SEGMENT,    
      BUSINESSDATE,    
      SETT_NO,    
      SETT_TYPE,    
      PROCESSNAME,    
      FILENAME,    
      START_END_FLAG,    
      PROCESSDATE,    
      PROCESSBY,    
      MACHINEIP)    
SELECT      'NSE',    
      'CAPITAL',    
      @NEWPROCESSDATE,    
      SETT_NO,    
      SETT_TYPE,    
      'IMPORT TRADE',    
      '',    
      1,    
      GETDATE(),    
      @UNAME,    
      ''    
FROM V2_BUSINESS_PROCESS    
WHERE LEFT(BUSINESS_DATE,11) = @NEWPROCESSDATE    
AND SETT_TYPE IN ('A', 'X','AF')    
    
INSERT INTO V2_PROCESS_STATUS_LOG    
     (EXCHANGE,    
      SEGMENT,    
      BUSINESSDATE,    
      SETT_NO,    
      SETT_TYPE,    
      PROCESSNAME,    
      FILENAME,    
      START_END_FLAG,    
      PROCESSDATE,    
      PROCESSBY,    
      MACHINEIP)    
SELECT      'NSE',    
      'CAPITAL',    
      @NEWPROCESSDATE,    
      SETT_NO,    
      SETT_TYPE,    
      'IMPORT TRADE',    
      '',    
      2,    
      GETDATE(),    
      @UNAME,    
      ''    
FROM V2_BUSINESS_PROCESS    
WHERE LEFT(BUSINESS_DATE,11) = @NEWPROCESSDATE    
AND SETT_TYPE IN ('A', 'X','AF')    
    
UPDATE V2_BUSINESS_PROCESS      
SET    IMPORT_TRADE = IMPORT_TRADE + 1,    
     LASTUPDATEDATE = GETDATE(),      
     LASTUPDATEBY = @UNAME      
WHERE  LEFT(BUSINESS_DATE,11) = @NEWPROCESSDATE    
AND SETT_TYPE IN ('A', 'X','AF')

GO
