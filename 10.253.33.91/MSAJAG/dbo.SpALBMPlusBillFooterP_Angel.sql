-- Object: PROCEDURE dbo.SpALBMPlusBillFooterP_Angel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpALBMPlusBillFooterP    Script Date: 12/20/2000 12:38:57 PM ******/
/****** Object:  Stored Procedure dbo.SpALBMPlusBillFooterP    Script Date: 12/8/2000 6:54:51 PM ******/
CREATE proc SpALBMPlusBillFooterP_Angel (@Sett_No varchar(10), @Party_Code varchar(10)) as
select Pamt = isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then
			sum(tradeqty * (marketrate + nbrokapp) + nsertax )  
		else 
	         		sum(tradeqty * (marketrate + nbrokapp))  
		end )
	end),0),
samt = isnull((case sell_buy
  when 2 then  ( case when service_chrg = 1 then
			sum(tradeqty * (marketrate - nbrokapp) - nsertax )  
		else 
	         		sum(tradeqty * (marketrate - nbrokapp) )  
		end )
	end),0), 
DelChrg=convert(numeric(9,2),isnull(SUM(tradeqty*nbrokapp),0) -
isnull(SUM(tradeqty*brokapplied),0)) ,
Ser = ( case when service_chrg = 0 then
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
sell_buy,s.party_code
FROM SETTLEMENT S, Client2 C2,Owner
WHERE sett_no = ( select min(sett_no) from sett_mst where sett_no > @sett_no and sett_Type = 'W' )
and S.Party_code = @Party_code
And Sett_type = 'P' 
and C2.Party_code = S.Party_code
GROUP BY SELL_BUY,s.party_code, Service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg
union all
select Pamt = isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then
			sum(tradeqty * (marketrate + nbrokapp) + nsertax )  
		else 
	         		sum(tradeqty * (marketrate + nbrokapp))  
		end )
	end),0),
samt = isnull((case sell_buy
  when 2 then  ( case when service_chrg = 1 then
			sum(tradeqty * (marketrate - nbrokapp) - nsertax )  
		else 
	         		sum(tradeqty * (marketrate - nbrokapp) )  
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
sell_buy,s.party_code
FROM History S, Client2 C2,Owner
WHERE sett_no = ( select min(sett_no) from sett_mst where sett_no > @sett_no and sett_Type = 'W' )
and S.Party_code = @Party_code
And Sett_type = 'P' 
and C2.Party_code = S.Party_code
GROUP BY SELL_BUY,s.party_code, Service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg

GO
