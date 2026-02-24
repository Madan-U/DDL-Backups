-- Object: PROCEDURE dbo.Rpt_acc_partyledger_Offline
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Procedure Rpt_acc_partyledger_Offline
(
	@Fdate Varchar(11),            /* As Mmm Dd Yyyy */
	@Tdate Varchar(11),            /* As Mmm Dd Yyyy */
	@Fcode Varchar(10),
	@Tcode Varchar(10),
	@Strorder Varchar(6),
	@Selectby Varchar(3),
	@Statusid Varchar(15),
	@Statusname Varchar(15),
	@Strbranch Varchar(10)
)

As

/*========================================================================
Exec Rpt_acc_partyledger 'Sep  1 2006','Sep 21 2006','0','z','ACCODE','VDT','broker','broker','%'
========================================================================*/

Declare
	@@Opendate   As Varchar(11),
	@@SQL AS VARCHAR(2000),
	@@SHAREDB AS VARCHAR(50),
	@@EXCHANGE AS VARCHAR(5),
	@@SEGMENT AS VARCHAR(10)

Set Transaction Isolation Level Read Uncommitted


SELECT TOP 1 
	@@SHAREDB = SHAREDB,
	@@EXCHANGE = EXCHANGE,
	@@SEGMENT = SEGMENT
FROM 
	OWNER
/*getting Last Opening Date */
	If Upper(@Selectby) = 'Vdt'
		Begin
			SELECT
				@@Opendate =
				(
					SELECT
						Left(Convert(Varchar, Isnull(Max(Vdt), 0), 109), 11)
					FROM CLS_LEDGER_REPORTS WITH(NoLock)
					WHERE Vtyp = 18
						AND Vdt < = @Fdate
						AND EXCHANGE = @@EXCHANGE
						AND SEGMENT = @@SEGMENT
				)
		End
	Else
		Begin
			SELECT
				@@Opendate =
				(
					SELECT
						Left(Convert(Varchar, Isnull(Max(Edt), 0), 109), 11)
					FROM CLS_LEDGER_REPORTS WITH(NoLock)
					WHERE Vtyp = 18
						AND Edt < = @Fdate
						AND EXCHANGE = @@EXCHANGE
						AND SEGMENT = @@SEGMENT
				)
		End

	/*creating Blank Table For Opening Balance*/
	CREATE TABLE #oppbalance
	(
		CLTCODE VARCHAR(10),
		OPPBAL MONEY
	)

	/*getting Opening Balance*/
	If @Selectby = 'Vdt'
		Begin
			If @@Opendate = @Fdate
				Begin
					INSERT
					INTO #oppbalance
					SELECT PARTY_CODE,
						Oppbal = Isnull(Sum(DEBIT_AMOUNT - CREDIT_AMOUNT), 0)
					FROM CLS_LEDGER_REPORTS B
					WITH(NoLock)
					WHERE B.PARTY_CODE >= @Fcode
						AND B.PARTY_CODE  <= @Tcode
						AND B.Vdt Like @Fdate + '%'
						AND B.Vtyp = 18
						AND EXCHANGE = @@EXCHANGE
						AND SEGMENT = @@SEGMENT
					GROUP BY PARTY_CODE
				End
			Else
				Begin
					INSERT
					INTO #oppbalance
					SELECT PARTY_CODE,
						Oppbal = Isnull(Sum(DEBIT_AMOUNT - CREDIT_AMOUNT), 0)
					FROM CLS_LEDGER_REPORTS B
					WITH(NoLock)
					WHERE B.PARTY_CODE >= @Fcode
						AND B.PARTY_CODE <= @Tcode
						AND B.Vdt >= @@Opendate + ' 00:00:00'
						AND B.Vdt < @Fdate
						AND EXCHANGE = @@EXCHANGE
						AND SEGMENT = @@SEGMENT
					GROUP BY PARTY_CODE
				End
		End
	Else
		Begin
			If @@Opendate = @Fdate
				Begin
					INSERT
					INTO #oppbalance
					SELECT Cltcode,
						Opbal = Sum(Opbal)
					FROM
						(SELECT Cltcode = PARTY_CODE,
							Opbal = Isnull(Sum(DEBIT_AMOUNT - CREDIT_AMOUNT), 0)
						FROM CLS_LEDGER_REPORTS
						WITH(NoLock)
						WHERE PARTY_CODE >= @Fcode
							AND PARTY_CODE <= @TCODE
							AND Edt Like @@Opendate + '%'
							AND EXCHANGE = @@EXCHANGE
							AND SEGMENT = @@SEGMENT
							AND Vtyp = 18
						GROUP BY PARTY_CODE
					UNION ALL
					SELECT
					Cltcode = PARTY_CODE,
					Oppbal  = Isnull(Sum(DEBIT_AMOUNT - CREDIT_AMOUNT), 0)
					FROM CLS_LEDGER_REPORTS B
					WITH(NoLock)
					WHERE B.PARTY_CODE >= @Fcode
						AND B.PARTY_CODE <= @Tcode
						AND B.EXCHANGE = @@EXCHANGE
						AND B.SEGMENT = @@SEGMENT
						AND B.Vdt < @@Opendate
						AND B.Edt >= @@Opendate
					GROUP BY PARTY_CODE
					) T
					GROUP BY Cltcode
				End
			Else
				Begin
					INSERT
					INTO #oppbalance
					SELECT
						Cltcode,
						Opbal = Sum(Opbal)
					FROM
					(
						SELECT Cltcode = PARTY_CODE,
							Opbal = Isnull(Sum(DEBIT_AMOUNT - CREDIT_AMOUNT), 0)
						FROM CLS_LEDGER_REPORTS B
						WITH(NoLock)
						WHERE B.PARTY_CODE >= @Fcode
							AND B.PARTY_CODE <= @Tcode
							AND B.EXCHANGE = @@EXCHANGE
							AND B.SEGMENT = @@SEGMENT
							AND B.Edt Like @@Opendate + '%'
							AND B.Vtyp = 18
						GROUP BY PARTY_CODE
						UNION ALL
						SELECT Cltcode = PARTY_CODE,
							Opbal =  Isnull(Sum(DEBIT_AMOUNT - CREDIT_AMOUNT), 0)
						FROM CLS_LEDGER_REPORTS B
						WITH(NoLock)
						WHERE B.PARTY_CODE >= @Fcode
							AND B.PARTY_CODE <= @Tcode
							AND B.EXCHANGE = @@EXCHANGE
							AND B.SEGMENT = @@SEGMENT
							AND B.Edt >= @@Opendate + ' 00:00:00'
							AND B.Edt < @Fdate
							AND B.Vtyp <> 18
						GROUP BY PARTY_CODE
						UNION ALL
						SELECT Cltcode = PARTY_CODE,
							Oppbal = Isnull(Sum(CREDIT_AMOUNT - DEBIT_AMOUNT), 0)
						FROM CLS_LEDGER_REPORTS B
						WITH(NoLock)
						WHERE B.PARTY_CODE >= @Fcode
							AND B.PARTY_CODE <= @Tcode
							AND B.EXCHANGE = @@EXCHANGE
							AND B.SEGMENT = @@SEGMENT
							AND B.Vdt < @@Opendate
							AND B.Edt >= @@Opendate
							AND B.Vtyp <> 18
						GROUP BY PARTY_CODE
					) T
					GROUP BY Cltcode
				End
		End

	/*generating Blank Structure For Filtered Ledger */

	CREATE TABLE [#ledgerdata]
		(
		VTYP SMALLINT NOT NULL,
		VNO VARCHAR (12) NOT NULL,
		EDT DATETIME NULL,
		LNO DECIMAL(4, 0) NOT NULL,
		ACNAME VARCHAR (100) NOT NULL,
		DRCR CHAR (1) NULL,
		DRAMT MONEY NULL,
		CRAMT MONEY NULL,
		VDT DATETIME NULL,
		VNO1 VARCHAR (12) NULL,
		REFNO CHAR (12) NULL,
		BALAMT MONEY NOT NULL,
		NODAYS INT NULL,
		CDT DATETIME NULL,
		CLTCODE VARCHAR (10) NOT NULL,
		BOOKTYPE CHAR (2) NOT NULL,
		ENTEREDBY VARCHAR (25) NULL,
		PDT DATETIME NULL,
		CHECKEDBY VARCHAR (25) NULL,
		ACTNODAYS INT NULL,
		NARRATION VARCHAR (234) NULL,
		DDNO VARCHAR(15) NULL,
		SHORTDESC VARCHAR(35)
		)

	/*getting Fiiltered Ledger*/
	If @Selectby = 'Vdt'
		Begin
			INSERT
			INTO #ledgerdata
			SELECT VTYP,
				VNO,
				EDT,
				LNO = 0,
				PARTY_NAME,
				DRCR = CASE WHEN DEBIT_AMOUNT <> 0 THEN 'D' ELSE 'C' END,
				DRAMT = DEBIT_AMOUNT,
				CRAMT = CREDIT_AMOUNT,
				VDT,
				VNO1    = VNO,
				REFNO   = '',
				BALAMT  = 0,
				NODAYS  = 0,
				CDT     = GETDATE(),
				CLTCODE = PARTY_CODE,
				BOOKTYPE,
				ENTEREDBY = 'SYSTEM',
				PDT       = GETDATE(),
				CHECKEDBY = 'SYSTEM',
				ACTNODAYS = 0,
				L.NARRATION,
				DDNO = CHEQUE_NO,
				SHORTDESC = ISNULL(V.SHORTDESC, '')
			FROM CLS_LEDGER_REPORTS L WITH(	NoLock),
				Vmast V WITH(	NoLock)
			WHERE L.Vdt >= @Fdate + ' 00:00:00'
				AND L.Vtyp = V.Vtype
				AND L.Vdt <= @Tdate +' 23:59:59'
				AND L.PARTY_CODE >= @Fcode
				AND L.PARTY_CODE <= @Tcode
				AND L.VTYP <> 18
				AND L.EXCHANGE = @@EXCHANGE
				AND L.SEGMENT = @@SEGMENT
		End
	Else
		Begin
			INSERT
			INTO #ledgerdata
			SELECT VTYP,
				VNO,
				EDT,
				LNO = 0,
				PARTY_NAME,
				DRCR = CASE WHEN DEBIT_AMOUNT <> 0 THEN 'D' ELSE 'C' END,
				DRAMT = DEBIT_AMOUNT,
				CRAMT = CREDIT_AMOUNT,
				VDT,
				VNO1    = VNO,
				REFNO   = '',
				BALAMT  = 0,
				NODAYS  = 0,
				CDT     = GETDATE(),
				CLTCODE = PARTY_CODE,
				BOOKTYPE,
				ENTEREDBY = 'SYSTEM',
				PDT       = GETDATE(),
				CHECKEDBY = 'SYSTEM',
				ACTNODAYS = 0,
				L.NARRATION,
				DDNO = CHEQUE_NO,
				SHORTDESC = ISNULL(V.SHORTDESC, '')
			FROM CLS_LEDGER_REPORTS L WITH(	NoLock),
				Vmast V WITH(	NoLock)
			WHERE Edt > = @Fdate + ' 00:00:00'
				AND L.Vtyp = V.Vtype
				AND L.Edt < = @Tdate +' 23:59:59'
				AND L.PARTY_CODE > = @Fcode
				AND L.PARTY_CODE < = @Tcode
				AND L.EXCHANGE = @@EXCHANGE
				AND L.SEGMENT = @@SEGMENT
		End

	/*getting Client List*/
	CREATE TABLE #ledgerclients (PARTY_CODE VARCHAR(10), LONG_NAME VARCHAR(100))

	SELECT @@SQL = "INSERT INTO #ledgerclients SELECT "
	SELECT @@SQL = @@SQL + "		C2.Party_code, "
	SELECT @@SQL = @@SQL + "		C1.LONG_NAME "
	SELECT @@SQL = @@SQL + "      FROM " + @@SHAREDB + ".Dbo.Client1 C1 WITH(NoLock), "
	SELECT @@SQL = @@SQL + "            " + @@SHAREDB + ".Dbo.Client2 C2 WITH(NoLock) "
	SELECT @@SQL = @@SQL + "      LEFT OUTER JOIN "
	SELECT @@SQL = @@SQL + "            " + @@SHAREDB + ".Dbo.Client4 C4 WITH(NoLock) "
	SELECT @@SQL = @@SQL + "            ON (C2.Party_code = C4.Party_code AND Depository Not In ('Nsdl', 'Cdsl') AND Defdp = 1) "
	SELECT @@SQL = @@SQL + "      WHERE C1.Cl_code = C2.Cl_code "
	SELECT @@SQL = @@SQL + "	AND '" + @Statusname + "' =  "
	SELECT @@SQL = @@SQL + "			CASE '" + @STATUSID + "' WHEN 'BRANCH' THEN C1.BRANCH_CD "
	SELECT @@SQL = @@SQL + "			WHEN 'AREA' THEN C1.AREA "
	SELECT @@SQL = @@SQL + "			WHEN 'REGION' THEN C1.REGION "
	SELECT @@SQL = @@SQL + "			WHEN 'SUBBROKER' THEN C1.SUB_BROKER "
	SELECT @@SQL = @@SQL + "			WHEN 'TRADER' THEN C1.TRADER "
	SELECT @@SQL = @@SQL + "			WHEN 'FAMILY' THEN C1.FAMILY "
	SELECT @@SQL = @@SQL + "			WHEN 'CLIENT' THEN C2.Party_code "
	SELECT @@SQL = @@SQL + "			WHEN 'PARTY' THEN C2.Party_code "
	SELECT @@SQL = @@SQL + "			ELSE 'BROKER' END "
	SELECT @@SQL = @@SQL + "            AND C2.Party_code > = '" + @Fcode + "' "
	SELECT @@SQL = @@SQL + "            AND C2.Party_code < = '" + @Tcode + "' "
	EXEC (@@SQL)

	CREATE TABLE [#tmpledger]
	(
		[Booktype] [char] (2)  NULL ,
		[Voudt] [datetime] NULL ,
		[Effdt] [datetime] NULL ,
		[Shortdesc] [varchar] (35)  NULL ,
		[Dramt] [money] NULL ,
		[Cramt] [money] NULL ,
		[Vno] [varchar] (12)  NULL ,
		[Ddno] [varchar] (15)  NULL ,
		[Narration] [varchar] (234)  NULL ,
		[Cltcode] [varchar] (10)  NULL ,
		[Vtyp] [smallint] NULL ,
		[Vdt] [varchar] (30)  NULL ,
		[Edt] [varchar] (30)  NULL ,
		[Acname] [varchar] (100)  NULL ,
		[Opbal] [money] NULL ,
		[L_address1] [varchar] (40)  NULL ,
		[L_address2] [varchar] (40)  NULL ,
		[L_address3] [varchar] (40)  NULL ,
		[L_city] [varchar] (40)  NULL ,
		[L_zip] [varchar] (10)  NULL ,
		[Res_phone1] [varchar] (15)  NULL ,
		[Branch_cd] [varchar] (10)  NULL ,
		[Crosac] [varchar] (10)  NULL ,
		[Ediff] [int] NULL ,
		[Family] [varchar] (10)  NULL ,
		[Sub_broker] [varchar] (10)  NULL ,
		[Trader] [varchar] (20)  NULL ,
		[Cl_type] [varchar] (3)  NULL ,
		[Bank_name] [varchar] (16)  NULL ,
		[Cltdpid] [varchar] (16)  NULL ,
		[Lno] [smallint] NULL
	)

	/*getting Lddger Entries*/
	INSERT
	INTO #tmpledger
	SELECT L.Booktype,
		Voudt = L.Vdt,
		Effdt = L.Edt,
		L.Shortdesc,
		Dramt,
		Cramt,
		L.Vno,
		Ddno,
		L.Narration,
		C.Party_code,
		L.Vtyp,
		Convert(Varchar, L.Vdt, 103) Vdt,
		Convert(Varchar, L.Edt, 103) Edt,
		Acname = C.LONG_NAME,
		Opbal = (DRAMT + CRAMT),
		L_address1 = '',
		L_address2 = '',
		L_address3 = '',
		L_city = '',
		L_zip = '',
		Res_phone1 = '',
		Branch_cd = '',
		Crosac = '',
		Ediff = Datediff(D, L.Edt, Getdate()),
		Family = '',
		Sub_broker = '',
		Trader = '',
		Cl_type = '',
		Bank_name = '',
		Cltdpid = '',
		Lno
	FROM #ledgerdata L WITH(NoLock)
	RIGHT OUTER JOIN #ledgerclients C WITH(NoLock) ON (L.Cltcode = C.Party_code )

	/*updating Opening Blanace*/
	UPDATE
		#tmpledger
		SET Opbal = 0

	UPDATE
		#tmpledger
		SET Opbal = T.Oppbal
	FROM #tmpledger L WITH(NoLock),
		#oppbalance T WITH(NoLock)
	WHERE L.Cltcode = T.Cltcode

      If @Strorder = 'Accode'
		Begin
			If @Selectby = 'Vdt'
				Begin
					SELECT
						L.*
					FROM #tmpledger L WITH(NoLock),
						Acmast A WITH(NoLock)
					WHERE L.Cltcode = A.Cltcode
						AND Accat In ('4', '104')
						AND (cramt <> 0 or dramt <> 0 or opbal <> 0)
					ORDER BY L.Cltcode,
						Voudt
				End
			Else
				Begin
					SELECT
						L.*
					FROM #tmpledger L WITH(NoLock),
						Acmast A WITH(NoLock)
					WHERE L.Cltcode = A.Cltcode
						AND Accat In ('4', '104')
					ORDER BY L.Cltcode,
						Effdt
				End
		End
	Else
		Begin
			If @Selectby = 'Vdt'
				Begin
					SELECT
						L.*
					FROM #tmpledger L WITH(NoLock),
						Acmast A WITH(NoLock)
					WHERE L.Cltcode = A.Cltcode
						AND Accat In ('4', '104')
					ORDER BY L.Acname,
						Voudt
				End
			Else
				Begin
					SELECT
						L.*
					FROM #tmpledger L WITH(NoLock),
						Acmast A WITH(NoLock)
					WHERE L.Cltcode = A.Cltcode
						AND Accat In ('4', '104')
					ORDER BY L.Acname,
						Effdt
				End
		End

/*  ------------------------------   End Of The Proc  -------------------------------------*/

GO
