-- Object: PROCEDURE dbo.C_RptCollStatementMainSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Proc C_RptCollStatementMainSp 
@Exchange Varchar(3),
@Segment Varchar(20),
@FromParty Varchar(10),
@ToParty Varchar(10),
@Bank_Code Varchar(15),
@Company_Code Varchar(15),
@AsOnDate Varchar(11),
@Flag int
As
If @Flag = 1 /*For Fd and From Party And To Party and Bank<>'' and Company <>'' or */
Begin
select isnull(sum(balance),0) Balance, f.Bank_Code, f.Party_Code, Fm.Exchange, Fm.Segment, F.Fd_type,
Bank_Name = isnull((Case When F.Fd_type = 'B' then (select Bank_Name From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange  + '%' and C.Segment like @Segment  + '%' )
	     	else (select Company_Name From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),''),
Exp_Limit =isnull( (Case When F.Fd_type = 'B' then (select FD_ExpLimit From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )
	     	else (select FD_ExpLimit From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),0),
Party_Name = isnull((Select distinct short_name from Clientmaster where party_code = F.Party_code),'')
from FixedDepositTrans F, FixedDepositMst Fm
where Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
		     where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no and  f.trans_date <= @AsOnDate + ' 23:59:59' and F1.status <> 'C')
and f.party_code >= @FromParty and f.party_code <= @ToParty and (f.bank_code like @Bank_Code + '%'  or f.bank_code like @Company_Code + '%' )
and fm.Exchange like @Exchange + '%'and fm.Segment like @Segment + '%' and fm.party_Code = f.party_code 
and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status <> 'C' and fm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
group by f.bank_code,f.Fd_type,  f.party_code, Fm.Exchange, Fm.Segment
Order By f.bank_code
End

If @Flag = 2 /*For Fd and From Party And To Party and Bank<>'' and Company =''*/
Begin
select isnull(sum(balance),0) Balance, f.Bank_Code, f.Party_Code, Fm.Exchange, Fm.Segment, F.Fd_type,
Bank_Name = isnull((Case When F.Fd_type = 'B' then (select Bank_Name From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange  + '%' and C.Segment like @Segment  + '%' )
	     	else (select Company_Name From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),''),
Exp_Limit =isnull( (Case When F.Fd_type = 'B' then (select FD_ExpLimit From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )
	     	else (select FD_ExpLimit From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),0),
Party_Name = isnull((Select distinct short_name from Clientmaster where party_code = F.Party_code),'')
from FixedDepositTrans F, FixedDepositMst Fm
where Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
		     where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no and  f.trans_date <= @AsOnDate + ' 23:59:59' and F1.status <> 'C')
and f.party_code >= @FromParty and f.party_code <= @ToParty and f.bank_code like @Bank_Code + '%'  
and fm.Exchange like @Exchange + '%'and fm.Segment like @Segment + '%' and fm.party_Code = f.party_code 
and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status <> 'C' and fm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
group by f.bank_code,f.Fd_type,  f.party_code, Fm.Exchange, Fm.Segment
Order By f.bank_code
End


If @Flag = 3 /*For Fd and From Party And To Party and Bank<>'' and Company =''*/
Begin
select isnull(sum(balance),0) Balance, f.Bank_Code, f.Party_Code, Fm.Exchange, Fm.Segment, F.Fd_type,
Bank_Name = isnull((Case When F.Fd_type = 'B' then (select Bank_Name From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange  + '%' and C.Segment like @Segment  + '%' )
	     	else (select Company_Name From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),''),
Exp_Limit =isnull( (Case When F.Fd_type = 'B' then (select FD_ExpLimit From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )
	     	else (select FD_ExpLimit From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),0),
Party_Name = isnull((Select distinct short_name from Clientmaster where party_code = F.Party_code),'')
from FixedDepositTrans F, FixedDepositMst Fm
where Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
		     where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no and  f.trans_date <= @AsOnDate + ' 23:59:59' and F1.status <> 'C')
and f.party_code >= @FromParty and f.party_code <= @ToParty and f.bank_code like @Company_Code + '%'  
and fm.Exchange like @Exchange + '%'and fm.Segment like @Segment + '%' and fm.party_Code = f.party_code 
and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No and fm.Status <> 'C' and fm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
group by f.bank_code,f.Fd_type,  f.party_code, Fm.Exchange, Fm.Segment
Order By f.bank_code
End

/*If @Flag = 2 *//*For Fd and For All Parties*/
/*Begin
select isnull(sum(balance),0) Balance, f.Bank_Code, f.Party_Code, Fm.Exchange, Fm.Segment, F.Fd_type,
Bank_Name = isnull((Case When F.Fd_type = 'B' then (select Bank_Name From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange  + '%'  and C.Segment like @Segment  + '%' )
	     	else (select Company_Name From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),''),
Exp_Limit = isnull((Case When F.Fd_type = 'B' then (select FD_ExpLimit From CollateralBank C where C.Bank_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )
	     	else (select FD_ExpLimit From CollateralCompany C where C.Company_code = F.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' )	
	     end),0),
Party_Name = isnull((Select distinct short_name from Clientmaster where party_code = F.Party_code),'')
from FixedDepositTrans F, FixedDepositMst Fm
where Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1
		     where f.party_code = f1.party_code and f.bank_code = f1.bank_code and f.fdr_no = f1.fdr_no and  f.trans_date <= @AsOnDate + ' 23:59:59' and F1.status <> 'C')
and (f.bank_code like @Bank_Code + '%'  or f.bank_code like @Company_Code + '%') and fm.Exchange like @Exchange + '%' 
and fm.Segment like @Segment + '%' and fm.party_Code = f.party_code and fm.Bank_Code = f.Bank_Code and fm.Fdr_no = f.Fdr_No
and fm.Status <> 'C' and fm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
group by f.bank_code, f.Fd_type, f.party_code,Fm.Exchange, Fm.Segment
Order By f.bank_code
End*/

If @Flag = 4 /*For Bg And From-To Party*/
Begin
select isnull(sum(balance),0) Balance, B.Bank_Code, C.Bank_name, B.Party_Code, Bm.Exchange, Bm.Segment, Fd_Type = 'B',
Exp_Limit = isnull((select BG_ExpLimit From CollateralBank C where C.Bank_code = b.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' ),0),
Party_Name = isnull((Select distinct short_name from Clientmaster where party_code = b.Party_code),'')
from BankGuaranteeTrans B, BankGuaranteeMst Bm, CollateralBank C
where Trans_Date = (select max(B1.Trans_Date) from BankGuaranteeTrans B1
		     where B.party_code = B1.party_code and B.bank_code = B1.bank_code and B.bg_no = B1.bg_no and  B.trans_date <= @AsOnDate + ' 23:59:59' and B1.status <> 'C')
and B.party_code >= @FromParty and B.party_code <= @ToParty and B.bank_code like @Bank_Code + '%'  
and Bm.Exchange like @Exchange + '%'and Bm.Segment like @Segment + '%' and Bm.party_Code = B.party_code  and  C.Exchange like @Exchange + '%' and C.Segment like @Segment + '%' 
and Bm.Bank_Code = B.Bank_Code and Bm.Bg_no = B.Bg_No and Bm.Status <> 'C' and Bm.Active = 1 and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
and B.bank_code = C.Bank_Code and C.Active = 1
group by B.bank_code, C.Bank_Name, B.party_code, Bm.Exchange, Bm.Segment
Order By B.bank_code
End

If @Flag = 5 /*For Bg And All Parties*/
Begin
select isnull(sum(balance),0) Balance, B.Bank_Code, C.Bank_Name, B.Party_Code, Bm.Exchange, Bm.Segment, Fd_Type = 'B',
Exp_Limit = isnull((select BG_ExpLimit From CollateralBank C where C.Bank_code = b.Bank_code and C.active = 1 and C.Exchange like @Exchange   + '%'  and C.Segment like @Segment  + '%' ),0),
Party_Name = isnull((Select distinct short_name from Clientmaster where party_code = b.Party_code),'')
from BankGuaranteeTrans B, BankGuaranteeMst Bm, CollateralBank C
where Trans_Date = (select max(B1.Trans_Date) from BankGuaranteeTrans B1
		     where B.party_code = B1.party_code and B.bank_code = B1.bank_code and B.bg_no = B1.bg_no and  B.trans_date <= @AsOnDate + ' 23:59:59' and B1.status <> 'C')
and b.bank_code like @Bank_Code + '%' and Bm.Exchange like @Exchange + '%'and Bm.Segment like @Segment + '%'  and  C.Exchange like @Exchange + '%' and C.Segment like @Segment + '%' 
and Bm.party_Code = B.party_code and Bm.Bank_Code = B.Bank_Code and Bm.Bg_no = B.Bg_No and Bm.Status <> 'C'  and @AsOnDate >= Issue_Date + ' 00:00:00' and @AsOnDate <= Maturity_Date + ' 23:59:59'
and Bm.Active = 1 and B.bank_code = C.Bank_Code and C.Active = 1
group by B.bank_code, C.Bank_Name, B.party_code, Bm.Exchange, Bm.Segment
Order By B.bank_code
End

GO
