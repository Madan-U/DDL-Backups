-- Object: PROCEDURE dbo.V2_PROCESSEOD_old
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


 CREATE PROC V2_PROCESSEOD_old(  
           @PROCESSFLAG VARCHAR(15),  
           @UNAME       VARCHAR(50),  
           @PROCESSDATE VARCHAR(11))  
AS  
  
  IF @PROCESSDATE = ''  
    SELECT @PROCESSDATE = LEFT(GETDATE(),11)  
                            
  DECLARE  @NEWPROCESSDATE VARCHAR(11)  
                             
  SELECT @NEWPROCESSDATE = ISNULL(LEFT(MIN(START_DATE),11),'JAN  1 2000')  
  FROM   SETT_MST  
  WHERE  START_DATE > @PROCESSDATE + ' 23:59:59'  
         AND SETT_TYPE IN ('N','W','A','X')  
                            
  INSERT INTO V2_PROCESS_STATUS_LOG  
  SELECT EXCHANGE = 'NSE',  
         SEGMENT = 'CAPITAL',  
         BUSINESSDATE = LEFT(START_DATE,11),  
         SETT_NO,  
         SETT_TYPE,  
         PROCESSNAME = 'EOD',  
         FILENAME = '',  
         START_END_FLAG = 1,  
         PROCESSDATE = GETDATE(),  
         PROCESSBY = @UNAME,  
         MACHINEIP = ''  
  FROM   SETT_MST S  
  WHERE  LEFT(START_DATE,11) = @NEWPROCESSDATE  
         AND NOT EXISTS (SELECT SETT_NO  
                         FROM   V2_BUSINESS_PROCESS B  
                         WHERE  S.SETT_NO = B.SETT_NO  
                                AND S.SETT_TYPE = B.SETT_TYPE  
                                AND LEFT(B.BUSINESS_DATE,11) = @NEWPROCESSDATE)  
         AND S.SETT_TYPE IN ('N','W','A','X')  
                              
  INSERT INTO V2_BUSINESS_PROCESS  
  SELECT BUSINESS_DATE = LEFT(START_DATE,11),  
         SETT_TYPE,  
         SETT_NO,  
         IMPORT_TRADE = 0,  
         BILLING = 0,  
         VBB = 0,  
         STT = 0,  
         VALAN = 0,  
         CONTRACT = 0,  
         POSTING = 0,  
         OPEN_CLOSE = 0,  
         PROCESSDATE = GETDATE(),  
         PROCESSBY = @UNAME,  
         LASTUPDATEDATE = GETDATE(),  
         LASTUPDATEBY = @UNAME,  
         MACHINEIP = ''  
  FROM   SETT_MST S  
  WHERE  LEFT(START_DATE,11) = @NEWPROCESSDATE  
         AND NOT EXISTS (SELECT SETT_NO  
                         FROM   V2_BUSINESS_PROCESS B  
                         WHERE  S.SETT_NO = B.SETT_NO  
                                AND S.SETT_TYPE = B.SETT_TYPE  
                                AND LEFT(B.BUSINESS_DATE,11) = @NEWPROCESSDATE)  
         AND S.SETT_TYPE IN ('N','W','A','X')

GO
