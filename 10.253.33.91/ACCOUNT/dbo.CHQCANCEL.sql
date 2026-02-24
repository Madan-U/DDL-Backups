-- Object: PROCEDURE dbo.CHQCANCEL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

                
CREATE PROC [dbo].[CHQCANCEL] (@FROMDATE VARCHAR(11), 
                                                 @TODATE   VARCHAR(11)) 
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
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='NSE' 
              FROM   ledger L (nolock), 
                     ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'NSE' 
              FROM   ledger L(nolock), 
                     ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
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
                     [RELDT] =L1.reldt, 
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='BSE' 
              FROM   AngelBSECM.account_ab.dbo.ledger L (nolock), 
                     AngelBSECM.account_ab.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'BSE' 
              FROM   AngelBSECM.account_ab.dbo.ledger L(nolock), 
                     AngelBSECM.account_ab.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
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
                     [RELDT] =L1.reldt, 
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='NSEFO' 
              FROM   angelfo.accountfo.dbo.ledger L (nolock), 
                     angelfo.accountfo.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'NSEFO' 
              FROM   angelfo.accountfo.dbo.ledger L(nolock), 
                     angelfo.accountfo.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
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
                     [RELDT] =L1.reldt, 
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='NSECURFO' 
              FROM   angelfo.accountcurfo.dbo.ledger L (nolock), 
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'NSECURFO' 
              FROM   angelfo.accountcurfo.dbo.ledger L(nolock), 
                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
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
                     [RELDT] =L1.reldt, 
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='MCDX' 
              FROM   angelcommodity.accountmcdx.dbo.ledger L (nolock), 
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'MCDX' 
              FROM   angelcommodity.accountmcdx.dbo.ledger L(nolock), 
                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
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
                     [RELDT] =L1.reldt, 
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='MCDXCDS' 
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L (nolock), 
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'MCDXCDS' 
              FROM   angelcommodity.accountmcdxcds.dbo.ledger L(nolock), 
                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
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
                     [RELDT] =L1.reldt, 
                     [BOOKTYPE]=L.booktype, 
                     [EXCHANGE]='NCDX' 
              FROM   angelcommodity.accountncdx.dbo.ledger L (nolock), 
                   angelcommodity.accountncdx.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'D' 
                     AND L.vtyp = 16
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
                     L1.reldt, 
                     L.booktype, 
                     'NCDX' 
              FROM   angelcommodity.accountncdx.dbo.ledger L(nolock), 
                     angelcommodity.accountncdx.dbo.ledger1 L1 (nolock) 
              WHERE  L.vno = L1.vno 
                     AND L.vtyp = L1.vtyp 
                     AND L.booktype = L1.booktype 
                     AND L.drcr = 'C' 
                     AND L.vtyp = 16
                     AND L.vdt >= @FROMDATE 
                     AND L.vdt < = @TODATE + ' 23:59'
                     )A 

      CREATE CLUSTERED INDEX idx_cl 
        ON #temp ( cltcode, vdt ) 

      SELECT [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''), 
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT, 
             [VNO]=Replace(Ltrim(Rtrim(A.vno)), ' ', ''), 
             [NARRATION]=replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(A.narration)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),
             [EXCHANGE]=Replace(Ltrim(Rtrim(A.exchange)), ' ', ''), 
             [VAMT]=Replace(Ltrim(Rtrim(A.vamt)), ' ', ''), 
             [DRCR]=Replace(Ltrim(Rtrim(A.drcr)), ' ', ''), 
             [DDNO]=Replace(Replace(Ltrim(Rtrim(A.ddno)), ' ', ''),'''',''), 
             [VTYP]=Replace(Ltrim(Rtrim(A.vtyp)), ' ', ''), 
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.reldt, 103), 103) AS RELDT  , 
             [BOOKTYPE]=Replace(Ltrim(Rtrim(A.booktype)), ' ', '')  , 
             [SHORT_NAME]=Replace(Ltrim(Rtrim(B.short_name)), ' ', ''), 
             [REGION]=Replace(Ltrim(Rtrim(B.region)), ' ', ''), 
             [BRANCH_CD]=Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''), 
             [SUB_BROKER]=Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''), 
             REPLACE(REPLACE(replace(B.bank_name,',',' '),'"',''),'''','')  AS BANK_NAME, 
             [AC_NUM]=Replace(Ltrim(Rtrim(B.ac_num)), ' ', '')  INTO #FINAL
      FROM   #temp AS A 
             LEFT OUTER JOIN msajag.dbo.client_details AS B 
                          ON A.cltcode = B.cl_code 
      ORDER  BY exchange 
  
  SELECT * FROM  #FINAL  ORDER  BY exchange 
  
  
  END

GO
