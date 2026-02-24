-- Object: PROCEDURE dbo.Angel_nri_data_lec_new_08mar2022
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--use inhouse                                  
--exec Angel_nri_data_lec_new '23/02/2022',2,0,'NSE'                                    
CREATE PROC Angel_nri_data_lec_new_08mar2022(@SDATE  AS VARCHAR(11),              
                                   @TYPE   AS INT,              
                                   @BANKID AS INT,              
                                   @SEG    AS VARCHAR(5))              
AS              
  BEGIN              
      SET NOCOUNT ON              
    --  DECLARE @SDATE AS VARCHAR(11),@TYPE AS VARCHAR(2),@BANKID AS INT,@SEG AS VARCHAR(5)                                                      
    --  SET @SDATE ='22/02/2022' SET @TYPE ='2' SET @BANKID =0 SET @SEG='NSE'                                                      
      SET @SDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @SDATE, 103))              
              
      DECLARE @SELL_BUY        AS CHAR(1),              
              @TRANS_AMOUNT    AS DECIMAL(18, 2),              
              @calculation     AS DECIMAL(18, 2),              
              @HEADER_TOTALAMT AS DECIMAL(18, 2),              
              @diffamt         AS DECIMAL(18, 2);              
              
      SELECT @SELL_BUY = CASE              
                           WHEN @TYPE = 1 THEN 'P'              
                           WHEN @TYPE = 2 THEN 'S'              
                         END              
              
      IF( @SEG = 'NSE' )              
        BEGIN              
            CREATE TABLE #NSE_HEADER              
              (              
                 EXCHANGE           VARCHAR(50),              
                 PARTY_CODE         VARCHAR(50),              
                 SAUDA_DATE         DATETIME,              
                 SELL_BUY           INT,              
                 CONTRACTNO         VARCHAR(50),              
                 SERVICE_TAX        DECIMAL(18, 4),              
                 EDUCESS            INT,              
                 EXCHAGE_LEVIES     DECIMAL(18, 4),              
                 STT                DECIMAL(18, 4),              
                 STAMPDUTY          DECIMAL(18, 4),              
                 MINBROKERAGE       DECIMAL(18, 4),              
                 OTHER_CHARGES      DECIMAL(18, 4),              
                 NO_OF_TRANSACTIONS INT,              
                 TOTALAMT           DECIMAL(18, 2)              
              ); -- drop table #NSE_HEADER                                  
              
            INSERT INTO #NSE_HEADER              
            EXEC MSAJAG.dbo.Nsenriheader              
              @SDATE,              
              @TYPE              
              
            UPDATE #NSE_HEADER              
                  SET    TOTALAMT = TOTALAMT * ( -1 )              
              
            CREATE TABLE #NSE_DETAILS              
              (              
                 EXCHANGE         VARCHAR(50),              
                 PARTY_CODE       VARCHAR(50),              
                 SAUDA_DATE       DATETIME,              
                 CONTRACTNO       VARCHAR(50),              
                 TRANSACTION_TYPE CHAR(1),              
                 ISIN             VARCHAR(50),              
                 qty              INT,              
                 Rate             DECIMAL(18, 6),              
                 BROK_PERSCRIP    DECIMAL(18, 2),              
                 TRANACTIONAMT    DECIMAL(18, 4),  
     Scripname    varchar(100)  
              );              
              
            INSERT INTO #NSE_DETAILS              
            EXEC MSAJAG.DBO.Nsenridetail_Test              
              @SDATE,              
              @TYPE              
              
            UPDATE #NSE_DETAILS              
                  SET    TRANACTIONAMT = TRANACTIONAMT * ( -1 )              
        END              
      ELSE              
        BEGIN              
            CREATE TABLE #BSE_HEADER              
              (             
                 EXCHANGE           VARCHAR(50),              
                 PARTY_CODE         VARCHAR(50),              
                 SAUDA_DATE         DATETIME,              
                SELL_BUY           INT,              
                 CONTRACTNO         VARCHAR(50),              
                 SERVICE_TAX        DECIMAL(18, 4),              
                 EDUCESS            INT,              
                 EXCHAGE_LEVIES     DECIMAL(18, 4),              
                 STT                DECIMAL(18, 4),              
                 STAMPDUTY          DECIMAL(18, 4),              
                 MINBROKERAGE       DECIMAL(18, 4),              
                 OTHER_CHARGES      DECIMAL(18, 4),              
                 NO_OF_TRANSACTIONS INT,              
                 TOTALAMT           DECIMAL(18, 2)              
              ); -- drop table #BSE_HEADER                                   
            INSERT INTO #BSE_HEADER              
            EXEC ANAND.BSEDB_AB.DBO.Bsenriheader              
                      @SDATE,              
                      @TYPE              
              
            UPDATE #BSE_HEADER              
                  SET    TOTALAMT = TOTALAMT * ( -1 )              
              
            CREATE TABLE #BSE_DETAILS              
              (              
                 EXCHANGE         VARCHAR(50),              
                 PARTY_CODE       VARCHAR(50),              
                 SAUDA_DATE       DATETIME,              
                 CONTRACTNO       VARCHAR(50),              
                 TRANSACTION_TYPE CHAR(1),              
                 ISIN             VARCHAR(50),              
                 qty              INT,              
                 Rate             DECIMAL(18, 6),              
                 BROK_PERSCRIP    DECIMAL(18, 2),              
                 TRANACTIONAMT    DECIMAL(18, 4),   
     Scripname    varchar(100)  
              ); -- drop table #BSE_DETAILS                                   
              
            INSERT INTO #BSE_DETAILS              
            EXEC ANAND.BSEDB_AB.DBO.Bsenridetail_Test              
              @SDATE,              
              @TYPE              
              
            UPDATE #BSE_DETAILS              
                  SET    TRANACTIONAMT = TRANACTIONAMT * ( -1 )              
        END              
              
       CREATE TABLE #TEMP1              
        (              
           FLDCOL VARCHAR(1000)              
        )  
  truncate table tbl_NRILec_temp  
  --create table tbl_NRILec_temp  
  -- (              
       --      FLDCOL VARCHAR(1000)              
       --   )  
              
      DECLARE @BSE AS INT              
      DECLARE @NSE AS INT              
              
      SELECT @BSE = Count(*)              
      FROM   MSAJAG.DBO.NRIBSE              
      WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              
      SELECT @NSE = Count(*)              
      FROM   MSAJAG.DBO.NRINSE              
      WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              
      IF @BSE = 0              
          OR @NSE = 0              
        BEGIN              
            SELECT DISTINCT FLD_CLIENTCODE              
            INTO   #ZRCLI              
            FROM   INTRANET.RISK.DBO.TBL_NRICLIENTMASTER B WITH (NOLOCK)              
              
            SELECT DISTINCT PARTY_CODE              
            INTO   #NRI_CLI              
            FROM   MSAJAG.DBO.CMBILLVALAN X WITH (NOLOCK)              
                   INNER JOIN #ZRCLI B WITH (NOLOCK)              
                     ON X.PARTY_CODE = B.FLD_CLIENTCODE              
            WHERE  SAUDA_DATE = CONVERT(DATETIME, @SDATE, 103) --AND PARTY_CODE LIKE 'ZR%'                               
            UNION                                                      
            SELECT DISTINCT PARTY_CODE             
            FROM   ANAND.BSEDB_AB.DBO.CMBILLVALAN X WITH (NOLOCK)              
                   INNER JOIN #ZRCLI B WITH (NOLOCK)              
                     ON X.PARTY_CODE = B.FLD_CLIENTCODE              
            WHERE  SAUDA_DATE = CONVERT(DATETIME, @SDATE, 103) --AND PARTY_CODE LIKE 'ZR%'                                                    
              
            IF @SEG = 'BSE'              
              BEGIN              
                  DELETE FROM MSAJAG.DBO.NRIBSE              
        WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              
         --INSERT INTO NRIBSE_test  
                  INSERT INTO MSAJAG.DBO.NRIBSE              
                  SELECT CONTRACTNO,              
                         PARTY_CODE,              
                         SCRIP_CD,              
                         TRADEQTY,              
                         SAUDA_DATE,              
                         SELL_BUY,              
                         NBROKAPP,              
                         INS_CHRG,              
                         TURN_TAX,              
                         OTHER_CHRG,              
                         SEBI_TAX,              
                         BROKER_CHRG,            
                         TRADE_AMOUNT,              
                         MARKETRATE,              
                         NSERTAX,              
                         N_NETRATE  
                  FROM   ANAND.BSEDB_AB.DBO.SETTLEMENT WITH (NOLOCK)              
                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE              
                                        FROM   #NRI_CLI)              
                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              
                  INSERT INTO MSAJAG.DBO.NRIBSE              
                  SELECT CONTRACTNO,              
                         PARTY_CODE,              
                         SCRIP_CD,              
                         TRADEQTY,              
                         SAUDA_DATE,              
                         SELL_BUY,              
                         NBROKAPP,              
                         INS_CHRG,              
                         TURN_TAX,              
                         OTHER_CHRG,              
                         SEBI_TAX,              
                         BROKER_CHRG,              
                         TRADE_AMOUNT,              
                         MARKETRATE,              
                         NSERTAX,              
                         N_NETRATE              
                  FROM   ANAND.BSEDB_AB.DBO.HISTORY WITH (NOLOCK)              
                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE              
                                        FROM   #NRI_CLI)              
                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              END              
              
            IF @SEG = 'NSE'              
              BEGIN              
                  DELETE FROM MSAJAG.DBO.NRINSE              
                  WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              
                  INSERT INTO MSAJAG.DBO.NRINSE              
                  SELECT CONTRACTNO,              
                         PARTY_CODE,              
                         SCRIP_CD,              
                         TRADEQTY,              
                         SAUDA_DATE,              
                         SELL_BUY,              
                         NBROKAPP,              
                         INS_CHRG,              
                         TURN_TAX,              
                         OTHER_CHRG,              
                         SEBI_TAX,              
                         BROKER_CHRG,              
                         TRADE_AMOUNT,              
             MARKETRATE,              
                         NSERTAX,              
                         N_NETRATE              
                  FROM   MSAJAG.DBO.SETTLEMENT(NOLOCK)              
                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE              
                                        FROM   #NRI_CLI)              
                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              
                  INSERT INTO MSAJAG.DBO.NRINSE              
                  SELECT CONTRACTNO,              
                         PARTY_CODE,              
                         SCRIP_CD,              
                         TRADEQTY,              
                         SAUDA_DATE,              
                         SELL_BUY,              
                         NBROKAPP,              
                         INS_CHRG,              
                         TURN_TAX,              
                         OTHER_CHRG,              
                         SEBI_TAX,              
                         BROKER_CHRG,              
                         TRADE_AMOUNT,              
                         MARKETRATE,              
                   NSERTAX,              
                         N_NETRATE              
                  FROM   MSAJAG.DBO.HISTORY(NOLOCK)              
                  WHERE  PARTY_CODE IN (SELECT PARTY_CODE              
                                        FROM   #NRI_CLI)              
                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
              END              
        END              
              
      SELECT DISTINCT PARTY_CODE              
      INTO   #CLIENTS              
      FROM   MSAJAG.DBO.NRIBSE WITH (NOLOCK)              
      WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
             AND SELL_BUY = @TYPE              
      UNION              
      SELECT DISTINCT PARTY_CODE              
      FROM   MSAJAG.DBO.NRINSE WITH (NOLOCK)              
      WHERE  CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
             AND SELL_BUY = @TYPE              
              
      IF @BANKID <> 0              
        BEGIN              
            SELECT #CLIENTS.PARTY_CODE,              
                   B.FLD_BANKID              
            INTO   #T              
            FROM   #CLIENTS,              
                   INTRANET.RISK.DBO.TBL_NRICLIENTMASTER B WITH (NOLOCK)              
            WHERE  #CLIENTS.PARTY_CODE = B.FLD_CLIENTCODE              
              
            DELETE FROM #CLIENTS              
            WHERE  PARTY_CODE IN (SELECT PARTY_CODE              
                                  FROM   #T              
                                  WHERE  FLD_BANKID <> @BANKID)              
        END              
              
      CREATE TABLE #TT              
        (              
           CNT        INT IDENTITY (1, 1),              
           PARTY_CODE VARCHAR(20)              
        )              
              
      INSERT INTO #TT              
      SELECT *              
      FROM   #CLIENTS              
              
      DECLARE @CNT INT              
              
      SELECT @CNT = Count(*)              
      FROM   #CLIENTS              
              
      WHILE @CNT > 0              
        BEGIN              
            DECLARE @TRANCNT   AS INT,              
                    @PARTYCODE AS VARCHAR(20)              
              
            SELECT @PARTYCODE = Ltrim(Rtrim(PARTY_CODE))              
            FROM   #TT              
            WHERE  @CNT = CNT              
              
            IF @SEG = 'BSE'              
              BEGIN              
                  SELECT @TRANCNT = Count(CONTRACTNO),              
                         @TRANS_AMOUNT = Sum(CONVERT(DECIMAL(14, 2), TRANACTIONAMT))              
                  FROM   #BSE_DETAILS            
                  WHERE  PARTY_CODE = @PARTYCODE              
                  GROUP  BY PARTY_CODE,              
                            Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),              
                            CONTRACTNO              
              
                 SELECT @CALCULATION = CONVERT(DECIMAL(14, 2), ( @TRANS_AMOUNT ) - ( SERVICE_TAX + EDUCESS + EXCHAGE_LEVIES + STT + STAMPDUTY + MINBROKERAGE + OTHER_CHARGES) )        
                 FROM   #BSE_HEADER WITH (NOLOCK)        
                 WHERE  PARTY_CODE = @PARTYCODE        
                  --PRINT'calculation'              
              
                  --PRINT @CALCULATION              
              
                  --GROUP  BY PARTY_CODE                                  
                  SELECT @HEADER_TOTALAMT = Sum(CONVERT(DECIMAL(14, 2), TOTALAMT))              
                  FROM   #BSE_HEADER              
                  WHERE  PARTY_CODE = @PARTYCODE              
                  GROUP  BY PARTY_CODE              
              
                  --PRINT 'Header Totalamt'              
              
                  --PRINT @HEADER_TOTALAMT              
              
                  --SELECT @DIFFAMT = Round(@HEADER_TOTALAMT, 2) - Round(@CALCULATION, 2)              
                  SELECT @DIFFAMT = Round(@CALCULATION, 2) - Round(@HEADER_TOTALAMT, 2)        
              
                  /*IF @TYPE = 1              
                    BEGIN              
                        SELECT @DIFFAMT = @DIFFAMT * ( 1 )              
                  END              
                  ELSE              
                   BEGIN              
                        SELECT @DIFFAMT = @DIFFAMT * ( -1 )              
                    END   */           
              
                  --select * from #TEMP1          
        
      DECLARE @SETT_NO VARCHAR(8)   
      declare @setdate as varchar(10)  
  
       SELECT @SETT_NO = SETT_NO,@setdate=Convert(varchar,Funds_Payin,112) FROM MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='N'    
        -- SELECT @SETT_NO = SETT_NO FROM  MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE IN('D','C')       
        
      --select top 1 @setdate =Sett_Date from Msajag.dbo.common_CONTRACT_DATA with(nolock) where sett_no=@SETT_NO  
      --set @setdate = substring(@setdate,7,4)+ substring(@setdate,4,2) +substring(@setdate,1,2)  
  
  
                  INSERT INTO #TEMP1              
                  SELECT 'H' + '|' + Ltrim(Rtrim(a.PARTY_CODE)) + '|'     
                  + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|'     
                  + CONVERT(VARCHAR, CONTRACTNO) + '|'     
                  + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|' + '0.00' + '|'     
                  + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(EXCHAGE_LEVIES, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STT, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STAMPDUTY, 0)))) + '|' +     
   
   
        CASE WHEN @diffamt BETWEEN -0.03 AND 0.03         
          THEN CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(CONVERT(DECIMAL(14, 2), Isnull(MINBROKERAGE, 0)) + CONVERT(DECIMAL(14, 2), Isnull(OTHER_CHARGES, 0))) + @diffamt )))              
          ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(Isnull(MINBROKERAGE, 0) + Isnull(OTHER_CHARGES, 0)) )))              
        END + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' +         
        CONVERT(VARCHAR, CONVERT(DECIMAL( 14, 2), Sum(TOTALAMT) )) +'|'+ b.DPid1+'|'+right(b.cltdpID1,8)+'|'+@SEG+'|'+   
   CASE   WHEN @TYPE = 1 THEN 'B'  WHEN @TYPE = 2 THEN 'S'  END + '|A|'+'T2'+'|'+@SETT_NO+'|'+@setdate               
                  FROM   #BSE_HEADER a WITH (NOLOCK)    
       left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code  
                  WHERE  SAUDA_DATE = @SDATE      
                         AND a.PARTY_CODE = @PARTYCODE              
                         AND SELL_BUY = @TYPE              
                  GROUP  BY a.PARTY_CODE,              
                            CONTRACTNO,              
                            Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') ,b.DPid1,right(b.cltdpID1,8)                 
              
                  INSERT INTO #TEMP1              
                  SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE              
                                                                                                         WHEN @TYPE = 1 THEN 'P'              
                                                                                                         WHEN @TYPE = 2 THEN 'S'              
                                                                                                       END + '|' + Ltrim(Rtrim(Isnull(ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, QTY))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), RATE)))
)  
    
      
        
        + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), BROK_PERSCRIP)))) + '|' +         
        Ltrim(Rtrim(CONVERT(DEC(10, 2), TRANACTIONAMT )))  +'|'+left(Scripname,75)            
                  FROM   #BSE_DETAILS X              
                  WHERE  X.PARTY_CODE = @PARTYCODE              
                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
                         AND Transaction_type = @SELL_BUY              
              END              
              
            ---- NSE                                                      
            IF @SEG = 'NSE'              
              BEGIN              
                  SELECT @TRANCNT = Count(CONTRACTNO)              
                  FROM   MSAJAG.DBO.NRINSE              
                  WHERE  PARTY_CODE = @PARTYCODE              
                         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE              
                         AND SELL_BUY = @TYPE              
                  GROUP  BY PARTY_CODE,              
                            Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),              
                            CONTRACTNO              
              
                  SELECT @TRANCNT = Count(CONTRACTNO),              
                  @TRANS_AMOUNT = Sum(CONVERT(DECIMAL(14, 2), TRANACTIONAMT))              
                  FROM   #NSE_DETAILS              
                  WHERE  PARTY_CODE = @PARTYCODE              
                  GROUP  BY PARTY_CODE,              
                            Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),              
                           CONTRACTNO              
              
                  -- as per formula add header's service tax + Education Cess + Exchange Levy + STT + Stamp Duty+ Others                                  
     SELECT @CALCULATION = CONVERT(DECIMAL(14, 2), ( @TRANS_AMOUNT ) - ( SERVICE_TAX + EDUCESS + EXCHAGE_LEVIES + STT + STAMPDUTY + MINBROKERAGE + OTHER_CHARGES) )        
                 FROM   #NSE_HEADER WITH (NOLOCK)        
                 WHERE  PARTY_CODE = @PARTYCODE        
          
                  --GROUP  BY PARTY_CODE                                  
                  --PRINT 'Final cal'                                   
                  --Print  @CALCULATION                                        
                  SELECT @HEADER_TOTALAMT = Sum(CONVERT(DECIMAL(14, 2), TOTALAMT))              
                  FROM   #NSE_HEADER              
               WHERE  PARTY_CODE = @PARTYCODE              
                  GROUP  BY PARTY_CODE              
              
                  --Print 'HEADER TOTALAMT'                                  
                  --Print @HEADER_TOTALAMT                                  
                  --SELECT @diffamt = Round(@HEADER_TOTALAMT, 2) - Round(@calculation, 2)              
                  SELECT @diffamt = Round(@calculation, 2) - Round(@HEADER_TOTALAMT, 2)        
              
                  --IF @TYPE = 1              
                  --  BEGIN              
                  --      SELECT @DIFFAMT = @DIFFAMT * ( 1 )              
                  --  END              
                  --ELSE              
                  --  BEGIN              
                  --      SELECT @DIFFAMT = @DIFFAMT * ( -1 )              
                  --  END              
              
                  --PRINT 'Diff amount'                                   
                  --Print  @diffamt                                   
                  --select * from #TEMP1  
        
      DECLARE @nseSETT_NO VARCHAR(8)   
      declare @nsesetdate as varchar(10)  
     SELECT @nseSETT_NO = SETT_NO,@nsesetdate=Convert(varchar,Funds_Payin,112) FROM MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='N'    
  
    --set  @nsesetdate =(select top 1 Sett_Date from Msajag.dbo.common_CONTRACT_DATA with(nolock) where sett_no=@nseSETT_NO)  
     --set @nsesetdate = substring(@nsesetdate,7,4)+ substring(@nsesetdate,4,2) +substring(@nsesetdate,1,2)  
  
  
                 INSERT INTO #TEMP1          
                 SELECT 'H' + '|' + Ltrim(Rtrim(a.PARTY_CODE)) + '|' + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|' + CONVERT(VARCHAR, CONTRACTNO) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|' + '0.
00'    
      + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(EXCHAGE_LEVIES, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STT, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STAMPDUTY, 0)))) + '|' +         
      CASE WHEN @diffamt BETWEEN -0.03 AND 0.03         
        THEN CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(CONVERT(DECIMAL(14, 2), Isnull(MINBROKERAGE, 0)) + CONVERT(DECIMAL(14, 2), Isnull(OTHER_CHARGES, 0))) + @diffamt )))          
        ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(Isnull(MINBROKERAGE, 0) + Isnull(OTHER_CHARGES, 0)) )))          
      END + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(TOTALAMT))) +'|'+ b.DPid1+'|'+right(b.cltdpID1,8)+'|'+@SEG+'|'+   
   CASE   WHEN @TYPE = 1 THEN 'B'  WHEN @TYPE = 2 THEN 'S'  END + '|A|'+'T2'+'|'+isnull(@nseSETT_NO,'')+'|'+isnull(@nsesetdate,'')     
  
                 FROM   #NSE_HEADER a WITH (NOLOCK)   
     left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code  
                 WHERE  SAUDA_DATE = @SDATE          
                        AND a.PARTY_CODE = @PARTYCODE          
                        AND SELL_BUY = @TYPE          
                 GROUP  BY a.PARTY_CODE,          
                           CONTRACTNO,          
                           Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),b.DPid1,right(b.cltdpID1,8)          
                           
                 INSERT INTO #TEMP1          
                 SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE          
                                                                                                        WHEN @TYPE = 1 THEN 'P'          
                                                                                                        WHEN @TYPE = 2 THEN 'S'          
                                                                                                      END + '|' + Ltrim(Rtrim(Isnull(ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, QTY))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), RATE)))) 
  
    
      
        
      + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), BROK_PERSCRIP)))) + '|' + Ltrim(Rtrim(CONVERT(DEC(10, 2), TRANACTIONAMT )))+'|'+left(Scripname,75)          
                 FROM   #NSE_DETAILS X          
                 WHERE  X.PARTY_CODE = @PARTYCODE           
                           
              END              
              
            SET @CNT=@CNT - 1              
        END              
              
      --SELECT *              
      --FROM   #TEMP1         
    
  insert into tbl_NRILec_temp  
  select * from #TEMP1  
  
  
  if ((select count(1) from tbl_NRILec_temp) >0)  
    Begin  
     declare @BCPCOMMAND1 as varchar(1000)  
     DECLARE @filename2 as varchar(200)  
     declare @Ftype as varchar(100)           
     
    set @Ftype=  CASE   WHEN @TYPE = 1 THEN 'Buy'  WHEN @TYPE = 2 THEN 'Sell'  END+'_'+@SEG                  
    SET @FILENAME2 = '\\196.1.115.147\upload1\NRI_CLients\TEST_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                                                                                             
    --SET @FILENAME = '\\196.1.115.182\upload1\OmnesysFileFormat\CodeCreationFileFormat'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                  
                                         
                                
    SET @BCPCOMMAND1 = 'BCP "select * from Inhouse.dbo.tbl_NRILec_temp" QUERYOUT "'                              
   -- print(@BCPCOMMAND1)                        
    SET @BCPCOMMAND1 = @BCPCOMMAND1 + @FILENAME2 + '" -c -t, -S196.1.115.196 -Uinhouse -Pinh6014'                                    
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1               
  
  
    select '<a href='+replace(@FILENAME2,'\\196.1.115.147','')+'>Right click and save</a>'  
        End  
      Else  
    Begin  
         select 'No Records found'  
    End  
              
      SET NOCOUNT OFF              
  END

GO
