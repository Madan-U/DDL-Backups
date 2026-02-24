-- Object: PROCEDURE dbo.SpBillValanHis
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpBillValanHis    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpBillValanHis    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpBillValanHis    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpBillValanHis    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpBillValanHis    Script Date: 12/27/00 8:59:16 PM ******/

CREATE Proc SpBillValanHis  ( @Sett_No varchar(7),@sett_Type Varchar(2)) As
/*insert into AccBill*/
select h.Party_code,h.BillNo,
Sell_buy = ( case  when ( ( select isnull(sum(amount),0) from history where sell_buy = 1
                   and party_code = h.party_code 
                   and sett_no = h.sett_no
                   and sett_Type = h.sett_Type
                   and tradeqty > 0 ) + 
    ( select isnull(SUM(nsertax + tradeqty*(nbrokapp - brokapplied)),0) from history where
                   party_code = h.party_code 
                   and sett_no = h.sett_no
                   and sett_Type = h.sett_Type
                   and tradeqty > 0  )-
                 ( select isnull(sum(amount),0) from history where sell_buy = 2
                   and party_code = h.party_code 
                   and sett_no = h.sett_no
                   and sett_Type = h.sett_Type
                   and tradeqty > 0 ) > 0 )  then 
                              1
                   else   2 end ),
s.sett_no,h.sett_Type,s.start_date,s.end_date,s.sec_payin,s.sec_payout,
        amount = ( select isnull(sum(amount),0) from history where sell_buy = 1
                   and party_code = h.party_code 
                   and sett_no = h.sett_no
                   and sett_Type = h.sett_Type
                   and tradeqty > 0 ) + 
    ( select isnull(SUM(nsertax + tradeqty*(nbrokapp - brokapplied)),0) from history where
                   party_code = h.party_code 
                   and sett_no = h.sett_no
                   and sett_Type = h.sett_Type
                   and tradeqty > 0)-
                 ( select isnull(sum(amount),0) from history where sell_buy = 2
                   and party_code = h.party_code 
                   and sett_no = h.sett_no
                   and sett_Type = h.sett_Type
                   and tradeqty > 0 )
from history H, Sett_Mst s where h.tradeqty > 0 
                     and h.sett_no = s.sett_no
                     and h.sett_type = s.sett_Type
                     and h.sett_no = @sett_no and h.sett_Type = @sett_Type
 and party_code ='59002'
group by h.Party_code,h.BillNo,h.sett_no,h.sett_type,s.sett_no,s.start_date,s.end_date,s.sec_payin,s.sec_payout
update accbill set amount = abs(amount) where sett_no = @sett_no and sett_Type = @sett_Type

GO
