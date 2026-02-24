-- Object: PROCEDURE dbo.BillFooter
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillFooter    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillFooter    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillFooter    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillFooter    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillFooter    Script Date: 12/27/00 8:58:43 PM ******/

CREATE proc BillFooter (@Sett_No varchar(10), @Sett_Type varchar(2), @BillNo varchar(6)) as
select Pamt = isnull((case sell_buy
  when 1 then sum(TradeQty*(marketrate + brokapplied)) end),0),
samt = isnull((case sell_buy
  when 2 then sum(TradeQty*(marketrate - brokapplied)) end),0), 
DelChrg=convert(numeric(9,2),isnull(SUM(tradeqty*nbrokapp),0) -
isnull(SUM(tradeqty*brokapplied),0)) ,
Ser = sum(Nsertax),sell_buy,
party_code
FROM SETTLEMENT
WHERE BILLNO =@billno
and sett_no = @Sett_no
and sett_type = @Sett_Type
GROUP BY SELL_BUY,party_code
union
select Pamt = isnull((case sell_buy
  when 1 then sum(TradeQty*(marketrate + brokapplied)) end),0),
samt = isnull((case sell_buy
  when 2 then sum(TradeQty*(marketrate - brokapplied)) end),0), 
DelChrg=convert(numeric(9,2),isnull(SUM(tradeqty*nbrokapp),0) -
isnull(SUM(tradeqty*brokapplied),0)) ,
Ser = sum(Nsertax),sell_buy,
party_code
FROM History
WHERE BILLNO =@billno
and sett_no = @Sett_no
and sett_type = @Sett_Type
GROUP BY SELL_BUY,party_code

GO
