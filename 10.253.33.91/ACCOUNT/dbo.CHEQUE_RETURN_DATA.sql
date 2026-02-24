-- Object: PROCEDURE dbo.CHEQUE_RETURN_DATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

 --EXEC CHEQUE_RETURN_DATA 'NOV  1 2019','NOV  8 2019'

                

CREATE PROC [dbo].[CHEQUE_RETURN_DATA] (

		@FROMDATE VARCHAR(11),
		@TODATE   VARCHAR(11)

	 ) 

AS

BEGIN

 

DECLARE @FDate DATETIME=CAST(@FROMDATE  AS DATETIME)

DECLARE @TDate DATETIME=dateadd(ms, -3, (dateadd(day, +1, convert(varchar, @TODATE, 101))))--DATEADD(DD, -1, DATEADD(D, 1, CONVERT(DATETIME2, @Tdate)))  

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

                     [EXCHANGE]='NSE' ,					 ENTEREDBY 

              FROM   ledger L (nolock), 

                     ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'NSE' ,					 ENTEREDBY 

              FROM   ledger L(nolock), 

                     ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

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

                     [EXCHANGE]='BSE' ,					 ENTEREDBY 

              FROM   AngelBSECM.account_ab.dbo.ledger L (nolock), 

                     AngelBSECM.account_ab.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'BSE' ,					 ENTEREDBY 

              FROM   AngelBSECM.account_ab.dbo.ledger L(nolock), 

                     AngelBSECM.account_ab.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

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

                     [EXCHANGE]='NSEFO' ,					 ENTEREDBY 

              FROM   angelfo.accountfo.dbo.ledger L (nolock), 

                     angelfo.accountfo.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'NSEFO' ,					 ENTEREDBY 

              FROM   angelfo.accountfo.dbo.ledger L(nolock), 

                     angelfo.accountfo.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

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

                     [EXCHANGE]='NSECURFO' ,					 ENTEREDBY 

              FROM   angelfo.accountcurfo.dbo.ledger L (nolock), 

                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'NSECURFO' ,					 ENTEREDBY 

              FROM   angelfo.accountcurfo.dbo.ledger L(nolock), 

                     angelfo.accountcurfo.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

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

                     [EXCHANGE]='MCDX' ,					 ENTEREDBY 

              FROM   angelcommodity.accountmcdx.dbo.ledger L (nolock), 

                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'MCDX' ,					 ENTEREDBY 

              FROM   angelcommodity.accountmcdx.dbo.ledger L(nolock), 

                     angelcommodity.accountmcdx.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

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

                     [EXCHANGE]='MCDXCDS' ,					 ENTEREDBY 

              FROM   angelcommodity.accountmcdxcds.dbo.ledger L (nolock), 

                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'MCDXCDS' ,					 ENTEREDBY 

              FROM   angelcommodity.accountmcdxcds.dbo.ledger L(nolock), 

                     angelcommodity.accountmcdxcds.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

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

                     [EXCHANGE]='NCDX' ,					 ENTEREDBY 

              FROM   angelcommodity.accountncdx.dbo.ledger L (nolock), 

       angelcommodity.accountncdx.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'NCDX' ,					 ENTEREDBY 

              FROM   angelcommodity.accountncdx.dbo.ledger L(nolock), 

                     angelcommodity.accountncdx.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

                     AND L.vdt >= @FROMDATE 

                     AND L.vdt < = @TODATE + ' 23:59'

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

                     [EXCHANGE]='BSECURFO' ,					 ENTEREDBY 

              FROM   angelcommodity.accountCURBFO.dbo.ledger L (nolock), 

                     angelcommodity.accountCURBFO.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'BSECURFO' ,					 ENTEREDBY 

              FROM   angelcommodity.accountCURBFO.dbo.ledger L(nolock), 

                     angelcommodity.accountCURBFO.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

                     AND L.vdt >= @FROMDATE 

                     AND L.vdt < = @TODATE + ' 23:59' 
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

                     [EXCHANGE]='BSEFO' ,					 ENTEREDBY 

              FROM   angelcommodity.accountBFO.dbo.ledger L (nolock), 

                     angelcommodity.accountBFO.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'D' 

                     AND L.vtyp = 17

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

                     'BSECURFO' ,					 ENTEREDBY 

              FROM   angelcommodity.accountBFO.dbo.ledger L(nolock), 

                     angelcommodity.accountBFO.dbo.ledger1 L1 (nolock) 

              WHERE  L.vno = L1.vno 

                     AND L.vtyp = L1.vtyp 

                     AND L.booktype = L1.booktype 

                     AND L.drcr = 'C' 

                     AND L.vtyp = 17

                     AND L.vdt >= @FROMDATE 

                     AND L.vdt < = @TODATE + ' 23:59' 
 

				 

				     )A 



      CREATE CLUSTERED INDEX idx_cl 

        ON #temp ( cltcode, vdt ) 



      SELECT [CLTCODE]=Replace(Ltrim(Rtrim(A.cltcode)), ' ', ''), 

             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.vdt, 103), 103)   AS VDT, 

----			 CONVERT(TIME(0), A.vdt) AS VDT_TIME,

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

  

  

  END

GO
