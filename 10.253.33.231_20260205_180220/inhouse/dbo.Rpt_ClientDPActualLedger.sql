-- Object: PROCEDURE dbo.Rpt_ClientDPActualLedger
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

/*****************************************************************************
CREATED BY :: Sushant Nagarkar
CREATED DATE :: 03 NOV 2012
PRUPOSE :: To Get Client DP Actual Leger
*****************************************************************************/
--Rpt_ClientDPActualLedger 'A102344','HOCBHO','SB','CBHO'
--Rpt_ClientDPActualLedger 'S74162','BVIDDPM','SB','DDPM'


CREATE PROCEDURE [dbo].[Rpt_ClientDPActualLedger]
@Client VARCHAR(30),
@userid VARCHAR(20)='',
@Access_To VARCHAR(20)='BROKER',
@Access_Code VARCHAR(20)='CSO'
AS
BEGIN

    if ltrim(rtrim(isnull(@Client,''))) = ''
	 return

	SELECT [Ledger Date] = a.LD_DT,Particulars = a.LD_PARTICULAR,
		[DocType] = a.LD_DOCUMENTTYPE,DocumentNo = a.LD_DOCUMENTNO,
		DEBIT = CONVERT(DECIMAL(18,2),(CASE WHEN a.LD_DEBITFLAG = 'D' THEN a.LD_AMOUNT ELSE 0 END)),
		CREDIT = CONVERT(DECIMAL(18,2),(CASE WHEN a.LD_DEBITFLAG = 'C' THEN a.LD_AMOUNT ELSE 0 END)),
		BALANCE = CONVERT(DECIMAL(18,2),0)
	INTO #TEMP1
	FROM INHOUSE.dbo.SYNERGY_LEDGER a WITH(NOLOCK)
	join (
			SELECT Client_CODE 
			FROM INHOUSE.dbo.Vw_Acc_Curr_Bal WITH(NOLOCK)
			WHERE party_code=@Client--'A102344'--@Client

		 ) b
	on a.ld_clientcd = b.Client_CODE
	
	SELECT ROW_NUMBER() OVER(ORDER BY [Ledger Date]) ID,
		[Ledger Date],Particulars,[DocType],DocumentNo,DEBIT,CREDIT,BALANCE
	INTO #TEMP
	FROM #TEMP1
	order by 2
	
	DECLARE @Bal DECIMAL(18,2)

	SET @Bal = 0

	UPDATE  #TEMP
	SET @Bal = BALANCE = @Bal + (CREDIT - DEBIT)

	SELECT [Ledger Date],Particulars,DocType,DocumentNo,DEBIT,CREDIT,BALANCE FROM #TEMP
	ORDER BY [Ledger Date]


END

GO
