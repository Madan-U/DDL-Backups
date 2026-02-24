-- Object: PROCEDURE dbo.PROC_CONSTOCK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC [dbo].[PROC_CONSTOCK] AS

SELECT
	EXCHANGE = 'BSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	NSEScrip_Cd = Convert(Varchar(12),''),
	BSEScrip_Cd = D.SCRIP_CD,
	D.SERIES,
	D.CERTNO,
	Qty = SUM(D.QTY),
	FLAG = 'POOL',
	CL_RATE = Convert(NUMERIC(18,4),0)
INTO
	#DEL
FROM
	BSEDB.DBO.DELTRANS D,
	BSEDB.DBO.DELIVERYDP DP
WHERE
	BCLTDPID = DP.DPCLTNO
	AND BDPID = DP.DPID
	AND DESCRIPTION LIKE '%POOL%'
	AND DRCR = 'D'
	AND FILLER2 = 1
	AND DELIVERED = '0'
	AND D.CERTNO LIKE 'IN%' AND TRTYPE <> 906
	AND D.PARTY_CODE <> 'BROKER'
GROUP BY
	D.PARTY_CODE,
	D.SCRIP_CD,
	D.SERIES,
	D.CERTNO

INSERT INTO
	#DEL
SELECT
	EXCHANGE = 'BSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	NSEScrip_Cd = Convert(Varchar(12),''),
	BSEScrip_Cd = D.SCRIP_CD,
	D.SERIES,
	D.CERTNO,
	QTY=SUM(D.QTY),
	FLAG = 'HOLD',
	CL_RATE = Convert(NUMERIC(18,4),0)
FROM
	BSEDB.DBO.DELTRANS D,
	BSEDB.DBO.DELIVERYDP DP
WHERE
	BCLTDPID = DP.DPCLTNO
	AND BDPID = DP.DPID
	AND DESCRIPTION NOT LIKE '%POOL%'
	AND DRCR = 'D'
	AND FILLER2 = 1
	AND DELIVERED = '0'
	AND D.CERTNO LIKE 'IN%' AND TRTYPE <> 906
	AND D.PARTY_CODE <> 'BROKER'
GROUP BY
	D.PARTY_CODE,
	D.SCRIP_CD,
	D.SERIES,
	D.CERTNO

INSERT INTO
	#DEL
SELECT
	EXCHANGE = 'NSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	D.SCRIP_CD,
	BSEScrip_Cd = Convert(Varchar(12),''),
	D.SERIES,
	D.CERTNO,
	QTY=SUM(D.QTY),
	FLAG = 'POOL',
	CL_RATE = Convert(NUMERIC(18,4),0)
FROM
	MSAJAG.DBO.DELTRANS D,
	MSAJAG.DBO.DELIVERYDP DP
WHERE
	BCLTDPID = DP.DPCLTNO
	AND BDPID = DP.DPID
	AND DESCRIPTION LIKE '%POOL%'
	AND DRCR = 'D'
	AND FILLER2 = 1
	AND DELIVERED = '0'
	AND D.CERTNO LIKE 'IN%' AND TRTYPE <> 906
	AND D.PARTY_CODE <> 'BROKER'
GROUP BY
	D.PARTY_CODE,
	D.SCRIP_CD,
	D.SERIES,
	D.CERTNO

INSERT INTO
	#DEL
SELECT
	EXCHANGE = 'NSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	D.SCRIP_CD,
	BSEScrip_Cd = Convert(Varchar(12),''),
	D.SERIES,
	D.CERTNO,
	QTY=SUM(D.QTY),
	FLAG = 'HOLD',
	CL_RATE = Convert(NUMERIC(18,4),0)
FROM
	MSAJAG.DBO.DELTRANS D,
	MSAJAG.DBO.DELIVERYDP DP
WHERE
	BCLTDPID = DP.DPCLTNO
	AND BDPID = DP.DPID
	AND DESCRIPTION NOT LIKE '%POOL%'
	AND DRCR = 'D'
	AND FILLER2 = 1
	AND DELIVERED = '0'
	AND D.CERTNO LIKE 'IN%' AND TRTYPE <> 906
	AND D.PARTY_CODE <> 'BROKER'
GROUP BY D.PARTY_CODE, D.SCRIP_CD, D.SERIES, D.CERTNO

INSERT INTO #DEL
Select
	EXCHANGE = 'BSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	NSEScrip_Cd = Convert(Varchar(12),''),
	D.SCRIP_CD, D.SERIES, CERTNO = '',
	QTY=SUM(D.QTY),
	FLAG = 'NPAY',
	CL_RATE = Convert(NUMERIC(18,4),0)
From
	Bsedb.dbo.deliveryclt D,
	Bsedb.dbo.sett_mst S
Where
	S.sett_no = D.sett_no
	And S.sett_type = D.sett_type
	And Inout = 'O'
	And Sec_payout >= LEFT(GetDate(),11)
	And D.sett_type Not In ('A', 'X', 'AD', 'AC')
	And Start_date <= LEFT(GetDate(),11) + ' 23:59'
	AND GETDATE() <= LEFT(Sec_payout,11) + ' 13:00'
Group By
	D.PARTY_CODE,
	D.SCRIP_CD,
	D.SERIES

INSERT INTO
	#DEL
Select
	EXCHANGE = 'NSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	D.SCRIP_CD,
	BSEScrip_Cd = Convert(Varchar(12),''),
	D.SERIES,
	CERTNO = '',
	QTY=SUM(D.QTY),
	FLAG = 'NPAY',
	CL_RATE = Convert(NUMERIC(18,4),0)
From
	MSAJAG.dbo.deliveryclt D,
	MSAJAG.dbo.sett_mst S
Where
	S.sett_no = D.sett_no
	And S.sett_type = D.sett_type
	And Inout = 'O'
	And Sec_payout >= LEFT(GetDate(),11)
	And D.sett_type Not In ('A', 'X', 'AD', 'AC')
	And Start_date <= LEFT(GetDate(),11) + ' 23:59'
	AND GETDATE() <= LEFT(Sec_payout,11) + ' 13:00'
Group By
	D.PARTY_CODE,
	D.SCRIP_CD,
	D.SERIES

INSERT INTO
	#DEL
Select
	EXCHANGE = 'BSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	NSEScrip_Cd = Convert(Varchar(12),''),
	D.SCRIP_CD,
	D.SERIES,
	CERTNO = '',
	QTY=D.Qty - SUM(ISNULL(DE.QTY,0)),
	FLAG = 'NSRT',
	CL_RATE = Convert(NUMERIC(18,4),0)
From
	BSEDB.DBO.Sett_Mst S,
	BSEDB.DBO.DeliveryClt D
		Left Outer Join
			BSEDB.DBO.DELTRANS De
			On	(
						De.sett_no = D.sett_no
						And De.sett_type = D.sett_type
						And De.scrip_cd = D.scrip_cd
						And De.series = D.series
						And De.party_code = D.party_code
						And Drcr = 'C'
						And Filler2 = 1
					)
Where
	D.inout = 'I'
	And D.qty > 0
	And D.sett_no = S.sett_no
	And D.sett_type = S.sett_type
	And Sec_payout > LEFT(GetDate(),11)
	And D.sett_type Not In ('A', 'X', 'AD', 'AC')
	And Start_date <= LEFT(GetDate(),11)
Group By
	D.sett_no,
	d.sett_type,
	d.party_code,
	d.scrip_cd,
	d.series,
	d.qty
Having
	D.qty > Sum(isnull(de.qty,0))

INSERT INTO
	#DEL
Select
	EXCHANGE = 'NSE',
	SEGMENT = 'CAPITAL',
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	D.SCRIP_CD,
	BSEScrip_Cd = Convert(Varchar(12),''),
	D.SERIES,
	CERTNO = '',
	QTY=D.Qty - SUM(ISNULL(DE.QTY,0)),
	FLAG = 'NSRT',
	CL_RATE = Convert(NUMERIC(18,4),0)
From
	MSAJAG.DBO.Sett_Mst S,
	MSAJAG.DBO.DeliveryClt D
		Left Outer Join
			MSAJAG.DBO.DELTRANS De
				On	(
							De.sett_no = D.sett_no
							And De.sett_type = D.sett_type
							And De.scrip_cd = D.scrip_cd
							And De.series = D.series
							And De.party_code = D.party_code
							And Drcr = 'C'
							And Filler2 = 1
						)
Where
	D.inout = 'I'
	And D.qty > 0
	And D.sett_no = S.sett_no
	And D.sett_type = S.sett_type
	And Sec_payout >= LEFT(GetDate(),11)
	And D.sett_type Not In ('A', 'X', 'AD', 'AC')
	And Start_date <= LEFT(GetDate(),11)
Group By
	D.sett_no,
	d.sett_type,
	d.party_code,
	d.scrip_cd,
	d.series,
	d.qty
Having
	D.qty > Sum(isnull(de.qty,0))

INSERT INTO
	#DEL
SELECT
	EXCHANGE,
	SEGMENT,
	D.PARTY_CODE,
	LONG_NAME = Convert(Varchar(50),''),
	BRANCH_CD = Convert(Varchar(50),''),
	SUB_BROKER = Convert(Varchar(50),''),
	TRADER = Convert(Varchar(50),''),
	FAMILY = Convert(Varchar(50),''),
	AREA = Convert(Varchar(50),''),
	REGION = Convert(Varchar(50),''),
	CLIENT_CTGRY = Convert(Varchar(50),''),
	DEBITFLAG = Convert(Varchar(50),''),
	ScripName = Convert(Varchar(50),''),
	D.SCRIP_CD,
	BSEScrip_Cd = Convert(Varchar(12),''),
	D.SERIES,
	ISIN,
	QTY=SUM(CASE WHEN DRCR = 'C' THEN QTY ELSE -QTY END),
	FLAG = 'COLL',
	CL_RATE = Convert(NUMERIC(18,4),0)
FROM
	MSAJAG.DBO.C_SECURITIESMST D
WHERE
	PARTY_CODE <> 'BROKER'
GROUP BY
	EXCHANGE,
	SEGMENT,
	D.PARTY_CODE,
	D.SCRIP_CD,
	D.SERIES,
	ISIN
HAVING
	SUM(CASE WHEN DRCR = 'C' THEN QTY ELSE -QTY END) <> 0

UPDATE
	#DEL
SET
	LONG_NAME = LEFT(C1.LONG_NAME, 50),
	BRANCH_CD = C1.BRANCH_CD,
	SUB_BROKER = C1.SUB_BROKER,
	FAMILY = C1.FAMILY,
	TRADER = C1.TRADER,
	AREA = C1.AREA,
	REGION = C1.REGION,
	CLIENT_CTGRY = C2.DUMMY10
FROM
	CLIENT1 C1,
	CLIENT2 C2
WHERE
	C1.CL_CODE = C2.CL_CODE
	AND C2.PARTY_CODE = #DEL.PARTY_CODE

UPDATE
	#DEL
SET
	DEBITFLAG = (CASE WHEN P.DEBITFLAG = 0 THEN 'CHECK DEBIT' WHEN P.DEBITFLAG = 1 THEN 'ALWAYS PAYOUT' ELSE 'TRANSFER TO BEN' END)
FROM
	DELPARTYFLAG P
WHERE
	P.PARTY_CODE = #DEL.PARTY_CODE

UPDATE
	#DEL
SET
	CERTNO = ISIN
FROM
	MULTIISIN M
WHERE
	#DEL.NSESCRIP_CD = M.SCRIP_CD
	AND #DEL.SERIES = M.SERIES
	AND VALID = 1
	AND EXCHANGE = 'NSE'
	AND CERTNO = ''

UPDATE
	#DEL
SET
	CERTNO = ISIN
FROM
	BSEDB.DBO.MULTIISIN M
WHERE
	#DEL.BSESCRIP_CD = M.SCRIP_CD
	AND VALID = 1
	AND EXCHANGE = 'BSE'
	AND CERTNO = ''

UPDATE
	#DEL
SET
	NSESCRIP_CD = M.SCRIP_CD,
	SERIES = M.SERIES
FROM
	MULTIISIN M
WHERE
	M.ISIN = #DEL.CERTNO
	AND VALID = 1
	AND EXCHANGE = 'BSE'
	AND FLAG <> 'COLL'

UPDATE
	#DEL
SET
	BSESCRIP_CD = M.SCRIP_CD
FROM
	BSEDB.DBO.MULTIISIN M
WHERE
	M.ISIN = #DEL.CERTNO
	AND VALID = 1
	AND (EXCHANGE = 'NSE' OR FLAG = 'COLL')

UPDATE
	#DEL
SET
	SCRIPNAME = LEFT(S1.LONG_NAME, 50)
FROM
	SCRIP2 S2,
	SCRIP1 S1
WHERE
	S2.SCRIP_CD = #DEL.NSESCRIP_CD
	AND S2.SERIES = #DEL.SERIES
	AND S2.CO_CODE = S1.CO_CODE
	AND S2.SERIES = S1.SERIES

UPDATE
	#DEL
SET
	SCRIPNAME = LEFT(S1.LONG_NAME, 50)
FROM
	BSEDB.DBO.SCRIP2 S2,
	BSEDB.DBO.SCRIP1 S1
WHERE
	S2.BSECODE = #DEL.BSESCRIP_CD
	AND S2.CO_CODE = S1.CO_CODE
	AND S2.SERIES = S1.SERIES
	AND SCRIPNAME = ''

SELECT
	Scrip_Cd,
	Series='EQ',
	Cl_Rate,
	SysDate
INTO
	#NSE_LatestClosing
FROM
	MSAJAG.DBO.Closing C WITH(NOLOCK)
WHERE
	SYSDATE =	(
							SELECT
								MAX(SYSDATE)
							FROM
								MSAJAG.DBO.Closing WITH(NOLOCK)
							WHERE
								SCRIP_CD = C.SCRIP_CD
								And C.SERIES In ('BE', 'EQ')
						)
	And SERIES In ('BE', 'EQ')

INSERT INTO
	#NSE_LatestClosing
SELECT
	Scrip_Cd,
	Series,
	Cl_Rate,
	SysDate
FROM
	MSAJAG.DBO.Closing C WITH(NOLOCK)
WHERE
	SYSDATE =	(
							SELECT
								MAX(SYSDATE)
							FROM
								MSAJAG.DBO.Closing WITH(NOLOCK)
							WHERE
								SCRIP_CD = C.SCRIP_CD
								And SERIES = C.SERIES
						)
	And SERIES Not In ('BE', 'EQ')

SELECT
	Scrip_Cd,
	Series,
	Cl_Rate,
	SysDate
INTO
	#BSE_LatestClosing
FROM
	BSEDB.DBO.Closing C WITH(NOLOCK)
WHERE
	SYSDATE =	(
							SELECT
								MAX(SYSDATE)
							FROM
								BSEDB.DBO.Closing WITH(NOLOCK)
							WHERE
								SCRIP_CD = C.SCRIP_CD
								And SERIES = C.SERIES
						)

UPDATE
	#DEL
Set
	Cl_Rate = C.Cl_Rate
From
	#NSE_LatestClosing C
Where
	C.Scrip_Cd = #DEL.NSEScrip_Cd
	And C.Series = (Case When #DEL.Series In ('EQ', 'BE') Then 'EQ' Else #DEL.Series End)

Update
	#DEL
Set
	Cl_Rate = C.Cl_Rate
From
	#BSE_LatestClosing C
Where
	C.Scrip_Cd = #DEL.BSEScrip_Cd
	AND #DEL.CL_RATE = 0

DELETE FROM TBL_CONSTOCKREPORT
WHERE RUNDATE LIKE LEFT(GETDATE(),11) + '%'

INSERT INTO
	TBL_CONSTOCKREPORT
SELECT
	PARTY_CODE,
	LONG_NAME,
	NSESCRIP_CD,
	BSESCRIP_CD,
	SCRIPNAME,
	NSEPOOL = SUM(CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' AND FLAG = 'POOL' THEN QTY ELSE 0 END),
	BSEPOOL = SUM(CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' AND FLAG = 'POOL' THEN QTY ELSE 0 END),
	MPAY    = SUM(CASE WHEN FLAG = 'MPAY' THEN QTY ELSE 0 END),
	NPAY    = SUM(CASE WHEN FLAG = 'NPAY' THEN QTY ELSE 0 END),
	MSHRT   = SUM(CASE WHEN FLAG = 'MSRT' THEN QTY ELSE 0 END),
	NSHRT   = SUM(CASE WHEN FLAG = 'NSRT' THEN QTY ELSE 0 END),
	NSEHOLD = SUM(CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' AND FLAG = 'HOLD' THEN QTY ELSE 0 END),
	BSEHOLD = SUM(CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' AND FLAG = 'HOLD' THEN QTY ELSE 0 END),
	NSEMARG = SUM(CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' AND FLAG = 'COLL' THEN QTY ELSE 0 END),
	BSEMARG = SUM(CASE WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' AND FLAG = 'COLL' THEN QTY ELSE 0 END),
	NFOMARG = SUM(CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' AND FLAG = 'COLL' THEN QTY ELSE 0 END),
	MTFHOLD = 0,
	POAHOLD = 0,
	TOTALHOLD = 0,
	CL_RATE,
	HOLDAMT = 0,
	BRANCH_CD,
	SUB_BROKER,
	TRADER,
	AREA,
	REGION,
	FAMILY,
	CLIENT_CTGRY,
	DEBITFLAG,
	CERTNO,
	RUNDATE = GETDATE()
FROM
	#DEL
GROUP BY
	PARTY_CODE,
	LONG_NAME,
	BRANCH_CD,
	SUB_BROKER,
	TRADER,
	AREA,
	REGION,
	FAMILY,
	CLIENT_CTGRY,
	DEBITFLAG,
	NSESCRIP_CD,
	BSESCRIP_CD,
	SCRIPNAME,
	CERTNO,
	CL_RATE

UPDATE
	TBL_CONSTOCKREPORT
SET
	TOTALHOLD = NSEPOOL + BSEPOOL + MPAY + NPAY - MSHRT - NSHRT + NSEHOLD + BSEHOLD + NSEMARG + BSEMARG + NFOMARG + MTFHOLD + POAHOLD,
	HOLDAMT   =(NSEPOOL + BSEPOOL + MPAY + NPAY - MSHRT - NSHRT + NSEHOLD + BSEHOLD + NSEMARG + BSEMARG + NFOMARG + MTFHOLD + POAHOLD) * CL_RATE
WHERE
	RUNDATE LIKE LEFT(GETDATE(),11) + '%'

DROP TABLE #DEL
DROP TABLE #BSE_LatestClosing
DROP TABLE #NSE_LatestClosing

GO
