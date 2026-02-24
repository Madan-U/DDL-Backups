-- Object: PROCEDURE dbo.Angel_nri_data_lec_new_23aug2022
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--use 196-- inhouse                                    
--exec Angel_nri_data_lec_new '06/06/2022',1,0,'NSE'                                      
create PROC [dbo].[Angel_nri_data_lec_new_23aug2022](@SDATE  AS VARCHAR(11),                
                                   @TYPE   AS INT,                
                                   @BANKID AS INT,                
                                   @SEG    AS VARCHAR(5))                
AS                
  BEGIN                
      SET NOCOUNT ON                
    --  DECLARE @SDATE AS VARCHAR(11),@TYPE AS VARCHAR(2),@BANKID AS INT,@SEG AS VARCHAR(5)                                                        
   --   SET @SDATE ='10/05/2022' SET @TYPE ='2' SET @BANKID =0 SET @SEG='NSE'                                                        
      SET @SDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @SDATE, 103))            
       
   create table #output ([output] varchar(200))    
       
  insert into #output    
     Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'      
      
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
                 TOTALAMT           DECIMAL(18, 2),         
     SETT_NO            varchar(10)    
              ); -- drop table #NSE_HEADER                                    
                
            INSERT INTO #NSE_HEADER                
            EXEC MSAJAG.dbo.Nsenriheader_T1                
              @SDATE,                
              @TYPE                
                
            --UPDATE #NSE_HEADER                
            --      SET    TOTALAMT = TOTALAMT * ( -1 )                
            
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
     Scripname    varchar(100),    
     scripcode    varchar(100),    
     SETT_NO         varchar(10),    
     TRATE           DECIMAL(18, 6),    
     OtherCharges    DECIMAL(18, 6),    
     NseStt          DECIMAL(18, 6)    
              );                
                
            INSERT INTO #NSE_DETAILS                
  EXEC MSAJAG.DBO.Nsenridetail_T1                
              @SDATE,                
              @TYPE                
                
            --UPDATE #NSE_DETAILS                
            --      SET    TRANACTIONAMT = TRANACTIONAMT * ( -1 )                
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
                 TOTALAMT           DECIMAL(18, 2),     
     SETT_NO            varchar(10)    
              ); -- drop table #BSE_HEADER                                     
            INSERT INTO #BSE_HEADER                
            EXEC ANAND.BSEDB_AB.DBO.Bsenriheader_T1                
                      @SDATE,                
                      @TYPE                
                
            --UPDATE #BSE_HEADER                
            --      SET    TOTALAMT = TOTALAMT * ( -1 )                
                
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
     Scripname    varchar(100),    
     scripcode    varchar(100),    
     SETT_NO         varchar(10),    
     TRATE           DECIMAL(18, 6),    
     OtherCharges     DECIMAL(18, 6),    
     BseStt           DECIMAL(18, 6)    
              ); -- drop table #BSE_DETAILS                                     
                
            INSERT INTO #BSE_DETAILS                
            EXEC ANAND.BSEDB_AB.DBO.Bsenridetail_T1               
              @SDATE,                
              @TYPE                
                
            --UPDATE #BSE_DETAILS                
            --      SET    TRANACTIONAMT = TRANACTIONAMT * ( -1 )                
        END                
                
       CREATE TABLE #TEMP1                
        (                
           FLDCOL VARCHAR(1000) ,    
     BankName varchar(100)    
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
      declare @setdate as varchar(10) ,@Bsesetdate_t1 as varchar(10)          
       declare @bseBank as varchar(50),@BsecliBankBranch as varchar(100),@BseCliBnkAcc as varchar(50),@BseangelAcc as varchar(50),@BseCliPISNo as varchar(50)    
       SELECT @SETT_NO = SETT_NO,@setdate=Convert(varchar,Funds_Payin,112) FROM MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='N'      
        SELECT @Bsesetdate_t1=Convert(varchar,Funds_Payin,112) FROM MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='M'  
    -- SELECT @SETT_NO = SETT_NO FROM  MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE IN('D','C')         
          
      --select top 1 @setdate =Sett_Date from Msajag.dbo.common_CONTRACT_DATA with(nolock) where sett_no=@SETT_NO    
      --set @setdate = substring(@setdate,7,4)+ substring(@setdate,4,2) +substring(@setdate,1,2)    
    
     --  select @bseBank=fld_bankName from Intranet.risk.dbo.V_NriBank_Details with (nolock) where fld_clientcode = @PARTYCODE    
       select @bseBank=fld_bankName,@BsecliBankBranch=Fld_branchlocation,@BseangelAcc=Fld_AngelAcc from Intranet.risk.dbo.V_NriBank_Details with (nolock) where fld_clientcode = @PARTYCODE    
           
      Begin Try    
     drop table #settno    
   End Try    
   Begin catch    
   End catch    
     select Row_number() over (order by sett_no) Srno,Sett_no into #settno from #BSE_HEADER where party_code=@PARTYCODE    
  group by Sett_no    
    
  declare @rw as int=1    
  declare @max as int    
  select @max=max(Srno) from #settno    
  declare @bseSETT_NO as varchar(10)    
    
  while (@rw<=@max)    
  Begin    
  select @bseSETT_NO=Sett_no from #settno where Srno=@rw    
      if(@bseBank like '%AXIS%' or @bseBank like '%INDUSIND%' or @bseBank like '%IDFC%')    
   Begin    
       
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
     CASE   WHEN @TYPE = 1 THEN 'B'  WHEN @TYPE = 2 THEN 'S'  END + '|A|'+CASE WHEN (@TYPE = 2 and right(@bseSETT_NO,3)<500) THEN 'T2' else 'T1'end+'|'+@bseSETT_NO+'|'+ CASE   WHEN @TYPE = 1 THEN isnull(@Bsesetdate_t1,'')  else   
  case when ( right(@bseSETT_NO,3)<500) then @setdate else isnull(@Bsesetdate_t1,'') End END ,@bseBank                
        FROM   #BSE_HEADER a WITH (NOLOCK)      
         left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code    
        WHERE  SAUDA_DATE = @SDATE                
         AND a.PARTY_CODE = @PARTYCODE     
         and a.Sett_no=@bseSETT_NO    
         AND SELL_BUY = @TYPE                
        GROUP  BY a.PARTY_CODE,                
         CONTRACTNO,                
         Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') ,b.DPid1,right(b.cltdpID1,8),a.sauda_date                   
                
        INSERT INTO #TEMP1                
        SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE                
                             WHEN @TYPE = 1 THEN 'P'                
                             WHEN @TYPE = 2 THEN 'S'                
                              END + '|' + Ltrim(Rtrim(Isnull(ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, QTY))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), TRATE))))    
      
        
          
    + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), BROK_PERSCRIP)))) + '|' +           
    Ltrim(Rtrim(CONVERT(DEC(10, 2), TRANACTIONAMT )))  +'|'+left(Scripname,75) ,@bseBank             
        FROM   #BSE_DETAILS X                
        WHERE  X.PARTY_CODE = @PARTYCODE                
         AND CONVERT(DATETIME, CONVERT(VARCHAR(11), SAUDA_DATE)) = @SDATE                
         AND Transaction_type = @SELL_BUY      
         and X.Sett_no=@bseSETT_NO        
          
    End      
    else if(@bseBank like '%HDFC%' or @bseBank like '%IDBI%' or @bseBank like '%YES%')    
         BEGIN    
    
    declare @BseTotalAmt as money    
    declare @rbi_refno varchar(50)    
    select @BseTotalAmt=(sum(TRANACTIONAMT)) from #BSE_DETAILS where party_code =@PARTYCODE    
    
    select @BseCliPISNo= case when (isnull(fld_ClientPISac,'0')='0') then FLD_NROPISNO  else fld_ClientPISac end,    
    @BseCliBnkAcc= case when (isnull(fld_NREAcNO,'0')='0') then FLD_NROAcNO  else fld_NREAcNO end,    
    @rbi_refno=rbi_refno    
    from Intranet.risk.dbo.tbl_NRIClientMaster with (nolock)  where fld_clientcode = @PARTYCODE    
    
     INSERT INTO #TEMP1      
     --declare @bseBank as varchar(20)='jdfc',@PARTYCODE as varchar(20)='ZR1101N',@seg as varchar(20)='NSE',@SETT_NO as varchar(20)='1122321',@TYPE as varchar(20)='1',@diffamt as numeric='0.01',@BsecliBankBranch as varchar(100),@BseCliBnkAcc as varchar(50),@BseangelAcc as varchar(50)    
      --select @bseBank=fld_bankName,@BsecliBankBranch=Fld_branchlocation,@BseCliBnkAcc=fld_ClientPISac,@BseangelAcc=Fld_AngelAcc from Intranet.risk.dbo.V_NriBank_Details with (nolock) where fld_clientcode = @PARTYCODE    
         
     select @bseBank+','+Convert(varchar,a.SAUDA_DATE,103)+','+@PARTYCODE+','+b.DPid1 +','+cast(right(b.cltdpID1,8) as varchar) +','+b.Short_Name +','+@SEG +','+isnull(@bseSETT_NO,'') +','+    
     CONVERT(VARCHAR,a.CONTRACTNO)+','+ltrim(rtrim(c.scripcode))+','+Ltrim(Rtrim(Isnull(c.ISIN,'')))+','+    
     left(c.Scripname,75)+','+CASE WHEN @TYPE = 1 THEN 'Buy'  WHEN @TYPE = 2 THEN 'Sell'  END +','+Ltrim(Rtrim(CONVERT(VARCHAR,c.QTY))) +','+ Convert(Varchar,c.RATE)+','+cast((CONVERT(DEC(15,2),c.TRATE) *c.QTY) as varchar)  +','+    
     Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(15,2), c.TRATE)))) +','+Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(10,2), c.BROK_PERSCRIP))))+','+    
     --CASE WHEN @DIFFAMT BETWEEN -0.03 AND 0.03           
     -- THEN CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),( Sum(CONVERT(DECIMAL(14,2),Isnull(MINBROKERAGE,0)) + CONVERT(DECIMAL(14,2),Isnull(OTHER_CHARGES,0))) + @DIFFAMT )))            
     -- ELSE CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),( Sum(Isnull(MINBROKERAGE,0) + Isnull(OTHER_CHARGES,0)) )))            
     --  END +','+  --Other Charges end+','+    
         CONVERT(VARCHAR,Isnull(c.OTHERCHARGES,0))+','+    
     cast(Ltrim(Rtrim(CONVERT(DEC(10,2),c.TRANACTIONAMT))) as varchar)+','+ CONVERT(VARCHAR,CONVERT(DECIMAL(14, 2),Sum(Isnull(c.BseSTT, 0))))+','+    
     Convert(Varchar,CONVERT(DECIMAL(14,2),a.TOTALAMT))+','+isnull(@rbi_refno,'')+','+@BseCliPISNo+','+@BseCliBnkAcc+','+@BsecliBankBranch+','+'Angel One Ltd'+','+CASE WHEN @TYPE = 1 THEN  Convert(varchar,(a.sauda_date +1),103)  WHEN @TYPE = 2 THEN Convert(varchar,(a.sauda_date+2),103)  END +','+    
     CASE WHEN @TYPE = 1 THEN  Convert(varchar,(a.sauda_date +1),103)  WHEN @TYPE = 2 THEN Convert(varchar,(a.sauda_date+2),103)  END+','+@BseangelAcc,@BseBank    
     from #BSE_HEADER a         
     left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code     
     left outer join #BSE_DETAILS c on a.party_code=c.party_code    
     where a.party_code= @PARTYCODE and a.SETT_NO=@bseSETT_NO and c.SETT_NO=@bseSETT_NO    
     group by    
     a.SAUDA_DATE ,b.DPid1 ,right(b.cltdpID1,8) ,b.Short_Name ,    
     CONVERT(VARCHAR, a.CONTRACTNO) ,Ltrim(Rtrim(Isnull(c.ISIN, ''))),    
     left(c.Scripname,75) ,Ltrim(Rtrim(CONVERT(VARCHAR, c.QTY))) ,Ltrim(Rtrim(CONVERT(DEC(10, 2), c.TRANACTIONAMT ))),c.scripcode,    
     Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), c.RATE)))),Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), c.BROK_PERSCRIP)))),    
     c.QTY, Convert(Varchar,c.RATE),c.TRATE,c.RATE, Isnull(c.OTHERCHARGES,0),a.TOTALAMT    
    
   End    
    
   set @rw=@rw+1    
  END    
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
    --  print(@PARTYCODE)    
      DECLARE @nseSETT_NO VARCHAR(8)    
      declare @nsesetdate as varchar(10),@nsesetdate_t1 as varchar(10)      
      declare @nseBank as varchar(50),@cliBankBranch as varchar(100),@CliBnkAcc as varchar(50),@angelAcc as varchar(50),@CliPISNo as varchar(20)    
     SELECT @nseSETT_NO = SETT_NO,@nsesetdate=Convert(varchar,Funds_Payin,112) FROM MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='N'  
   SELECT @nsesetdate_t1=Convert(varchar,Funds_Payin,112) FROM MSAJag.dbo.SETT_MST WHERE START_DATE LIKE @SDATE+'%'  AND SETT_TYPE ='M'  
   Begin Try    
     drop table #NSEsettno    
   End Try    
   Begin catch    
   End catch    
  select Row_number() over (order by sett_no) Srno, Sett_NO into #NSEsettno from #NSE_HEADER where party_code=@PARTYCODE    
  group by Sett_no    
  declare @nserw as int=1    
  declare @nsemax as int    
  declare @nseSett_no2 as varchar(10)    
  select @nsemax=max(Srno) from #NSEsettno    
    -- select settno from #NSE_HEADER where party_code=@PARTYCODE    
    
    --set  @nsesetdate =(select top 1 Sett_Date from Msajag.dbo.common_CONTRACT_DATA with(nolock) where sett_no=@nseSETT_NO)    
     --set @nsesetdate = substring(@nsesetdate,7,4)+ substring(@nsesetdate,4,2) +substring(@nsesetdate,1,2)    
    
     select @nseBank=fld_bankName,@cliBankBranch=Fld_branchlocation,@angelAcc=Fld_AngelAcc from Intranet.risk.dbo.V_NriBank_Details with (nolock) where fld_clientcode = @PARTYCODE    
        
      while (@nserw<=@nsemax)    
   Begin    
   select @nseSett_no2=Sett_no from #NSEsettno where Srno=@nserw    
       
      if(@nseBank like '%AXIS%' or @nseBank like '%INDUSIND%' or @nseBank like '%IDFC%')    
   Begin    
       
       
       INSERT INTO #TEMP1            
       SELECT 'H' + '|' + Ltrim(Rtrim(a.PARTY_CODE)) + '|' + Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', '') + '|' + CONVERT(VARCHAR, CONTRACTNO) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(SERVICE_TAX, 0)))) + '|' + '0.00'      
     + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(EXCHAGE_LEVIES, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STT, 0)))) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(Isnull(STAMPDUTY, 0)))) + '|' +           
     CASE WHEN @diffamt BETWEEN -0.03 AND 0.03           
    THEN CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(CONVERT(DECIMAL(14, 2), Isnull(MINBROKERAGE, 0)) + CONVERT(DECIMAL(14, 2), Isnull(OTHER_CHARGES, 0))) + @diffamt )))            
    ELSE CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), ( Sum(Isnull(MINBROKERAGE, 0) + Isnull(OTHER_CHARGES, 0)) )))            
     END + '|' + CONVERT(VARCHAR, @TRANCNT) + '|' + CONVERT(VARCHAR, CONVERT(DECIMAL(14, 2), Sum(TOTALAMT))) +'|'+ b.DPid1+'|'+right(b.cltdpID1,8)+'|'+@SEG+'|'+     
     CASE   WHEN @TYPE = 1 THEN 'B'  WHEN @TYPE = 2 THEN 'S'  END + '|A|'+CASE WHEN (@TYPE = 2 and right(@nseSett_no2,3)<500 )THEN 'T2' else 'T1'end+'|'+isnull(@nseSett_no2,'')+'|'+ CASE   WHEN @TYPE = 1 THEN isnull(@nsesetdate_t1,'') else   
  case when (right(@nseSett_no2,3)<500 ) then isnull(@nsesetdate,'') else isnull(@nsesetdate_t1,'') END End ,@nseBank      
    
       FROM   #NSE_HEADER a WITH (NOLOCK)     
       left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code           
       WHERE  SAUDA_DATE = @SDATE            
        AND a.PARTY_CODE = @PARTYCODE        
        And a.Sett_no=@nseSett_no2    
        AND SELL_BUY = @TYPE            
       GROUP  BY a.PARTY_CODE,            
           CONTRACTNO,            
           Replace(CONVERT(VARCHAR(11), SAUDA_DATE, 102), '.', ''),b.DPid1,right(b.cltdpID1,8)            
                             
       INSERT INTO #TEMP1            
       SELECT 'T' + '|' + Ltrim(Rtrim(PARTY_CODE)) + '|' + Ltrim(Rtrim(CONTRACTNO)) + '|' + CASE            
                            WHEN @TYPE = 1 THEN 'P'            
                            WHEN @TYPE = 2 THEN 'S'            
                             END + '|' + Ltrim(Rtrim(Isnull(ISIN, ''))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, QTY))) + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), TRATE))))     
      
        
          
     + '|' + Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), BROK_PERSCRIP)))) + '|' + Ltrim(Rtrim(CONVERT(DEC(10, 2), TRANACTIONAMT )))+'|'+left(Scripname,75),@nseBank              
       FROM   #NSE_DETAILS X            
       WHERE  X.PARTY_CODE = @PARTYCODE      
       and X.Sett_no = @nseSett_no2    
        
       End         
    else if(@nseBank like '%HDFC%' or @nseBank like '%IDBI%' or @nseBank like '%YES%')    
         BEGIN    
       
   declare @TotalAmt as money    
   select @TotalAmt=(sum(TRANACTIONAMT)) from #NSE_DETAILS where party_code =@PARTYCODE    
       
   select @CliPISNo= case when ( isnull(fld_ClientPISac,'0')='0') then FLD_NROPISNO  else fld_ClientPISac end,    
   @CliBnkAcc= case when (isnull(fld_NREAcNO,'0')='0') then FLD_NROAcNO  else fld_NREAcNO end,    
   @rbi_refno=rbi_refno    
   from Intranet.risk.dbo.tbl_NRIClientMaster with (nolock)  where fld_clientcode = @PARTYCODE    
       
     INSERT INTO #TEMP1      
     --declare @nseBank as varchar(20)='jdfc',@PARTYCODE as varchar(20)='ZR1101N',@seg as varchar(20)='NSE',@nseSETT_NO as varchar(20)='1122321',@TYPE as varchar(20)='1',@diffamt as numeric='0.01',@cliBankBranch as varchar(100),@CliBnkAcc as varchar(50),@angelAcc as varchar(50)    
     --select @nseBank=fld_bankName,@cliBankBranch=Fld_branchlocation,@CliBnkAcc=fld_ClientPISac,@angelAcc=Fld_AngelAcc from Intranet.risk.dbo.V_NriBank_Details with (nolock) where fld_clientcode = 'ZR1101N'    
         
     select @nseBank+','+Convert(varchar,a.SAUDA_DATE,103)+','+@PARTYCODE+','+b.DPid1 +','+cast(right(b.cltdpID1,8) as varchar) +','+b.Short_Name +','+@SEG +','+isnull(@nseSett_no2,'') +','+    
     CONVERT(VARCHAR,a.CONTRACTNO)+','+ltrim(rtrim(c.scripcode))+','+Ltrim(Rtrim(Isnull(c.ISIN,'')))+','+    
     left(c.Scripname,75)+','+CASE WHEN @TYPE = 1 THEN 'Buy'  WHEN @TYPE = 2 THEN 'Sell'  END +','+Ltrim(Rtrim(CONVERT(VARCHAR,c.QTY))) +','+ Convert(Varchar,c.RATE)+','+cast((CONVERT(DEC(15,2),c.TRATE) *c.QTY) as varchar) +','+    
       Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(15,2), c.TRATE)))) +','+Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(10,2), c.BROK_PERSCRIP))))+','+    
     --CASE WHEN @diffamt BETWEEN -0.03 AND 0.03           
     -- THEN CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),( Sum(CONVERT(DECIMAL(14,2),Isnull(MINBROKERAGE,0)) + CONVERT(DECIMAL(14,2),Isnull(OTHER_CHARGES,0))) + @diffamt )))            
     -- ELSE CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),( Sum(Isnull(MINBROKERAGE,0) + Isnull(OTHER_CHARGES,0)) )))         
     --  END +','+  --Other Charges end+','+    
        CONVERT(VARCHAR,Isnull(C.OTHERCHARGES,0))+','+    
     cast(Ltrim(Rtrim(CONVERT(DEC(10,2),c.TRANACTIONAMT))) as varchar) +','+ CONVERT(VARCHAR,CONVERT(DECIMAL(14, 2),Sum(Isnull(C.NseStt, 0))))+','+    
     CONVERT(VARCHAR,CONVERT(DECIMAL(14,2), a.TOTALAMT))+','+isnull(@rbi_refno,'')+','+@CliPISNo+','+@CliBnkAcc+','+@cliBankBranch+','+'Angel One Ltd'+','+ CASE WHEN @TYPE = 1 THEN  Convert(varchar,(a.sauda_date +1),103)  WHEN @TYPE = 2 THEN Convert(varchar,(a.sauda_date+2),103)  END+','+    
      CASE WHEN @TYPE = 1 THEN  Convert(varchar,(a.sauda_date +1),103)  WHEN @TYPE = 2 THEN Convert(varchar,(a.sauda_date+2),103)  END +','+@angelAcc,@nseBank    
     from #NSE_HEADER a         
     left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code     
     left outer join #NSE_DETAILS c on a.party_code=c.party_code    
     where a.party_code= @PARTYCODE and a.SETT_NO=@nseSett_no2 and c.SETT_NO=@nseSett_no2    
     group by    a.SAUDA_DATE ,b.DPid1 ,right(b.cltdpID1,8) ,b.Short_Name ,    
     CONVERT(VARCHAR, a.CONTRACTNO) ,Ltrim(Rtrim(Isnull(c.ISIN, ''))),    
     left(c.Scripname,75) ,Ltrim(Rtrim(CONVERT(VARCHAR, c.QTY))) ,Ltrim(Rtrim(CONVERT(DEC(10, 2), c.TRANACTIONAMT))),c.scripcode,    
     Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(15, 2), c.RATE)))),Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), c.BROK_PERSCRIP)))),    
     c.QTY, Convert(Varchar,c.RATE),c.TRATE,c.RATE, Isnull(c.OTHERCHARGES,0),a.TOTALAMT    
    print('4 ' + @PARTYCODE)    
   End    
    
            set @nserw=@nserw+1    
      END    
    
              END                
                
            SET @CNT=@CNT - 1                
        END                
                
      --SELECT *                
      --FROM   #TEMP1       Intranet.risk.dbo.V_NriBank_Details where fld_bankname like '%idfc%'    
    
  insert into tbl_NRILec_temp    
  select * from #TEMP1    
    
    
  if ((select count(1) from tbl_NRILec_temp) >0)    
    Begin    
     declare @BCPCOMMAND1 as varchar(1000)    
     DECLARE @Axisfilename2 as varchar(200)         DECLARE @indusfilename2 as varchar(200)    
     DECLARE @Idfcfilename2 as varchar(200)    
     DECLARE @hdfcfilename2 as varchar(200)    
     DECLARE @IDBIfilename2 as varchar(200)    
     DECLARE @Yesfilename2 as varchar(200)    
     DECLARE @Allfilename2 as varchar(200)    
     declare @link as varchar(2000)=''    
     declare @Ftype as varchar(100)             
        
   set @Ftype=  CASE   WHEN @TYPE = 1 THEN 'Buy'  WHEN @TYPE = 2 THEN 'Sell'  END+'_'+@SEG        
   --set @Ftype=  'BUY_NSE'        
        
        
    if ((select count(1) from tbl_NRILec_temp where bankname like '%AXIS%')>0)    
     Begin    
        SET @Axisfilename2 = '\\196.1.115.147\upload1\NRI_CLients\Axis_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'     
      SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp where bankname like ''%AXIS%''" QUERYOUT "'    
     SET @BCPCOMMAND1 = @BCPCOMMAND1 + @Axisfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
     EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1     
     --print(@BCPCOMMAND1)    
    -- set @link=@link +'<a href='+replace(@Axisfilename2,'\\196.1.115.147','')+'>Right click and save -- Axis</a><br>'    
     select '<a href='+replace(@Axisfilename2,'\\196.1.115.147','')+'>Right click and save -- Axis</a><br>'    
     End    
      if ((select count(1) from tbl_NRILec_temp where bankname like '%INDUSIND%')>0)    
     Begin    
        SET @indusfilename2 = '\\196.1.115.147\upload1\NRI_CLients\INDUSIND_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'     
      SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp where bankname like ''%INDUSIND%''" QUERYOUT "'                                
   -- print(@BCPCOMMAND1)                          
     SET @BCPCOMMAND1 = @BCPCOMMAND1 + @indusfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
     EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1     
    -- set @link=@link +'<a href='+replace(@indusfilename2,'\\196.1.115.147','')+'>Right click and save -- Indusind</a><br>'    
    select '<a href='+replace(@indusfilename2,'\\196.1.115.147','')+'>Right click and save -- Indusind</a><br>'    
     End    
      if ((select count(1) from tbl_NRILec_temp where bankname like '%IDFC%')>0)    
     Begin    
        SET @Idfcfilename2 = '\\196.1.115.147\upload1\NRI_CLients\IDFC_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'     
      SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp where bankname like ''%IDFC%''" QUERYOUT "'                                
   -- print(@BCPCOMMAND1)                          
     SET @BCPCOMMAND1 = @BCPCOMMAND1 + @Idfcfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
     EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1     
      --set @link=@link +'<a href='+replace(@Idfcfilename2,'\\196.1.115.147','')+'>Right click and save -- IDFC</a><br>'    
       select '<a href='+replace(@Idfcfilename2,'\\196.1.115.147','')+'>Right click and save -- IDFC</a><br>'    
     End    
       if ((select count(1) from tbl_NRILec_temp where bankname like '%HDFC%')>0)    
     Begin    
        SET @hdfcfilename2 = '\\196.1.115.147\upload1\NRI_CLients\HDFC_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'     
      SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp where bankname like ''%HDFC%''" QUERYOUT "'                                
   -- print(@BCPCOMMAND1)                          
     SET @BCPCOMMAND1 = @BCPCOMMAND1 + @hdfcfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
     EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1     
    -- set @link=@link +'<a href='+replace(@hdfcfilename2,'\\196.1.115.147','')+'>Right click and save -- HDFC</a><br>'    
    select '<a href='+replace(@hdfcfilename2,'\\196.1.115.147','')+'>Right click and save -- HDFC</a><br>'    
     End    
      if ((select count(1) from tbl_NRILec_temp where bankname like '%IDBI%')>0)    
     Begin    
        SET @IDBIfilename2 = '\\196.1.115.147\upload1\NRI_CLients\IDBI_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'     
      SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp where bankname like ''%IDBI%''" QUERYOUT "'                                
   -- print(@BCPCOMMAND1)                          
     SET @BCPCOMMAND1 = @BCPCOMMAND1 + @IDBIfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
     EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1    
    --  set @link=@link +'<a href='+replace(@IDBIfilename2,'\\196.1.115.147','')+'>Right click and save -- IDBI</a><br>'    
    select '<a href='+replace(@IDBIfilename2,'\\196.1.115.147','')+'>Right click and save -- IDBI</a><br>'    
     End         
      if ((select count(1) from tbl_NRILec_temp where bankname like '%YES%')>0)    
     Begin    
        SET @YESfilename2 = '\\196.1.115.147\upload1\NRI_CLients\YES_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'     
      SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp where bankname like ''%YES%''" QUERYOUT "'                                
   -- print(@BCPCOMMAND1)                          
     SET @BCPCOMMAND1 = @BCPCOMMAND1 + @YESfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
     EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1     
     --set @link=@link +'<a href='+replace(@YESfilename2,'\\196.1.115.147','')+'>Right click and save -- Yes Bank</a><br>'        
     select '<a href='+replace(@YESfilename2,'\\196.1.115.147','')+'>Right click and save -- Yes Bank</a><br>'    
     End    
     
    
    SET @Allfilename2 = '\\196.1.115.147\upload1\NRI_CLients\TEST_'+@Ftype+'_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                                                                                               
    --SET @FILENAME = '\\196.1.115.182\upload1\OmnesysFileFormat\CodeCreationFileFormat'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'     
    SET @BCPCOMMAND1 = 'BCP "select FLDCOL from Inhouse.dbo.tbl_NRILec_temp" QUERYOUT "'                                
   -- print(@BCPCOMMAND1)                          
    SET @BCPCOMMAND1 = @BCPCOMMAND1 + @Allfilename2 + '" -c -t, -SAngelNseCM -Uinhouse -Pinh6014'                                      
    EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1                 
    --set @link=@link +'<a href='+replace(@Allfilename2,'\\196.1.115.147','')+'>Right click and save -- All Banks</a><br>'    
    select '<a href='+replace(@Allfilename2,'\\196.1.115.147','')+'>Right click and save -- All Banks</a><br>'    
        
       
       End    
      Else    
    Begin    
         select 'No Records found'       
    End    
                
      SET NOCOUNT OFF                
  END

GO
