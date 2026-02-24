-- Object: PROCEDURE dbo.C_calculatefdbg
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_calculatefdbg
@exchange Varchar(3),
@segment Varchar(20),
@partycode Varchar(10),
@trans_date Varchar(11),
@flag Int
As

If @flag = 1 
Begin
Select Isnull(sum(balance),0) Balance, Fm.bank_code, Fm.fd_type,fm.fdr_no, Fm.receive_date, Fm.maturity_date
From Fixeddeposittrans F, Fixeddepositmst Fm
Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
 		       Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no
		       And F1.trans_date <=  @trans_date + ' 23:59' And F1.branch_code = F1.branch_code)
And F.party_code = @partycode And Fm.exchange = @exchange And Fm.segment = @segment And F.branch_code = Fm.branch_code
And Fm.party_code = F.party_code And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status = 'v' And  Fm.active = 1
Group By Fm.bank_code, Fm.fd_type, Fm.fdr_no, Fm.receive_date, Fm.maturity_date
End

If @flag = 2
Begin
Select Isnull(sum(balance),0) Balance, Fm.bank_code ,fm.bg_no, Fm.receive_date, Fm.maturity_date
From Bankguaranteetrans F, Bankguaranteemst Fm
Where F.trans_date = (select Max(f1.trans_date) From Bankguaranteetrans F1
 		       Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.bg_no = F1.bg_no
		       And F1.trans_date <=  @trans_date + ' 23:59' And F1.branch_code = F1.branch_code)
And F.party_code = @partycode And Fm.exchange = @exchange And Fm.segment = @segment And F.branch_code = Fm.branch_code
And Fm.party_code = F.party_code And Fm.bank_code = F.bank_code And Fm.bg_no = F.bg_no And Fm.status = 'v' And  Fm.active = 1
Group By Fm.bank_code, Fm.bg_no, Fm.receive_date, Fm.maturity_date
End

GO
