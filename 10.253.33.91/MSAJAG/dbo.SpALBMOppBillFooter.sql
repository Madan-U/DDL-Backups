-- Object: PROCEDURE dbo.SpALBMOppBillFooter
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpALBMOppBillFooter    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMOppBillFooter    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMOppBillFooter    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMOppBillFooter    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpALBMOppBillFooter    Script Date: 12/27/00 8:59:03 PM ******/

CREATE proc SpALBMOppBillFooter (@Sett_No varchar(10), @Party_Code varchar(10)) as
select pamt =  
ISNULL((case when sell_buy = 2 then 
 sum(TRADEQTY * RATE) end),0),
samt = ISNULL((case when sell_buy = 1 then 
  sum(TRADEQTY *RATE)  end),0),
DelChrg = 0,
Ser = 0 ,
sell_buy = 
( case when sell_buy = 2 then
 1
 else 2 end ),
Party_code 
from tempsettalbmsum
where sett_type = 'L' and party_code = @Party_code and sett_no = @sett_no
group by Sell_buy,party_code

GO
