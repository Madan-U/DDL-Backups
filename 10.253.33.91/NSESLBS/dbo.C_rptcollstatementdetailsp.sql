-- Object: PROCEDURE dbo.C_rptcollstatementdetailsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE  Proc C_rptcollstatementdetailsp 
@exchange Varchar(3),
@segment Varchar(20),
@fromparty Varchar(10),
@bank_code Varchar(15),
@asondate Varchar(11),
@flag Int
As
If @flag = 1 
Begin


Select Sum(f.balance) Amount, Fm.bank_code, Fm.party_code, Fm.fd_type, Fm.fdr_no, Convert(varchar,fm.issue_date,103) Issue_date,convert(varchar, F.trans_date,103) Trans_date,
Convert(varchar,fm.maturity_date,103) Maturity_date, Convert(varchar,fm.receive_date,103) Receive_date,
Bank_name = (case When Fm.fd_type = 'b' Then (select Bank_name From Collateralbank C Where C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' )
	     	Else (select Company_name From Collateralcompany C Where C.company_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange  + '%'  And C.segment Like @segment  + '%' )	
	     End),
Party_name = (select Distinct Short_name From Clientmaster Where Party_code = Fm.party_code),
Branch_name=isnull((select Branch_name From C_bank_branch_master  C Where C.bank_code =  Fm.bank_code And C.branch_code =  Fm.branch_code And C.active = 1 And C.exchange  Like  @exchange  + '%'  And C.segment Like @segment  + '%' ),''),fm.branch_code
From Fixeddeposittrans F, Fixeddepositmst Fm
Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
		     Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no And  F1.trans_date <= @asondate + ' 23:59:59'  And F1.status <> 'c' And F1.tcode = Fm.tcode)
And F.party_code = @fromparty And F.bank_code Like @bank_code + '%'  
And Fm.exchange Like @exchange + '%'and Fm.segment Like @segment + '%' And Fm.party_code = F.party_code 
And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status <> 'c' /*and Fm.active = 1*/ And F.tcode = Fm.tcode
And @asondate + ' 23:59:59' >= Receive_date And @asondate + ' 00:00:00'  <= Maturity_date 
Group By Fm.bank_code,fm.fd_type, Fm.party_code, Fm.fdr_no, Fm.issue_date,  Fm.maturity_date, Fm.receive_date,fm.branch_code, F.trans_date
Order By Fm.bank_code
End
If @flag = 2 
Begin
Select Sum(f.balance) Amount, Fm.bank_code, Fm.party_code, Fdr_no = Fm.bg_no, Convert(varchar,fm.issue_date,103) Issue_date, Convert(varchar,f.trans_date,103) Trans_date,
Convert(varchar,fm.maturity_date,103) Maturity_date, Convert(varchar,fm.receive_date,103) Receive_date,
Bank_name = (select Bank_name From Collateralbank C Where C.bank_code = Fm.bank_code And C.active = 1 And C.exchange = @exchange  And C.segment = @segment ),	     	
Party_name = (select Distinct Short_name From Clientmaster Where Party_code = Fm.party_code),
Branch_name=isnull((select Branch_name From C_bank_branch_master  C Where C.bank_code =  Fm.bank_code And C.branch_code =  Fm.branch_code And C.active = 1 And C.exchange Like @exchange  + '%'  And C.segment Like @segment  + '%' ),''),fm.branch_code
From Bankguaranteetrans F, Bankguaranteemst  Fm
Where F.trans_date = (select Max(f1.trans_date) From Bankguaranteetrans F1
		     Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.bg_no = F1.bg_no And  F1.trans_date <= @asondate + ' 23:59:59'  And F1.status <> 'c' And F1.tcode = Fm.tcode)
And F.party_code = @fromparty And F.bank_code Like @bank_code + '%'  
And Fm.exchange Like @exchange + '%'and Fm.segment Like @segment + '%' And Fm.party_code = F.party_code 
And Fm.bank_code = F.bank_code And Fm.bg_no = F.bg_no And Fm.status <> 'c' /*and Fm.active = 1*/ And F.tcode = Fm.tcode
And @asondate + ' 23:59:59' >= Receive_date And @asondate + ' 00:00:00'  <= Maturity_date 
Group By Fm.bank_code, Fm.party_code, Fm.bg_no, Fm.issue_date,  Fm.maturity_date, Fm.receive_date,fm.branch_code, F.trans_date
Order By Fm.bank_code
End

GO
