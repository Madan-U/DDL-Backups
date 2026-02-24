-- Object: PROCEDURE dbo.C_rptcollstatementmainsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Proc C_rptcollstatementmainsp 
@exchange Varchar(3),
@segment Varchar(20),
@fromparty Varchar(10),
@toparty Varchar(10),
@bank_code Varchar(15),
@company_code Varchar(15),
@asondate Varchar(11),
@flag Int
As
If @flag = 1 /*for Fd And From Party And To Party And Bank<>'' And Company <>'' Or */
Begin
Select Isnull(sum(balance),0) Balance, Fm.bank_code, Fm.party_code, Fm.exchange, Fm.segment, Fm.fd_type,
Bank_name = Isnull((case When Fm.fd_type = 'b' Then (select Bank_name From Collateralbank C Where 
		C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange  + '%' 
		And C.segment Like @segment  + '%'   and EffDate > @asondate)
	     	Else (select Company_name From Collateralcompany C Where C.company_code = Fm.bank_code 
		And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'   and EffDate > @asondate)	
	     End),''),
Exp_limit =isnull( (case When Fm.fd_type = 'b' Then (select Fd_explimit From Collateralbank C 
		Where C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'   and EffDate > @asondate)
	     	Else (select Fd_explimit From Collateralcompany C Where 
		C.company_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'  and EffDate > @asondate)	
	     End),0),
Party_name = Isnull((select Distinct Short_name From Clientmaster Where Party_code = Fm.party_code),'not Available')
From Fixeddeposittrans F, Fixeddepositmst Fm
Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
		         Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no And  F1.trans_date <= @asondate + ' 23:59:59' 
		         And F1.status <> 'c' And F1.tcode = Fm.tcode And F.branch_code = F1.branch_code)
And F.party_code >= @fromparty And F.party_code <= @toparty And (f.bank_code Like @bank_code + '%'  Or F.bank_code Like @company_code + '%' )
And Fm.exchange Like @exchange + '%'and Fm.segment Like @segment + '%' And Fm.party_code = F.party_code 
And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status <> 'c' /*and Fm.active = 1*/  And F.tcode = Fm.tcode And F.branch_code = Fm.branch_code
And @asondate + ' 23:59:59' >= Receive_date  And @asondate + ' 00:00:00' <= Maturity_date 
Group By Fm.bank_code,fm.fd_type,  Fm.party_code, Fm.exchange, Fm.segment
Having Sum(balance) <> 0
Order By Fm.bank_code
End

If @flag = 2 /*for Fd And From Party And To Party And Bank<>'' And Bankcode <>'' And Company = ''''*/
Begin
Select Isnull(sum(balance),0) Balance, Fm.bank_code, Fm.party_code, Fm.exchange, Fm.segment, Fm.fd_type,
Bank_name = Isnull((case When Fm.fd_type = 'b' Then (select Bank_name From Collateralbank C Where 
		C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange  + '%' 
		And C.segment Like @segment  + '%'   and EffDate > @asondate)
	     	Else (select Company_name From Collateralcompany C Where C.company_code = Fm.bank_code 
		And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' 
		  and EffDate > @asondate)	
	     End),''),
Exp_limit =isnull( (case When Fm.fd_type = 'b' Then (select Fd_explimit From Collateralbank C Where
		 C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange   + '%' 
		 And C.segment Like @segment  + '%'   and EffDate > @asondate)
	     	Else (select Fd_explimit From Collateralcompany C Where C.company_code = Fm.bank_code 
		And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'   and EffDate > @asondate)	
	     End),0),
Party_name = Isnull((select Distinct Short_name From Clientmaster Where Party_code = Fm.party_code),'not Available')
From Fixeddeposittrans F, Fixeddepositmst Fm
Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
		         Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no And  F1.trans_date <= @asondate + ' 23:59:59' 
		         And F1.status <> 'c' And F1.tcode = Fm.tcode And F.branch_code = F1.branch_code)
And F.party_code >= @fromparty And F.party_code <= @toparty And F.bank_code Like @bank_code + '%'  
And Fm.exchange Like @exchange + '%'and Fm.segment Like @segment + '%' And Fm.party_code = F.party_code 
And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status <> 'c' /*and Fm.active = 1*/ And F.tcode = Fm.tcode And F.branch_code = Fm.branch_code
And  @asondate + ' 23:59:59' >= Receive_date  And @asondate + ' 00:00:00' <= Maturity_date 
Group By Fm.bank_code,fm.fd_type,  Fm.party_code, Fm.exchange, Fm.segment
Having Sum(balance) <> 0
Order By Fm.bank_code
End


If @flag = 3 /*for Fd And From Party And To Party And Bank<>'' And Company =''*/
Begin
Select Isnull(sum(balance),0) Balance, Fm.bank_code, Fm.party_code, Fm.exchange, Fm.segment, Fm.fd_type,
Bank_name = Isnull((case When Fm.fd_type = 'b' Then (select Bank_name From Collateralbank C Where 
		C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange  + '%' 
		And C.segment Like @segment  + '%'   and EffDate > @asondate)
	     	Else (select Company_name From Collateralcompany C Where C.company_code = Fm.bank_code 
		And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'   and EffDate > @asondate)	
	     End),''),
Exp_limit =isnull( (case When Fm.fd_type = 'b' Then (select Fd_explimit From Collateralbank C Where C.bank_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' )
	     	Else (select Fd_explimit From Collateralcompany C Where C.company_code = Fm.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' )	
	     End),0),
Party_name = Isnull((select Distinct Short_name From Clientmaster Where Party_code = Fm.party_code),'not Available')
From Fixeddeposittrans F, Fixeddepositmst Fm
Where F.trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
		       Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no And  F1.trans_date <= @asondate + ' 23:59:59' 
		        And F1.status <> 'c' And F1.tcode = Fm.tcode And F.branch_code = F1.branch_code)
And F.party_code >= @fromparty And F.party_code <= @toparty And F.bank_code Like @company_code + '%'  
And Fm.exchange Like @exchange + '%'and Fm.segment Like @segment + '%' And Fm.party_code = F.party_code 
And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no And Fm.status <> 'c' /*and Fm.active = 1*/ And F.tcode = Fm.tcode  And F.branch_code = Fm.branch_code
And @asondate + ' 23:59:59' >= Receive_date  And @asondate + ' 00:00:00' <= Maturity_date 
Group By Fm.bank_code,fm.fd_type,  Fm.party_code, Fm.exchange, Fm.segment
Having Sum(balance) <> 0
Order By Fm.bank_code
End

/*if @flag = 2 *//*for Fd And For All Parties*/
/*begin
Select Isnull(sum(balance),0) Balance, F.bank_code, F.party_code, Fm.exchange, Fm.segment, F.fd_type,
Bank_name = Isnull((case When F.fd_type = 'b' Then (select Bank_name From Collateralbank C Where C.bank_code = F.bank_code And C.active = 1 And C.exchange Like @exchange  + '%'  And C.segment Like @segment  + '%' )
	     	Else (select Company_name From Collateralcompany C Where C.company_code = F.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' )	
	     End),''),
Exp_limit = Isnull((case When F.fd_type = 'b' Then (select Fd_explimit From Collateralbank C Where C.bank_code = F.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' )
	     	Else (select Fd_explimit From Collateralcompany C Where C.company_code = F.bank_code And C.active = 1 And C.exchange Like @exchange   + '%'  And C.segment Like @segment  + '%' )	
	     End),0),
Party_name = Isnull((select Distinct Short_name From Clientmaster Where Party_code = F.party_code),'')
From Fixeddeposittrans F, Fixeddepositmst Fm
Where Trans_date = (select Max(f1.trans_date) From Fixeddeposittrans F1
		     Where F.party_code = F1.party_code And F.bank_code = F1.bank_code And F.fdr_no = F1.fdr_no And  F.trans_date <= @asondate + ' 23:59:59' And F1.status <> 'c')
And (f.bank_code Like @bank_code + '%'  Or F.bank_code Like @company_code + '%') And Fm.exchange Like @exchange + '%' 
And Fm.segment Like @segment + '%' And Fm.party_code = F.party_code And Fm.bank_code = F.bank_code And Fm.fdr_no = F.fdr_no
And Fm.status <> 'c' And Fm.active = 1 And @asondate >= Issue_date + ' 00:00:00' And @asondate <= Maturity_date + ' 23:59:59'
Group By F.bank_code, F.fd_type, F.party_code,fm.exchange, Fm.segment
Order By F.bank_code
End*/

If @flag = 4 /*for Bg And From-to Party*/
Begin
Select Isnull(sum(balance),0) Balance, Bm.bank_code, C.bank_name, Bm.party_code, Bm.exchange, Bm.segment, Fd_type = 'b',
Exp_limit = Isnull((select Bg_explimit From Collateralbank C Where C.bank_code = Bm.bank_code 
		And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'   and EffDate > @asondate),0),
Party_name = Isnull((select Distinct Short_name From Clientmaster Where Party_code = Bm.party_code),'not Available')
From Bankguaranteetrans B, Bankguaranteemst Bm, Collateralbank C
Where B.trans_date = (select Max(b1.trans_date) From Bankguaranteetrans B1
		         Where B.party_code = B1.party_code And B.bank_code = B1.bank_code And B.bg_no = B1.bg_no And  B1.trans_date <= @asondate + ' 23:59:59' 
		         And B1.status <> 'c' And Bm.tcode = B1.tcode And Bm.branch_code = B1.branch_code)
And B.party_code >= @fromparty And B.party_code <= @toparty And B.bank_code Like @bank_code + '%'  
And Bm.exchange Like @exchange + '%'and Bm.segment Like @segment + '%' And Bm.party_code = B.party_code  And  C.exchange Like @exchange + '%' And C.segment Like @segment + '%' 
And Bm.bank_code = B.bank_code And Bm.bg_no = B.bg_no And Bm.status <> 'c' /*and Bm.active = 1*/ And Bm.tcode = B.tcode
And @asondate + ' 23:59:59' >= Receive_date  And @asondate + ' 00:00:00' <= Maturity_date 
And B.bank_code = C.bank_code /*and C.active = 1*/  And Bm.branch_code = B.branch_code
Group By Bm.bank_code, C.bank_name, Bm.party_code, Bm.exchange, Bm.segment
Having Sum(balance) <> 0
Order By Bm.bank_code
End

If @flag = 5 /*for Bg And All Parties*/
Begin
Select Isnull(sum(balance),0) Balance, Bm.bank_code, C.bank_name, Bm.party_code, Bm.exchange, Bm.segment, Fd_type = 'b',
Exp_limit = Isnull((select Bg_explimit From Collateralbank C Where C.bank_code = Bm.bank_code 
		And C.active = 1 And C.exchange Like @exchange   + '%'  
		And C.segment Like @segment  + '%'   and EffDate > @asondate),0),
Party_name = Isnull((select Distinct Short_name From Clientmaster Where Party_code = Bm.party_code),'not Available')
From Bankguaranteetrans B, Bankguaranteemst Bm, Collateralbank C
Where B.trans_date = (select Max(b1.trans_date) From Bankguaranteetrans B1
		         Where B.party_code = B1.party_code And B.bank_code = B1.bank_code And B.bg_no = B1.bg_no And  B1.trans_date <= @asondate + ' 23:59:59' 
		         And B1.status <> 'c' And Bm.tcode = B1.tcode And B1.branch_code = Bm.branch_code)
And B.bank_code Like @bank_code + '%' And Bm.exchange Like @exchange + '%'and Bm.segment Like @segment + '%'  And  C.exchange Like @exchange + '%' And C.segment Like @segment + '%' 
And Bm.party_code = B.party_code And Bm.bank_code = B.bank_code And Bm.bg_no = B.bg_no And Bm.status <> 'c'  And Bm.tcode = B.tcode
And @asondate + ' 23:59:59' >= Receive_date  And @asondate + ' 00:00:00' <= Maturity_date 
/*and Bm.active = 1*/ And B.bank_code = C.bank_code /*and C.active = 1*/ And B.branch_code = Bm.branch_code
Group By Bm.bank_code, C.bank_name, Bm.party_code, Bm.exchange, Bm.segment
Having Sum(balance) <> 0
Order By Bm.bank_code
End

GO
