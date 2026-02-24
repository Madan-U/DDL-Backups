-- Object: PROCEDURE dbo.RECDATA_UNRECO_VISHAL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--EXEC RECDATA_UNRECO_VISHAL 'NOV 25 2019', 'NOV 27 2019'      
      
      
      
                      
CREATE PROC [dbo].[RECDATA_UNRECO_VISHAL] (      
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
      FROM   (SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
                     [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
                     [VAMT] =L.vamt,       
                     [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,      
      '' col2,       
                     [RELDT] =L1.reldt,       
      [Entry_DAte]=cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='NSE' ,      ENTEREDBY       
              FROM   ledger L (nolock),       
                     ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
                     L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
      '' col2,      
                     L1.reldt, cdt,      
                     L.booktype,       
                     'NSE' ,      ENTEREDBY       
              FROM   ledger L(nolock),       
                     ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              ----BSE-----                                             
              UNION ALL       
              SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
                     [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
                     [VAMT] =L.vamt,       
                     [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,      
      '' col2,       
                     [RELDT] =L1.reldt, cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='BSE' ,      ENTEREDBY       
              FROM   anand.account_ab.dbo.ledger L (nolock),       
                     anand.account_ab.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
            L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
      '' col2,      
                     L1.reldt,cdt,       
                     L.booktype,       
                    'BSE' ,      ENTEREDBY       
              FROM   anand.account_ab.dbo.ledger L(nolock),       
                     anand.account_ab.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
   AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              ----NSEFO------                                             
              UNION ALL       
              SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
                     [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
                     [VAMT] =L.vamt,       
                     [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,      
      '' col2,       
                     [RELDT] =L1.reldt, cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='NSEFO' ,      ENTEREDBY       
              FROM   angelfo.accountfo.dbo.ledger L (nolock),       
                     angelfo.accountfo.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
                     L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
      '' col2,      
                     L1.reldt, cdt,      
                     L.booktype,       
                     'NSEFO' ,      ENTEREDBY       
              FROM   angelfo.accountfo.dbo.ledger L(nolock),       
                     angelfo.accountfo.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              --NSECURFO-----                                             
              UNION ALL       
              SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
                     [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
                     [VAMT] =L.vamt,       
                     [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,      
      '' col2,       
                     [RELDT] =L1.reldt, cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='NSECURFO' ,      ENTEREDBY       
              FROM   angelfo.accountcurfo.dbo.ledger L (nolock),       
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
         AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
                     L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
      '' col2,      
                     L1.reldt,cdt,       
                     L.booktype,       
                     'NSECURFO' ,      ENTEREDBY       
              FROM   angelfo.accountcurfo.dbo.ledger L(nolock),       
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              --MCDX----                                             
              UNION ALL       
              SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
            [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
    [VAMT] =L.vamt,       
      [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,       
                     '' col2,      
      [RELDT] =L1.reldt, cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='MCDX' ,      ENTEREDBY       
              FROM   angelcommodity.accountmcdx.dbo.ledger L (nolock),       
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
                     L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
      '' col2,      
                     L1.reldt, cdt,      
                     L.booktype,       
                     'MCDX' ,      ENTEREDBY       
              FROM   angelcommodity.accountmcdx.dbo.ledger L(nolock),       
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              --MCDXCDS----                                             
              UNION ALL       
              SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
                     [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
                     [VAMT] =L.vamt,       
                [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,       
                     '' col2,      
      [RELDT] =L1.reldt, cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='MCDXCDS' ,      ENTEREDBY       
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L (nolock),       
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
                     L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
                     '' col2,      
      L1.reldt, cdt,      
                     L.booktype,       
                     'MCDXCDS' ,      ENTEREDBY       
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L(nolock),       
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              --NCDX----                             
              UNION ALL       
              SELECT Distinct [CLTCODE]=cltcode,       
                     [VDT] =L.vdt,       
                     [VNO] =L.vno,       
                     [NARRATION]=L.narration,       
                     [VAMT] =L.vamt,       
                     [DRCR] =L.drcr,       
                     [DDNO] =L1.ddno,       
                     [VTYP] =L.vtyp,      
      '' col2,       
                     [RELDT] =L1.reldt, cdt,      
                     [BOOKTYPE]=L.booktype,       
                     [EXCHANGE]='NCDX' ,      ENTEREDBY       
              FROM   angelcommodity.accountncdx.dbo.ledger L (nolock),       
       angelcommodity.accountncdx.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'D'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'       
              UNION ALL       
              SELECT Distinct cltcode,       
                     L.vdt,       
                     L.vno,       
                     L.narration,       
                     L.vamt,       
                     L.drcr,       
                     L1.ddno,       
                     L.vtyp,       
      '' col2,      
                     L1.reldt, cdt,      
                     L.booktype,       
                     'NCDX' ,      ENTEREDBY       
              FROM   angelcommodity.accountncdx.dbo.ledger L(nolock),       
                     angelcommodity.accountncdx.dbo.ledger1 L1 (nolock)       
              WHERE  L.vno = L1.vno       
                     AND L.vtyp = L1.vtyp       
                     AND L.booktype = L1.booktype       
                     AND L.drcr = 'C'       
                     AND L.vtyp in ('2','3','5', '16', '17')      
      --AND L1.RELDT=''      
                     AND L.vdt >= @FROMDATE       
                     AND L.vdt < = @TODATE + ' 23:59'      
       union all         
    --SELECT                                                                                  
          
    --[CLTCODE]=CLTCODE,                                                                                  
    --[VDT]    =L.VDT,                                                                                  
    --[VNO]    =L.VNO,                                                                        
    --REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                                  
    --[VAMT]   =(CASE WHEN L.DRAMOUNT =0 THEN CRAMOUNT ELSE DRAMOUNT END),                                                                
    --[DRCR]   =(CASE WHEN L.DRAMOUNT =0 THEN 'CR' ELSE 'DR' END),                                                                            
    --[DDNO]   = INSTNO,                                                                    
    --[VTYP]   =L.VTYPE,                                                                                  
    ----[RELDT]  =(CASE WHEN L.VTYPE =2 THEN CR_RELDT ELSE DR_RELDT END),      
    --[DR_RELDT],      
    --T1.POSTED_ON AS CDT,                                                                                  
    --[BOOKTYPE]='01',                                                                        
    --[EXCHANGE]='MFSS'     ,      ENTEREDBY =POSTED_BY                                                                          
    --FROM ANGELFO.BBO_FA.DBO.MFSS_LEDGER_BSE L (NOLOCK) , ANGELFO.BBO_FA.DBO.ACC_TBL4  T4 WITH(NOLOCK)  ,ANGELFO.BBO_FA.DBO.ACC_TBL1   T1   WITH(NOLOCK)                                                
    --WHERE   T1.SNO =T4.MASTERSNO  AND L.VTYPE=T1.VTYPE  and  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'  --AND L1.RELDT='1900-01-01 00:00:00.000'      
    --AND L.VTYPE =2 AND L.VNO =T1.VNO   AND DR_RELDT=''      
      
          
    SELECT                                                                                  
    Distinct      
    [CLTCODE]=CLTCODE,                                                                                  
    [VDT]    =L.VDT,                                                                                  
    [VNO]    =L.VNO,                                                                        
    REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                                  
    [VAMT]   =(CASE WHEN L.DRAMOUNT =0 THEN CRAMOUNT ELSE DRAMOUNT END),                                                                
    [DRCR]   =(CASE WHEN L.DRAMOUNT =0 THEN 'CR' ELSE 'DR' END),                                                                            
    [DDNO]   = INSTNO,                                                                    
    [VTYP]   =L.VTYPE,         
   N1.[SACCOUNTNO],  -- = ACCOUNTNO,                                                                              
    --[RELDT]  =(CASE WHEN L.VTYPE =2 THEN CR_RELDT ELSE DR_RELDT END),      
    [DR_RELDT],      
    T1.POSTED_ON AS CDT,                                                                                  
    [BOOKTYPE]='01',                                                                        
    [EXCHANGE]='MFSS'     ,      ENTEREDBY =POSTED_BY                                                                          
    FROM ANGELFO.BBO_FA.DBO.MFSS_LEDGER_BSE L (NOLOCK) , ANGELFO.BBO_FA.DBO.ACC_TBL4  T4 WITH(NOLOCK)  ,ANGELFO.BBO_FA.DBO.ACC_TBL1   T1   WITH(NOLOCK), [196.1.115.132].MutualFund.dbo.vw_SIPPayinTransdetails N1 with (Nolock)                               
  
    
                
    WHERE   T1.SNO =T4.MASTERSNO  AND L.VTYPE=T1.VTYPE  and  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'  --AND L1.RELDT='1900-01-01 00:00:00.000'      
    --WHERE   T1.SNO =T4.MASTERSNO  AND L.VTYPE=T1.VTYPE  and  L.VDT >= '2010-02-11' AND L.VDT < ='2010-02-11' + ' 23:59'  --AND L1.RELDT='1900-01-01 00:00:00.000'      
    and L.VDT = N1.SDueDate  AND L.cltcode = N1.sclientcode      
    AND L.VTYPE =2 AND L.VNO =T1.VNO   AND DR_RELDT=''      
    --AND L.CLTCODE='PN81'      
       
           
         )A       
      
      CREATE CLUSTERED INDEX idx_cl       
        ON #temp ( cltcode, vdt )       
      
      SELECT [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''),       
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT,       
    CONVERT(TIME(0), A.vdt) AS VDT_TIME,      
             [VNO]=Replace(Ltrim(Rtrim(A.vno)), ' ', ''),       
             [NARRATION]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(A.narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', '')
  
    
,'.', ''),      
             [EXCHANGE]=Replace(Ltrim(Rtrim(A.exchange)), ' ', ''),       
             [VAMT]=Replace(Ltrim(Rtrim(A.vamt)), ' ', ''),       
             [DRCR]=Replace(Ltrim(Rtrim(A.drcr)), ' ', ''),       
             [DDNO]=Replace(Replace(Ltrim(Rtrim(A.ddno)), ' ', ''),'''',''),       
             [VTYP]=Replace(Ltrim(Rtrim(A.vtyp)), ' ', ''),       
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) AS RELDT  ,       
    [Entry_DAte],  ENTEREDBY ,      
             [BOOKTYPE]=Replace(Ltrim(Rtrim(A.booktype)), ' ', '')  ,       
             [SHORT_NAME]=ISNULL(Replace(Ltrim(Rtrim(B.short_name)), ' ', ''),''),      
    [PAN_GIR_NO]=ISNULL(Replace(Ltrim(Rtrim(B.PAN_GIR_NO)), ' ', ''),''),       
             [REGION]=ISNULL(Replace(Ltrim(Rtrim(B.region)), ' ', ''),''),       
             [BRANCH_CD]=ISNULL(Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''),''),       
             [SUB_BROKER]=ISNULL(Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''),''),       
             ISNULL(REPLACE(REPLACE(replace(B.bank_name,',',' '),'"',''),'''',''),'')  AS BANK_NAME,       
             [AC_NUM]=ISNULL(Replace(Ltrim(Rtrim(B.ac_num)), ' ', ''),''),      
    [COL2]=ISNULL(Replace(Ltrim(Rtrim(A.col2)), ' ', ''),'')  INTO #FINAL      
      FROM   #temp AS A       
             LEFT OUTER JOIN msajag.dbo.client_details AS B       
                          ON A.cltcode = B.cl_code       
      ORDER  BY exchange       
        
  --SELECT * from #FINAL  ORDER  BY exchange       
      
  update f set ac_num = CltAccNo from #FINAL f, [AngelBSECM].account_ab.dbo.Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'bse' and ISNULL (CltAccNo, '') <> ''      
      
update f set ac_num = CltAccNo from #FINAL f, [AngelFO].accountcurfo.dbo.Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'nsecurfo' and ISNULL (CltAccNo, '') <> ''      
      
  update f set ac_num = CltAccNo from #FINAL f, [AngelFO].accountfo.dbo.Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'nsefo' and ISNULL (CltAccNo, '') <> ''      
      
  update f set ac_num = CltAccNo from #FINAL f, Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'nse' and ISNULL (CltAccNo, '') <> ''      
      
        
  update f set ac_num = CltAccNo from #FINAL f, [AngelCommodity].accountmcdx.dbo.Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'MCDXCDS' and ISNULL (CltAccNo, '') <> ''      
      
  update f set ac_num = CltAccNo from #FINAL f, [AngelCommodity].accountmcdx.dbo.Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'MCDX' and ISNULL (CltAccNo, '') <> ''      
      
      
      
  update f set ac_num = CltAccNo from #FINAL f, [AngelCommodity].accountmcdx.dbo.Recon_cms_data r      
  where f.vno = r.vno and f.vtyp = r.vtyp and f.booktype = r.booktype and exchange = 'NCDX' and ISNULL (CltAccNo, '') <> ''      
      
        
        
 select * into #aa from  [196.1.115.132].cms.dbo.ncms_segpayoutappamt with(nolock) where processdatetime>=@FROMDATE and processdatetime<= @TODATE + ' 23:59'  and SegApprovedAmt>0      
 order by ProcessDateTime       
      
 select distinct party_code,Req_datetime,PO_ApprovedAmt as amount,Req_PayBankId,Req_RefNo into #ncms from  [196.1.115.132].cms.dbo.ncms_po_request_hist with(nolock) where  po_statusid in (2,4)      
       
       
 select distinct Party_code,Req_datetime,amount,Req_PayBankId,Req_RefNo into #ab from #ncms with(nolock)      
where Req_RefNo in (select Req_RefNo from #aa)      
      
        
  --SELECT a.*,b.Req_PayBankId --,SUM(cast(VAMT as decimal(18,2))) OVER (PARTITION BY a.Cltcode ) AS Running_Total       
  --FROM  #FINAL a left join #ab b on a.CLTCODE=b.party_code      
  --ORDER  BY exchange       
      
      
      
      
   --SELECT * from #FINAL  ORDER  BY exchange       
  declare @frmdate as varchar(11)      
  set  @frmdate=convert(varchar(11),convert(datetime,@FROMDATE)-7,109)      
  --print @frmdate      
        
        
  select distinct CltCode,AccNO,AMT,'3' as vtyp into #tmp1 from (         
  select CltCode,AccNO,AMT from MIS.sccs.dbo.SCCS_ONFT_BankFile_hist with(nolock)  where Generateddate between @frmdate and @TODATE + ' 23:50:50'      
  union all      
  select Party_code,AccNum as AccNo,Amount from MIS.sccs.dbo.sccs_INGV_BankFile_hist with(nolock)  where updated_on between @frmdate and @TODATE + ' 23:50:50'      
  union all      
  select CltCode,AccNO,AmT from MIS.sccs.dbo.SCCS_neft_BankFile_hist with(nolock)  where Generateddate between @frmdate and @TODATE + ' 23:50:50'      
  Union all      
  Select Party_code, Req_PayBankId as AccNo, amount from #ab  with(nolock) -- where Req_datetime between @frmdate and @TODATE + ' 23:50:50'      
  ) a      
      
  insert into #tmp1      
  select Client_Code,Acc_No,Amount,'2' as vtyp from  [AngelBSECM].APIDetails.dbo.API_PAYMENT_DETAILS where post_date between @FROMDATE and @TODATE + ' 23:50:50'      
      
  --SELECT a.*,b.AccNO --,SUM(cast(VAMT as decimal(18,2))) OVER (PARTITION BY a.Cltcode ) AS Running_Total      
  --FROM  #FINAL a left join #tmp1 b on a.CLTCODE=b.CltCode and a.VAMT=b.amt and a.vTYP=b.vtyp       
  --ORDER  BY exchange       
        
  --Select top 1 * from #tmp1      
      
  Select Row_Number() over(order by a.vno) Sno, A.EXCHANGE,a.cltcode Bank_Code, replace(a.vdt,'/','-') as VDT,replace(a.RELDT,'/','-') as Value_date,      
  B.SHORT_NAME,/*B.Ac_Num,*/B.AccNO,      
  B.CLTCODE as UCC_Code ,B.CLTCODE as Bo_Code,Pan_No=Space(10),a.NARRATION,      
  a.VNo,space(10) as settlement_No,A.DDNO,round((Case when a.DRCR ='C' Then cast(a.Vamt as float) Else 0 End),2) Payment,      
   Round((Case when a.DRCR ='D' Then cast(a.Vamt as float) Else 0 End),2) Receipt,a.VTYP  Into #Bank      
    from       
  (      
  SELECT a.*,b.AccNO        
  FROM  #FINAL a left join #tmp1 b on a.CLTCODE=b.CltCode and a.VAMT=b.amt and a.vTYP=b.vtyp       
  where a.Cltcode  in ('03029','05028','02014','02015','02019','02020','02086','02087','02093','03014','03018','03022','03026','03031','03032','04033','04040','05016','1000001','1000005','1000011') )a ,      
  --where a.Cltcode  in ('03014') )a ,      
  ( SELECT a.*,b.AccNO        
  FROM  #FINAL a left join #tmp1 b on a.CLTCODE=b.CltCode and a.VAMT=b.amt and a.vTYP=b.vtyp       
  where a.Cltcode not in ('03029','05028','02014','02015','02019','02020','02086','02087','02093','03014','03018','03022','03026','03031','03032','04033','04040','05016','1000001','1000005','1000011'))b      
  --where a.Cltcode not in ('03014'))b      
  where  a.vno=b.vno      
  and a.vtyp=b.vtyp and a.booktype=b.booktype      
      
        
  SELECT o.*, RunningTotal = (Payment-receipt) + COALESCE(      
(      
  SELECT SUM(Payment-receipt)      
    FROM dbo.#Bank AS i      
    WHERE i.Sno < o.SNO), 0      
)      
FROM dbo.#Bank  AS o      
ORDER BY SNo;      
      
      
        
  END

GO
