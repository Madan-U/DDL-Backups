-- Object: PROCEDURE dbo.LEDGER_ENTRIES_vishal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--LEDGER_ENTRIES_vishal 'JUN  1 2020','JUL  3 2020'

---LEDGER_ENTRIES_vishal 'may 15 2020','jun 14 2020'  
  
  --LEDGER_ENTRIES_vishal @Fdate,@Tdate
CREATE PROCEDURE [dbo].[LEDGER_ENTRIES_vishal]    
(    
     
@Fdate varchar(15)  ,  
@Tdate varchar(15)     
    
)    
AS    
BEGIN   
     
   DECLARE @FromDate DATETIME=CAST(@Fdate  AS DATETIME)  
DECLARE @ToDate DATETIME=dateadd(ms, -3, (dateadd(day, +1, convert(varchar, @Tdate, 101))))--DATEADD(DD, -1, DATEADD(D, 1, CONVERT(DATETIME2, @Tdate)))   
  
  
SELECT *  
      INTO   #temp  
      FROM   (SELECT  [CLTCODE]=cltcode,  
                     [VDT] =L.vdt,  
                     [VNO] =L.vno,  
                     [NARRATION]=L.narration,  
                     [VAMT] =L.vamt,  
                     [DRCR] =L.drcr,  
                     [DDNO] =L1.ddno,  
                     [VTYP] =L.vtyp,  
                     [RELDT] =L1.reldt, 
                     [EDT]=L.Edt, 
				     [Entry_DAte]=cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='NSE' , ENTEREDBY  
              FROM   ledger L (nolock),  
                     ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                    AND L.vtyp in  ('2', '3','16','17')  
                    AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT, cdt,  
                     L.booktype,  
                     'NSE' , ENTEREDBY  
              FROM   ledger L(nolock),  
                     ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
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
                     [RELDT] =L1.reldt,
                     [EDT]=L.Edt,
                      cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='BSE' , ENTEREDBY  
              FROM   AngelBSECM.account_ab.dbo.ledger L (nolock),  
                     AngelBSECM.account_ab.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT,cdt,  
                     L.booktype,  
                     'BSE' , ENTEREDBY  
              FROM   AngelBSECM.account_ab.dbo.ledger L(nolock),  
                     AngelBSECM.account_ab.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
      AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
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
                     [RELDT] =L1.reldt,
                     [EDT]=L.Edt, cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='NSEFO' , ENTEREDBY  
              FROM   angelfo.accountfo.dbo.ledger L (nolock),  
                     angelfo.accountfo.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT, cdt,  
                     L.booktype,  
                     'NSEFO' , ENTEREDBY  
              FROM   angelfo.accountfo.dbo.ledger L(nolock),  
                     angelfo.accountfo.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                 AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
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
                     [RELDT] =L1.reldt,
                     [EDT]=L.Edt,
                      cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='NSECURFO' , ENTEREDBY  
              FROM   angelfo.accountcurfo.dbo.ledger L (nolock),  
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                    AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT,cdt,  
                     L.booktype,  
                     'NSECURFO' , ENTEREDBY  
              FROM   angelfo.accountcurfo.dbo.ledger L(nolock),  
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
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
                     [RELDT] =L1.reldt,
                     [EDT]=L.Edt,                      cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='MCDX' , ENTEREDBY  
              FROM   angelcommodity.accountmcdx.dbo.ledger L (nolock),  
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                    AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT, cdt,  
                     L.booktype,  
                     'MCDX' , ENTEREDBY  
              FROM   angelcommodity.accountmcdx.dbo.ledger L(nolock),  
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
              AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
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
                     [RELDT] =L1.reldt,
                     [EDT]=L.Edt,
                      cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='MCDXCDS' , ENTEREDBY  
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L (nolock),  
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                    AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT, cdt,  
                     L.booktype,  
                     'MCDXCDS' , ENTEREDBY  
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L(nolock),  
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
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
                     [RELDT] =L1.reldt,
                     [EDT]=L.Edt,
                      cdt,  
                     [BOOKTYPE]=L.booktype,  
                     [EXCHANGE]='NCDX' , ENTEREDBY  
              FROM   angelcommodity.accountncdx.dbo.ledger L (nolock),  
       angelcommodity.accountncdx.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                   AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
--And L.NARRATION Like '%REV%'  
              UNION ALL  
              SELECT cltcode,  
                     L.vdt,  
                     L.vno,  
                     L.narration,  
                     L.vamt,  
                     L.drcr,  
                     L1.ddno,  
                     L.vtyp,  
                     L1.reldt,L.EDT, cdt,  
                     L.booktype,  
                     'NCDX' , ENTEREDBY  
              FROM   angelcommodity.accountncdx.dbo.ledger L(nolock),  
                     angelcommodity.accountncdx.dbo.ledger1 L1 (nolock)  
              WHERE  L.vno = L1.vno  
                     AND L.vtyp = L1.vtyp  
                     AND L.booktype = L1.booktype  
                     AND L.vtyp in  ('2', '3','16','17')  
AND L1.RELDT='1900-01-01'  
                     AND L.vdt >= @FromDate  
                     AND L.vdt < = @ToDate   
  
   
  
    )A  
  
      CREATE CLUSTERED INDEX idx_cl  
        ON #temp ( cltcode, vdt )  
  
      SELECT  [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''),  
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
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.EDT, 103), 103) AS EDT  ,  
			   [Entry_DAte]  ,    
				ENTEREDBY ,  
             [BOOKTYPE]=Replace(Ltrim(Rtrim(A.booktype)), ' ', '')  ,  
             [SHORT_NAME]=ISNULL(Replace(Ltrim(Rtrim(B.short_name)), ' ', ''),''),  
             [REGION]=ISNULL(Replace(Ltrim(Rtrim(B.region)), ' ', ''),''),  
             [BRANCH_CD]=ISNULL(Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''),''),  
             [SUB_BROKER]=ISNULL(Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''),''),  
             ISNULL(REPLACE(REPLACE(replace(B.bank_name,',',' '),'"',''),'''',''),'')  AS BANK_NAME,  
             [AC_NUM]=ISNULL(Replace(Ltrim(Rtrim(B.ac_num)), ' ', ''),'')  INTO #FINAL  
      FROM   #temp AS A  
             LEFT OUTER JOIN msajag.dbo.client_details AS B  
                          ON A.cltcode = B.cl_code  
      ORDER  BY exchange  
   
 SELECT * FROM  #FINAL  ORDER  BY exchange  
   
   
   
  
end

GO
