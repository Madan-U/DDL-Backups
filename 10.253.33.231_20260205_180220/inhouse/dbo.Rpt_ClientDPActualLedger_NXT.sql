-- Object: PROCEDURE dbo.Rpt_ClientDPActualLedger_NXT
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------


CREATE PROCEDURE [dbo].[Rpt_ClientDPActualLedger_NXT]
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
		DEBIT,	CREDIT ,	BALANCE 
	INTO #TEMP1
	FROM SYNERGY_LEDGER_NXT a WITH(NOLOCK)
	join (
			SELECT Client_CODE 			
			FROM INHOUSE.dbo.Vw_Acc_Curr_Bal WITH(NOLOCK)
			WHERE party_code=@Client
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
