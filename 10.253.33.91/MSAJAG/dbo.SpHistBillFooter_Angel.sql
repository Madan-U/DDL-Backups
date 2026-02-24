-- Object: PROCEDURE dbo.SpHistBillFooter_Angel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  proc SpHistBillFooter_Angel (@Sett_No varchar(10), @Sett_Type varchar(2), @Party_Code varchar(10)) as
select Pamt = isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then
			sum(tradeqty * (marketrate + nbrokapp) + nsertax )  
		else 
	         		sum(tradeqty * (marketrate + nbrokapp))  
		end )
	end),0),
samt = isnull((case sell_buy
  when 2 then  ( case when service_chrg = 1 then
			sum(tradeqty * (marketrate - nbrokapp - nsertax ))  
		else 
	         		sum(tradeqty * (marketrate - nbrokapp ))  
		end )
	end),0), 
DelChrg=convert(numeric(9,2),isnull(SUM(tradeqty*nbrokapp),0) -
isnull(SUM(tradeqty*brokapplied),0)) ,
Ser =  ( case when service_chrg = 0 then
		sum(Nsertax) 
	else
		0 end ),
Turn_Tax = IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Turnover_tax = 1 THEN
				SUM(turn_tax) 
			  else 0 end ) 	
		  else 0 end ),0),
Sebi_Tax = IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Sebi_Turn_tax = 1 THEN
				SUM(Sebi_Tax) 
			  else 0 end ) 	
		  else 0 end ),0),
Ins_chrg = IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Insurance_Chrg = 1 THEN
				SUM(Ins_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
Broker_chrg = IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Brokernote = 1 THEN
				SUM(Broker_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
other_chrg = IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN c2.Other_chrg = 1 THEN
				SUM(S.other_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
sell_buy,S.party_code
FROM History s, Client2 C2,Owner
WHERE S.Party_Code = @PArty_code
and sett_no = @Sett_no
and sett_type = @Sett_Type
and S.Party_code = C2.Party_code
GROUP BY SELL_BUY, s.party_code,service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg

GO
