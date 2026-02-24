-- Object: PROCEDURE dbo.SpSettValanAlBM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpSettValanAlBM    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpSettValanAlBM    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpSettValanAlBM    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpSettValanAlBM    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.SpSettValanAlBM    Script Date: 12/27/00 8:59:04 PM ******/

CREATE proc SpSettValanAlBM (@Sett_No varchar(7),@Sett_Type Varchar(2),@party varchar(10) ) as 
select A.Party_code,BillNo=0,
Sell_buy = ( case when (( select isnull(sum(Amount),0) from albmaccvalan where sett_no = a.sett_no and sett_Type = a.sett_type and sell_buy = 1 and  a.party_code = Party_code )
- ( select isnull(sum(Amount),0) from albmaccvalan where sett_no = a.sett_no and sett_Type = a.sett_type and sell_buy = 2 and  a.party_code = Party_code ) > 0 )  then 
                              1
                   else   2 end ),
a.sett_no,sett_Type='N',s.start_date,s.end_date,s.sec_payin,s.sec_payout,
Amount = abs(( select isnull(sum(Amount),0) from albmaccvalan where sett_no = a.sett_no and sett_Type = a.sett_type and sell_buy = 1 and  a.party_code = Party_code )
- ( select isnull(sum(Amount),0) from albmaccvalan where sett_no = a.sett_no and sett_Type = a.sett_type and sell_buy = 2 and  a.party_code = Party_code ))
from albmaccvalan a,sett_mst s where a.sett_no = @sett_no and a.sett_Type = @sett_type and party_code like @party+'%'
and s.sett_no = a.sett_no and s.sett_type = 'N' and a.sett_type = 'L'
group by A.Party_code,a.sett_no,a.sett_Type,s.start_date,s.end_date,s.sec_payin,s.sec_payout

GO
