-- Object: PROCEDURE dbo.JV_DATA_REPORT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

 --EXEC JV_DATA_REPORT '22/03/2021','22/03/2021'  
                  
CREATE PROC [dbo].[JV_DATA_REPORT] (  
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
  
  
TRUNCATE TABLE JV_SSRS_DATA  
  BEGIN   
      SELECT *   
      INTO   #temp   
      FROM   (SELECT[CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                       
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                       
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,   
                     [EXCHANGE]='NSE'    
              FROM   ledger L (nolock)  
              WHERE    
                      L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT   cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                      
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                      cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
                     'NSE'    
              FROM   ledger L(nolock)  
              WHERE   L.drcr = 'C'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              ----BSE-----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                       
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                       
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,  
                     [EXCHANGE]='BSE'    
              FROM   AngelBSECM.account_ab.dbo.ledger L (nolock)  
              WHERE   L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT  cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                       
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                       cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
              'BSE'           
              FROM   AngelBSECM.account_ab.dbo.ledger L(nolock)  
              WHERE   L.drcr = 'C'   
                     AND L.vtyp = 8  
     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              ----NSEFO------                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                      
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                       
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,  
                     [EXCHANGE]='NSEFO'    
              FROM   angelfo.accountfo.dbo.ledger L (nolock)  
              WHERE  L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT  cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                      
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                     cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
                     'NSEFO'    
              FROM   angelfo.accountfo.dbo.ledger L(nolock)  
              WHERE    L.drcr = 'C'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              --NSECURFO-----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                       
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                       
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,  
                     [EXCHANGE]='NSECURFO'   
              FROM   angelfo.accountcurfo.dbo.ledger L (nolock)  
              WHERE  L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT  cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                    
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                      cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
                     'NSECURFO'    
              FROM   angelfo.accountcurfo.dbo.ledger L(nolock)   
              WHERE  L.drcr = 'C'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              --MCDX----                                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                       
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                      
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,  
                     [EXCHANGE]='MCDX'    
              FROM   angelcommodity.accountmcdx.dbo.ledger L (nolock)   
              WHERE  L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT  cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                      
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                      cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
                     'MCDX'    
              FROM   angelcommodity.accountmcdx.dbo.ledger L(nolock)   
              WHERE     
                      L.drcr = 'C'   
                    AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              --MCDXCDS----                                         
              UNION ALL   
              SELECT[CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                       
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                       
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,  
                     [EXCHANGE]='MCDXCDS'   
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L (nolock)    
              WHERE    L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT  cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                       
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                       cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
                     'MCDXCDS'    
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L(nolock)    
              WHERE    L.drcr = 'C'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              --NCDX----                         
              UNION ALL   
              SELECT [CLTCODE]=cltcode,  
                     [VDT] =L.vdt,   
                     [EDT] =L.EDT,  
                     [VNO] =L.vno,   
                     [LNO] =L.LNO,  
                     [ACNAME]=L.ACNAME,  
                     [NARRATION]=L.narration,   
                     [VAMT] =L.vamt,   
                     [DRCR] =L.drcr,   
                        
                     [REFNO] =L.REFNO,  
                     [BALAMT]= L.BALAMT,  
                     [VTYP] =L.vtyp,   
                       
      [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,   
                     CHECKEDBY,ENTEREDBY,   
                     [EXCHANGE]='NCDX'    
              FROM   angelcommodity.accountncdx.dbo.ledger L (nolock)   
              WHERE   L.drcr = 'D'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'   
              UNION ALL   
              SELECT  cltcode,   
                     L.vdt,   
                     L.EDT,  
                     L.vno,   
                     L.LNO,  
                     L.ACNAME,  
                     L.narration,   
                     L.vamt,   
                     L.drcr,   
                        
                     L.REFNO,  
                     L.BALAMT,   
                     L.vtyp,   
                      cdt,  
                     L.booktype, ENTEREDBY ,CHECKEDBY,  
                     'NCDX'    
              FROM   angelcommodity.accountncdx.dbo.ledger L(nolock)    
              WHERE    L.drcr = 'C'   
                     AND L.vtyp = 8  
                     AND L.VDT >= @FROMDATE   
                     AND L.Vdt < = @TODATE + ' 23:59'  
    --   union all     
    --SELECT                                                                              
      
    --[CLTCODE]=CLTCODE,                                                                              
    --[VDT]    =L.VDT,                                                                              
    --[VNO]    =L.VNO,                                                                    
    --REPLACE(REPLACE(L.NARRATION,'''',''),'""','') AS NARRATION,                                                                              
    --[VAMT]   =(CASE WHEN L.DRAMOUNT =0 THEN CRAMOUNT ELSE DRAMOUNT END),                                                            
    --[DRCR]   =(CASE WHEN L.DRAMOUNT =0 THEN 'CR' ELSE 'DR' END),                                                                        
    --[DDNO]   = INSTNO,                                                                
    --[VTYP]   =L.VTYPE,                                                                              
    --[RELDT]  =(CASE WHEN L.VTYPE =2 THEN CR_RELDT ELSE DR_RELDT END),T1.POSTED_ON AS CDT,                                                                              
    --[BOOKTYPE]='01',                                                                    
    --[EXCHANGE]='MFSS'     ,      ENTEREDBY =POSTED_BY                                                                      
    --FROM ANGELFO.BBO_FA.DBO.MFSS_LEDGER_BSE L (NOLOCK) , ANGELFO.BBO_FA.DBO.ACC_TBL4  T4 WITH(NOLOCK)  ,ANGELFO.BBO_FA.DBO.ACC_TBL1   T1   WITH(NOLOCK)                                            
    --WHERE   T1.SNO =T4.MASTERSNO  AND L.VTYPE=T1.VTYPE  and  L.VDT >= @fromdate AND L.VDT < =@todate + ' 23:59'      
    --AND L.VTYPE =2 AND L.VNO =T1.VNO    
   
       
         )A   
  
      CREATE CLUSTERED INDEX idx_cl   
        ON #temp ( cltcode, vdt )   
          
  
INSERT INTO   JV_SSRS_DATA  
      SELECT [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''),   
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT,   
    CONVERT(TIME(0), A.vdt) AS VDT_TIME,  
     CONVERT(VARCHAR(11), CONVERT(DATETIME, A.EDT, 103), 103)   AS EDT,   
             [VNO]=Replace(Ltrim(Rtrim(A.vno)), ' ', ''),   
             [LNO]=Replace(Ltrim(Rtrim(A.LNO)), ' ', ''),   
             [ACNAME]=Replace(Ltrim(Rtrim(A.ACNAME)), ' ', ''),   
             [NARRATION]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(A.narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', '')
,'.', ''),  
             [EXCHANGE]=Replace(Ltrim(Rtrim(A.exchange)), ' ', ''),   
             [VAMT]=Replace(Ltrim(Rtrim(A.vamt)), ' ', ''),   
             [DRCR]=Replace(Ltrim(Rtrim(A.drcr)), ' ', ''),   
                
             [REFNO]=Replace(Replace(Ltrim(Rtrim(A.REFNO)), ' ', ''),'''',''),   
             [BALAMT]=Replace(Replace(Ltrim(Rtrim(A.BALAMT)), ' ', ''),'''',''),   
             [VTYP]=Replace(Ltrim(Rtrim(A.vtyp)), ' ', ''),   
                
    [Entry_DAte],  ENTEREDBY ,CHECKEDBY,  
             [BOOKTYPE]=Replace(Ltrim(Rtrim(A.booktype)), ' ', '')  ,   
             [SHORT_NAME]=ISNULL(Replace(Ltrim(Rtrim(B.short_name)), ' ', ''),''),   
             [REGION]=ISNULL(Replace(Ltrim(Rtrim(B.region)), ' ', ''),''),   
             [BRANCH_CD]=ISNULL(Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''),''),   
             [SUB_BROKER]=ISNULL(Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''),''),   
             ISNULL(REPLACE(REPLACE(replace(B.bank_name,',',' '),'"',''),'''',''),'')  AS BANK_NAME,   
             [AC_NUM]=ISNULL(Replace(Ltrim(Rtrim(B.ac_num)), ' ', ''),'')   
              --INTO JV_SSRS_DATA  
      FROM   #temp AS A   
             LEFT OUTER JOIN msajag.dbo.client_details AS B   
                          ON A.cltcode = B.cl_code   
      ORDER  BY exchange   
 ---SELECT * FROM JV_SSRS_DATA  
   
   
    
    DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\Backoffice\Automation\JV_DATA\'                       
SET @FILE = @PATH + 'JV_DATA' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name     
DECLARE @S VARCHAR(MAX)                              
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''CLTCODE'''',''''VDT'''',''''VDT_TIME'''',''''EDT'''',''''VNO'''',''''LNO'''',''''ACNAME'''',''''NARRATION'''',''''EXCHANGE'''',''''VAMT'''',''''DRCR'''' ,''''REFNO'''',''''BALAMT'''',''''VTYP'''' ,''
''Entry_DAte'''',''''ENTEREDBY'''',''''CHECKEDBY'''',''''BOOKTYPE'''',''''SHORT_NAME'''',''''REGION'''',''''BRANCH_CD'''',''''SUB_BROKER'''',''''BANK_NAME'''',''''AC_NUM'''''    --Column Name    
SET @S = @S + ' UNION ALL SELECT  cast([CLTCODE] as varchar),CONVERT (VARCHAR (11),VDT,109) as VDT,CONVERT (VARCHAR (11),VDT_TIME,109) as VDT_TIME,CONVERT (VARCHAR (11),EDT,109) as EDT, cast([VNO] as varchar), cast([LNO] as varchar), cast([ACNAME] as varc
har), cast([NARRATION] as varchar), cast([EXCHANGE] as varchar), cast([VAMT] as varchar), cast([DRCR] as varchar),cast([REFNO] as varchar),cast([BALAMT] as varchar),cast([VTYP] as varchar) ,CONVERT (VARCHAR (11),Entry_DAte,109) as Entry_DAte ,cast([ENTERE
DBY] as varchar),cast([CHECKEDBY] as varchar),cast([BOOKTYPE] as varchar),cast([SHORT_NAME] as varchar),cast([REGION] as varchar),cast([BRANCH_CD] as varchar) ,cast([SUB_BROKER] as varchar),cast([BANK_NAME] as varchar),cast([AC_NUM] as varchar) FROM [ACCO
UNT].[dbo].[JV_SSRS_DATA]    " QUERYOUT ' --Convert data type if required    
    
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S)  
    
    
  END

GO
