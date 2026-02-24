-- Object: PROCEDURE dbo.SpALBMHistBillFooter
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 12/27/00 8:59:03 PM ******/


/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 12/20/2000 12:38:57 PM ******/
/****** Object:  Stored Procedure dbo.SpALBMHistBillFooter    Script Date: 12/8/2000 6:54:50 PM ******/
CREATE proc SpALBMHistBillFooter (@Sett_No varchar(10), @Party_Code varchar(10)) as
select Pamt = isnull((case sell_buy
  when 1 then   sum(tradeqty * (marketrate + brokapplied)) end),0),
samt = isnull((case sell_buy
  when 2 then   sum(tradeqty * (marketrate - brokapplied)) end),0), 
DelChrg=convert(numeric(9,2),isnull(SUM(tradeqty*nbrokapp),0) -
isnull(SUM(tradeqty*brokapplied),0)) ,
Ser = sum(Nsertax),sell_buy,
party_code
FROM History
WHERE sett_no = @Sett_no+1
and Party_code = @Party_code
And Sett_type = 'L' 
GROUP BY SELL_BUY,party_code

GO
