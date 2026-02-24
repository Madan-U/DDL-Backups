-- Object: PROCEDURE dbo.C_CalculateFDBG
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





CREATE Proc C_CalculateFDBG
@Exchange Varchar(3),
@Segment vARCHAR(20),
@PartyCode Varchar(10),
@Trans_Date Varchar(11),
@Flag int
AS

If @Flag = 1 
Begin
select isnull(sum(balance),0) Balance, fm.Bank_Code, fm.FD_Type,fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date
From FixedDepositTrans F, FixedDepositMst Fm
where F.Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
 		       where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no
		       and f1.Trans_Date <=  @Trans_Date + ' 23:59' and f1.branch_code = f1.branch_code)
and F.Party_Code = @PartyCode and Fm.Exchange = @Exchange and Fm.Segment = @Segment and f.branch_code = fm.branch_code
and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status = 'V' and  fm.Active = 1
Group By fm.Bank_Code, fm.FD_Type, fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date
End

If @Flag = 2
Begin
select isnull(sum(balance),0) Balance, fm.Bank_Code ,fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date
From BankGuaranteeTrans F, BankGuaranteeMst Fm
where F.Trans_Date = (select max(f1.Trans_Date) from BankGuaranteeTrans F1
 		       where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.Bg_no = f1.BG_no
		       and f1.Trans_Date <=  @Trans_Date + ' 23:59' and f1.branch_code = f1.branch_code)
and F.Party_Code = @PartyCode and Fm.Exchange = @Exchange and Fm.Segment = @Segment and f.branch_code = fm.branch_code
and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Bg_no = f.Bg_No and fm.Status = 'V' and  fm.Active = 1
Group By fm.Bank_Code, fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date
End

GO
