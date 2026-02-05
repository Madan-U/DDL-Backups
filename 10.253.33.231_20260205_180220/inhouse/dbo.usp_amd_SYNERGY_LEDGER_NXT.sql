-- Object: PROCEDURE dbo.usp_amd_SYNERGY_LEDGER_NXT
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

Create procedure usp_amd_SYNERGY_LEDGER_NXT
as
begin

Declare @LD_DT datetime
select @LD_DT=MAX(LD_DT) from SYNERGY_LEDGER_NXT with (nolock)

insert into SYNERGY_LEDGER_NXT 
select ld_clientcd,
	    a.LD_DT,a.LD_PARTICULAR,
		LD_DOCUMENTTYPE,a.LD_DOCUMENTNO,
		DEBIT = CONVERT(DECIMAL(18,2),(CASE WHEN a.LD_DEBITFLAG = 'D' THEN a.LD_AMOUNT ELSE 0 END)),
		CREDIT = CONVERT(DECIMAL(18,2),(CASE WHEN a.LD_DEBITFLAG = 'C' THEN a.LD_AMOUNT ELSE 0 END)),
		BALANCE = CONVERT(DECIMAL(18,2),0)
--into SYNERGY_LEDGER_NXT
from SYNERGY_LEDGER a with (nolock) where LD_DT>@LD_DT

end

GO
