-- Object: PROCEDURE dbo.V2_PROCESSCLOSE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE  PROC V2_PROCESSCLOSE(
           @PROCESSFLAG VARCHAR(15),
           @UNAME       VARCHAR(50),
           @SETT_NO     VARCHAR(7),
           @SETT_TYPE   VARCHAR(2),
           @PROCESSDATE VARCHAR(11))
AS

    
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
  VALUES     ('NSE',
              'CAPITAL',
              @PROCESSDATE,
              @SETT_NO,
              @SETT_TYPE,
              @PROCESSFLAG,
              '',
              1,
              GETDATE(),
              @UNAME,
              '')
  
      UPDATE V2_BUSINESS_PROCESS
      SET    OPEN_CLOSE = 1,
             LASTUPDATEDATE = GETDATE(),
             LASTUPDATEBY = @UNAME
      WHERE  SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE 
	     AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE

    
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
  VALUES     ('NSE',
              'CAPITAL',
              @PROCESSDATE,
              @SETT_NO,
              @SETT_TYPE,
              @PROCESSFLAG,
              '',
              2,
              GETDATE(),
              @UNAME,
              '')

GO
