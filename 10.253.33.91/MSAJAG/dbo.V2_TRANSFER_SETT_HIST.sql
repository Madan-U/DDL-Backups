-- Object: PROCEDURE dbo.V2_TRANSFER_SETT_HIST
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC V2_TRANSFER_SETT_HIST(  
           @NOOFDAYS INT)  
  
AS  
  
  --EXEC V2_TRANSFER_SETT_HIST 15  
  SET NOCOUNT ON  
    
  IF @NOOFDAYS < 7  
    SET @NOOFDAYS = 7  
                      
  DECLARE  @FROMSETT VARCHAR(7),  
           @TOSETT   VARCHAR(7),  
           @SETTTYPE VARCHAR(2),  
           @TODATE   VARCHAR(11)  
                       
  SELECT @TODATE = MAX(START_DATE)  
  FROM   SETT_MST  
  WHERE  SETT_TYPE IN ('N','W', 'M', 'Z')  
         AND START_DATE <= LEFT(GETDATE() - @NOOFDAYS,11)  
                             
  SELECT @FROMSETT = '2000000'  
    
  SELECT @TOSETT = MAX(SETT_NO)  
  FROM   SETT_MST  
  WHERE  SETT_TYPE IN ('N','W', 'M', 'Z')    
         AND LEFT(START_DATE,11) = @TODATE  
                                     
  DECLARE  @SETT        CURSOR,  
           @SETT_NO     VARCHAR(7),  
           @SETT_TYPE   VARCHAR(7),  
           @SETT_COUNT  INT,  
           @INSERTCOUNT INT,  
           @DELETECOUNT   INT,  
           @SETT_COUNT_I  INT,  
           @INSERTCOUNT_I INT,  
           @DELETECOUNT_I INT  
                          
  SET @SETT = CURSOR FOR SELECT DISTINCT SETT_NO,  
                                         SETT_TYPE  
                         FROM   SETTLEMENT (NOLOCK)  
                         WHERE  SETT_NO BETWEEN @FROMSETT  
                                                AND @TOSETT  
                                AND SAUDA_DATE < @TODATE  
                         UNION   
                         SELECT DISTINCT SETT_NO,  
                                         SETT_TYPE  
                         FROM   ISETTLEMENT (NOLOCK)  
                         WHERE  SETT_NO BETWEEN @FROMSETT  
                                                AND @TOSETT  
                                AND SAUDA_DATE < @TODATE  
                         ORDER BY 1  
                                    
  OPEN @SETT  
    
  FETCH NEXT FROM @SETT  
  INTO @SETT_NO,  
       @SETT_TYPE  
         
  WHILE @@FETCH_STATUS = 0  
    BEGIN  
      SET @INSERTCOUNT = 0  
      SET @INSERTCOUNT_I = 0  
        
      SET @DELETECOUNT = 0  
      SET @DELETECOUNT_I = 0  
        
      SET @SETT_COUNT = 0  
      SET @SETT_COUNT_I = 0  
                          
      SELECT @SETT_COUNT = COUNT(1)  
      FROM   HISTORY  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
        
      SELECT @SETT_COUNT_I = COUNT(1)  
      FROM   IHISTORY  
      WHERE  SETT_NO = @SETT_NO  
             AND SETT_TYPE = @SETT_TYPE  
        
      IF @SETT_COUNT = 0  
        BEGIN  
          BEGIN TRAN  
            
          INSERT INTO HISTORY  
          SELECT CONTRACTNO,  
                 BILLNO,  
                 TRADE_NO,  
                 PARTY_CODE,  
                 SCRIP_CD,  
                 USER_ID,  
                 TRADEQTY,  
                 AUCTIONPART,  
                 MARKETTYPE,  
                 SERIES,  
                 ORDER_NO,  
                 MARKETRATE,  
                 SAUDA_DATE,  
                 TABLE_NO,  
                 LINE_NO,  
                 VAL_PERC,  
                 NORMAL,  
                 DAY_PUC,  
                 DAY_SALES,  
                 SETT_PURCH,  
                 SETT_SALES,  
                 SELL_BUY,  
                 SETTFLAG,  
                 BROKAPPLIED,  
                 NETRATE,  
                 AMOUNT,  
                 INS_CHRG,  
                 TURN_TAX,  
                 OTHER_CHRG,  
                 SEBI_TAX,  
                 BROKER_CHRG,  
                 SERVICE_TAX,  
                 TRADE_AMOUNT,  
                 BILLFLAG,  
                 SETT_NO,  
                 NBROKAPP,  
                 NSERTAX,  
                 N_NETRATE,  
                 SETT_TYPE,  
                 PARTIPANTCODE,  
                 STATUS,  
   PRO_CLI,  
                 CPID,  
                 INSTRUMENT,  
                 BOOKTYPE,  
                 BRANCH_ID,  
                 TMARK,  
                 SCHEME,   
                 DUMMY1,  
                 DUMMY2  
          FROM   SETTLEMENT  
          WHERE  SETT_NO = @SETT_NO  
                 AND SETT_TYPE = @SETT_TYPE  
            
          SET @INSERTCOUNT = @@ROWCOUNT  
            
          DELETE SETTLEMENT  
          WHERE  SETT_NO = @SETT_NO  
                 AND SETT_TYPE = @SETT_TYPE  
            
          SET @DELETECOUNT = @@ROWCOUNT  
                               
          COMMIT TRAN  
            
          INSERT INTO LOG_TRANSFER_SETT_HIST  
          VALUES     (@SETT_NO,  
                      @SETT_TYPE,  
                      'SUCCESS - DATA TRANSFERRED FROM SETTLEMENT TO HISTORY',  
                      @INSERTCOUNT,  
                      @DELETECOUNT,  
                      GETDATE())  
      END                          
        
      IF @SETT_COUNT_I = 0  
        BEGIN  
          BEGIN TRAN  
  
          INSERT INTO IHISTORY  
          SELECT CONTRACTNO,  
                 BILLNO,  
                 TRADE_NO,  
                 PARTY_CODE,  
                 SCRIP_CD,  
                 USER_ID,  
                 TRADEQTY,  
                 AUCTIONPART,  
                 MARKETTYPE,  
                 SERIES,  
                 ORDER_NO,  
                 MARKETRATE,  
                 SAUDA_DATE,  
                 TABLE_NO,  
                 LINE_NO,  
                 VAL_PERC,  
                 NORMAL,  
                 DAY_PUC,  
                 DAY_SALES,  
                 SETT_PURCH,  
                 SETT_SALES,  
                 SELL_BUY,  
                 SETTFLAG,  
                 BROKAPPLIED,  
                 NETRATE,  
                 AMOUNT,  
                 INS_CHRG,  
                 TURN_TAX,  
                 OTHER_CHRG,  
                 SEBI_TAX,  
                 BROKER_CHRG,  
                 SERVICE_TAX,  
                 TRADE_AMOUNT,  
                 BILLFLAG,  
                 SETT_NO,  
                 NBROKAPP,  
                 NSERTAX,  
                 N_NETRATE,  
                 SETT_TYPE,  
                 PARTIPANTCODE,  
                 STATUS,  
                 PRO_CLI,  
                 CPID,  
                 INSTRUMENT,  
                 BOOKTYPE,  
                 BRANCH_ID,  
                 TMARK,  
                 SCHEME,   
                 DUMMY1,  
                 DUMMY2  
          FROM   ISETTLEMENT  
          WHERE  SETT_NO = @SETT_NO  
                 AND SETT_TYPE = @SETT_TYPE  
            
          SET @INSERTCOUNT_I = @@ROWCOUNT  
            
          DELETE ISETTLEMENT  
          WHERE  SETT_NO = @SETT_NO  
                 AND SETT_TYPE = @SETT_TYPE  
            
          SET @DELETECOUNT_I = @@ROWCOUNT  
            
          COMMIT TRAN  
            
          INSERT INTO LOG_TRANSFER_SETT_HIST  
          VALUES     (@SETT_NO,  
                      @SETT_TYPE,  
                      'SUCCESS - DATA TRANSFERRED FROM ISETTLEMENT TO IHISTORY',  
                      @INSERTCOUNT_I,  
                      @DELETECOUNT_I,  
                      GETDATE())  
        END  
        
      IF @SETT_COUNT <> 0  
        BEGIN  
          INSERT INTO LOG_TRANSFER_SETT_HIST  
          VALUES     (@SETT_NO,  
                      @SETT_TYPE,  
                      'ERROR - PROCESS ABORTED AS DATA FOUND IN HISTORY',  
                      @INSERTCOUNT,  
                      @DELETECOUNT,  
                      GETDATE())  
        END  
        
      IF @SETT_COUNT_I <> 0  
        BEGIN  
          INSERT INTO LOG_TRANSFER_SETT_HIST  
          VALUES     (@SETT_NO,  
                      @SETT_TYPE,  
    'ERROR - PROCESS ABORTED AS DATA FOUND IN IHISTORY',  
                      @INSERTCOUNT_I,  
                      @DELETECOUNT_I,  
                      GETDATE())  
        END  
  
      FETCH NEXT FROM @SETT  
      INTO @SETT_NO,  
           @SETT_TYPE  
    END  
    
  CLOSE @SETT  
    
  DEALLOCATE @SETT

GO
