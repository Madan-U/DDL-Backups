-- Object: PROCEDURE dbo.C_RptCollStatementDetailSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE Proc C_RptCollStatementDetailSp 
@Exchange Varchar(3),
@Segment Varchar(20),
@FromParty Varchar(10),
@Bank_Code Varchar(15),
@AsOnDate Varchar(11),
@Flag int
As
If @Flag = 1 
Begin
select sum(f.Balance) Amount, f.Bank_Code, f.Party_Code, F.Fd_type, F.Fdr_no, convert(varchar,Fm.Issue_Date,103) Issue_Date,convert(varchar, F.Trans_Date,103) Trans_Date,
convert(varchar,Fm.Maturity_Date,103) Maturity_Date, convert(varchar,Fm.Receive_Date,103) Receive_Date,
Bank_Name = (Case When F.Fd_type = 'B' then (select Bank_Name From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )
	     	else (select Company_Name From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange  + '%'  and C.Segment like @Segment  + '%' )	
	     end),
Party_Name = (Select distinct short_name from Clientmaster where party_code = F.Party_code),
Branch_name=isnull((select Branch_name from C_Bank_Branch_master  C where C.Bank_code =  F.Bank_Code and C.Branch_Code =  F.Branch_Code and C.active = 1 and C.Exchange  like  @Exchange  + '%'  and C.Segment like @Segment  + '%' ),''),F.Branch_code
from FixedDepositTrans F, FixedDepositMst Fm
where Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
		     where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no and  f.trans_date <= @AsOnDate + ' 23:59:59'  and f1.Status <> 'C')
and f.party_code = @FromParty and f.bank_code like @Bank_Code + '%'  
and fm.Exchange like @Exchange + '%'and fm.Segment like @Segment + '%' and fm.party_Code = f.party_code 
and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status <> 'C' and fm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
group by f.bank_code,f.Fd_type, f.party_code, F.Fdr_no, Fm.Issue_Date,  Fm.Maturity_Date, Fm.Receive_Date,F.Branch_code, F.Trans_Date
Order By f.bank_code
End
If @Flag = 2 
Begin
select sum(f.Balance) Amount, f.Bank_Code, f.Party_Code, FDR_no = F.bg_no, convert(varchar,Fm.Issue_Date,103) Issue_Date, convert(varchar,F.Trans_Date,103) Trans_Date,
convert(varchar,Fm.Maturity_Date,103) Maturity_Date, convert(varchar,Fm.Receive_Date,103) Receive_Date,
Bank_Name = (select Bank_Name From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange = @Exchange  and C.Segment = @Segment ),	     	
Party_Name = (Select distinct short_name from Clientmaster where party_code = F.Party_code),
Branch_name=isnull((select Branch_name from C_Bank_Branch_master  C where C.Bank_code =  F.Bank_Code and C.Branch_Code =  F.Branch_Code and C.active = 1 and C.Exchange like @Exchange  + '%'  and C.Segment like @Segment  + '%' ),''),F.Branch_code
from BankGuaranteeTrans F, BankGuaranteeMst  Fm
where Trans_Date = (select max(f1.Trans_Date) from BankGuaranteeTrans F1
		     where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.bg_no = f1.bg_no and  f.trans_date <= @AsOnDate + ' 23:59:59'  and f1.Status <> 'C')
and f.party_code = @FromParty and f.bank_code like @Bank_Code + '%'  
and fm.Exchange like @Exchange + '%'and fm.Segment like @Segment + '%' and fm.party_Code = f.party_code 
and fm.Bank_Code = f.Bank_Code and fm.bg_no = f.bg_No and fm.Status <> 'C' and fm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
group by f.bank_code, f.party_code, F.bg_no, Fm.Issue_Date,  Fm.Maturity_Date, Fm.Receive_Date,F.Branch_code, F.Trans_Date
Order By f.bank_code
End

GO
