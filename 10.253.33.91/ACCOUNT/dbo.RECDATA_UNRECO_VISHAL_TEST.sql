-- Object: PROCEDURE dbo.RECDATA_UNRECO_VISHAL_TEST
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

  
 --EXEC RECDATA_UNRECO_VISHAL_TEST 'DEC 13 2020','DEC 13 2020'  
                  
CREATE PROC [dbo].[RECDATA_UNRECO_VISHAL_TEST] (  
  @FROMDATE VARCHAR(11),   
  @TODATE   VARCHAR(11)  
  --@access_to varchar(30),                      
  --@access_code varchar(30)  
    
  )   
AS   
    IF Len(@FROMDATE) = 10   
       AND Charindex('/', @FROMDATE) > 0   
      BEGIN   
          SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103)   
                          ,   
                          109)   
      END   
  
    IF Len(@TODATE) = 10   
       AND Charindex('/', @TODATE) > 0   
      BEGIN   
          SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103),   
                        109)   
      END   
  
    PRINT @FROMDATE   
  
  BEGIN   
        
SELECT *   
      INTO   #temp   
      FROM   (SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
                     [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt,   
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='NSE' ,  
      [SEGMENT] = 'CAPITAL',  
      ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0   
              FROM   ledger L (nolock),   
                     ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
                     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt, cdt,  
                     L.booktype,   
                     'NSE' , 'CAPITAL',      ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   ledger L(nolock),   
                     ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              ----BSE-----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
                     [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt, cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='BSE' ,        
      [SEGMENT] = 'CAPITAL', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   anand.account_ab.dbo.ledger L (nolock),   
                     anand.account_ab.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt,cdt,   
                     L.booktype,   
                     'BSE' , 'CAPITAL',     ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   anand.account_ab.dbo.ledger L(nolock),   
                     anand.account_ab.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
   AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              ----NSEFO------                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
                     [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt, cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='NSE' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelfo.accountfo.dbo.ledger L (nolock),   
                     angelfo.accountfo.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
                     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt, cdt,  
                     L.booktype,   
                     [EXCHANGE]='NSE' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelfo.accountfo.dbo.ledger L(nolock),   
                     angelfo.accountfo.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              --NSECURFO-----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
                     [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt, cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='NSX' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelfo.accountcurfo.dbo.ledger L (nolock),   
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')         --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
                     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt,cdt,   
                     L.booktype,   
                     [EXCHANGE]='NSX' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelfo.accountcurfo.dbo.ledger L(nolock),   
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              --MCDX----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
            [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
    [VAMT] =L.vamt,   
      [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt, cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='MCX' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelcommodity.accountmcdx.dbo.ledger L (nolock),   
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
                     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt, cdt,  
                     L.booktype,   
                    [EXCHANGE]='MCX' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelcommodity.accountmcdx.dbo.ledger L(nolock),   
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              --MCDXCDS----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
                     [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt, cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='MCD' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L (nolock),   
           angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
                     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt, cdt,  
                     L.booktype,   
                     [EXCHANGE]='MCD' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L(nolock),   
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              --NCDX----                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,   
                     [VDT] =L.vdt,   
                     [VNO] =L.vno,   
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                     [DDNO] =L1.ddno,   
                     [VTYP] =L.vtyp,   
                     [RELDT] =L1.reldt, cdt,  
                     [BOOKTYPE]=L.booktype,   
                     [EXCHANGE]='NCX' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelcommodity.accountncdx.dbo.ledger L (nolock),   
       angelcommodity.accountncdx.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'D'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT cltcode,   
                     L.vdt,   
                     L.vno,   
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                     L1.ddno,   
                     L.vtyp,   
                     L1.reldt, cdt,  
                     L.booktype,   
                     [EXCHANGE]='NCX' ,        
      [SEGMENT] = 'FUTURES', ENTEREDBY,  
      ACC_NUM = '999999999999999999',  
      ACC_NUM_STATUS = 0    
              FROM   angelcommodity.accountncdx.dbo.ledger L(nolock),   
                     angelcommodity.accountncdx.dbo.ledger1 L1 (nolock)   
              WHERE  L.vno = L1.vno   
                     AND L.vtyp = L1.vtyp   
                     AND L.booktype = L1.booktype   
                     AND L.drcr = 'C'   
                     AND L.vtyp in ('5', '16', '17')   
      --AND L1.RELDT=''  
                     AND L.vdt >= @FROMDATE   
                     AND L.vdt < = @TODATE + ' 23:59'  
       union all     
    SELECT                                                                              
      
    [CLTCODE]=CLTCODE,                                                                              
    [VDT]    =L.VDT,                                                                              
    [VNO]    =L.VNO,                                                                    
    REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                              
    [VAMT]   =(CASE WHEN L.DRAMOUNT =0 THEN CRAMOUNT ELSE DRAMOUNT END),                                                            
    [DRCR]   =(CASE WHEN L.DRAMOUNT =0 THEN 'CR' ELSE 'DR' END),                                                                        
    [DDNO]   = INSTNO,                                                                
    [VTYP]   =L.VTYPE,                                                                              
    --[RELDT]  =(CASE WHEN L.VTYPE =2 THEN CR_RELDT ELSE DR_RELDT END),  
    [DR_RELDT],  
    T1.POSTED_ON AS CDT,                                                                              
    [BOOKTYPE]='01',                                                                    
    L.EXCHANGE,        
    L.SEGMENT, ENTEREDBY =POSTED_BY,  
    ACC_NUM = '999999999999999999',  
    ACC_NUM_STATUS = 0                                                                       
    FROM ANGELFO.BBO_FA.DBO.MFSS_LEDGER_BSE L (NOLOCK) , ANGELFO.BBO_FA.DBO.ACC_TBL4  T4 WITH(NOLOCK)  ,ANGELFO.BBO_FA.DBO.ACC_TBL1   T1   WITH(NOLOCK)                                            
    WHERE   T1.SNO =T4.MASTERSNO  AND L.VTYPE=T1.VTYPE  and  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'  --AND L1.RELDT='1900-01-01 00:00:00.000'  
    AND L.VTYPE =2 AND L.VNO =T1.VNO   AND DR_RELDT=''  
   
       
         )A   
  
      CREATE CLUSTERED INDEX idx_cl   
        ON #temp ( cltcode, vdt )   
  
  UPDATE #temp SET ACC_NUM_STATUS = 1, ACC_NUM = O.TPACCOUNTNUMBER  
  FROM [AngelBSECM].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES O   
  WHERE #temp.VNO = O.LEDGERVNO AND #temp.VTYP = O.VOUCHERTYPE AND #temp.BOOKTYPE = O.BOOKTYPE AND #temp.EXCHANGE = O.EXCHANGE AND #temp.SEGMENT = O.SEGMENT  
  
  
    
  
      SELECT [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''),   
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT,   
    CONVERT(TIME(0), A.vdt) AS VDT_TIME,  
             [VNO]=Replace(Ltrim(Rtrim(A.vno)), ' ', ''),   
             [NARRATION]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(A.narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', '')
,'.', ''),  
             [EXCHANGE]=Replace(Ltrim(Rtrim(A.exchange)), ' ', ''),   
    [SEGMENT]=Replace(Ltrim(Rtrim(A.SEGMENT)), ' ', ''),   
             [VAMT]=Replace(Ltrim(Rtrim(A.vamt)), ' ', ''),   
             [DRCR]=Replace(Ltrim(Rtrim(A.drcr)), ' ', ''),   
             [DDNO]=Replace(Replace(Ltrim(Rtrim(A.ddno)), ' ', ''),'''',''),   
             [VTYP]=Replace(Ltrim(Rtrim(A.vtyp)), ' ', ''),   
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) AS RELDT  ,   
    [Entry_DAte],  ENTEREDBY ,  
             [BOOKTYPE]=Replace(Ltrim(Rtrim(A.booktype)), ' ', '')  ,   
             [SHORT_NAME]=ISNULL(Replace(Ltrim(Rtrim(B.short_name)), ' ', ''),''),   
             [REGION]=ISNULL(Replace(Ltrim(Rtrim(B.region)), ' ', ''),''),   
             [BRANCH_CD]=ISNULL(Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''),''),   
             [SUB_BROKER]=ISNULL(Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''),''),   
             ISNULL(REPLACE(REPLACE(replace(B.bank_name,',',' '),'"',''),'''',''),'')  AS BANK_NAME,   
             [AC_NUM]=CASE WHEN AC_NUM = '999999999999999999' THEN ISNULL(Replace(Ltrim(Rtrim(B.ac_num)), ' ', ''),'') ELSE AC_NUM END, ACC_NUM_STATUS  INTO #FINAL  
      FROM   #temp AS A   
             LEFT OUTER JOIN msajag.dbo.client_details AS B   
                          ON A.cltcode = B.cl_code   
      --ORDER  BY exchange   
    
  SELECT * FROM  #FINAL  ORDER  BY exchange   
    
    
  END

GO
