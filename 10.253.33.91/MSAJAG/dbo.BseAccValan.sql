-- Object: PROCEDURE dbo.BseAccValan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




Create Proc BseAccValan (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As 
Delete From BseBillValan Where Sett_No = @Sett_No and Sett_Type = @Sett_Type
Insert Into BseBillValan 
select s.party_code,sell_buy,pamt =   
isnull((case when sell_buy = 1 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate)   
 else    
   sum(tradeqty * n_NetRate + nsertax)   
 end ) + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Turnover_tax = 1 THEN  
    SUM(turn_tax)   
     else 0 end )    
    else 0 end )  
         + (CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Sebi_Turn_tax = 1 THEN  
    SUM(Sebi_Tax)   
     else 0 end )    
    else 0 end )  
         + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Insurance_Chrg = 1 THEN  
    SUM(Ins_chrg)   
     else 0 end )    
    else 0 end )  
  + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Brokernote = 1 THEN  
    SUM(Broker_chrg)   
     else 0 end )    
    else 0 end )  
  + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN c2.Other_chrg = 1 THEN  
    SUM(S.other_chrg)   
     else 0 end )    
    else 0 end )  
end),0),  
samt = isnull((case when sell_buy = 2 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate )   
 else    
   sum(tradeqty * n_NetRate- nsertax)   
 end ) - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Turnover_tax = 1 THEN  
    SUM(turn_tax)   
     else 0 end )    
    else 0 end )  
         - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Sebi_Turn_tax = 1 THEN  
    SUM(Sebi_Tax)   
     else 0 end )    
    else 0 end )  
         - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Insurance_Chrg = 1 THEN  
    SUM(Ins_chrg)   
     else 0 end )    
    else 0 end )  
  - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Brokernote = 1 THEN  
    SUM(Broker_chrg)   
     else 0 end )    
    else 0 end )  
  - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN c2.Other_chrg = 1 THEN  
    SUM(S.other_chrg)   
     else 0 end )    
    else 0 end )  
end),0),
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy2) Else 0 End),  
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy2) Else 0 End) ,
Brokerage = Sum(TradeQty*BrokApplied),
DelBrokerage = Sum(TradeQty*(NBrokApp - BrokApplied)),
Service_Tax = Sum(NSertax),
ExService_Tax = (Case When Service_chrg = 2 
		      Then Sum(NSertax)
		      Else 0 
		 End),
Turn_Tax = (Case WHEN dispcharge = 1 
		 THEN (Case WHEN Turnover_tax = 1 
		            THEN SUM(turn_tax)   
	   	            Else 0 
		       End)    
	         else 0 
	    End ),
Sebi_Tax = (Case WHEN dispcharge = 1 
		 THEN (CASE WHEN Sebi_Turn_tax = 1 
		            THEN SUM(Sebi_Tax)   
			    Else 0 
		       End)    
		 Else 0 
	    End),  
Ins_Chrg = (Case WHEN dispcharge = 1 
		 THEN (CASE WHEN Insurance_Chrg = 1 
			    THEN SUM(Ins_chrg)   
     			    Else 0 
		       End)    
		 Else 0 
	    End),
Broker_Chrg = (CASE WHEN dispcharge = 1 
		    THEN (CASE WHEN Brokernote = 1 
			       THEN SUM(Broker_chrg)   
		               Else 0 
		          End)    
		    Else 0 
	       End),
Other_Chrg = (CASE WHEN dispcharge = 1 
		   THEN (CASE WHEN c2.Other_chrg = 1 
		              THEN SUM(S.other_chrg)   
		              Else 0 
		         End)    
		   Else 0 
	      End),  
TrdAmt = Sum(TradeQty*S.Dummy2),	
DelAmt = (Case When TMark = 'D'
 	       Then Sum(TradeQty*S.Dummy2)
	       Else 0 
	  End),	
sett_no,sett_type,billno,Branch_cd from settlement S, Client2 C2, OWNER,Client1  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
group by sett_no,sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,TMark  
union all
select s.party_code,sell_buy,pamt =   
isnull((case when sell_buy = 1 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate )   
 else    
  sum(tradeqty * n_NetRate + nsertax)   
 end ) + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Turnover_tax = 1 THEN  
    SUM(turn_tax)   
     else 0 end )    
    else 0 end )  
         + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Sebi_Turn_tax = 1 THEN  
    SUM(Sebi_Tax)   
     else 0 end )    
    else 0 end )  
         + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Insurance_Chrg = 1 THEN  
    SUM(Ins_chrg)   
     else 0 end )    
    else 0 end )  
  + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Brokernote = 1 THEN  
    SUM(Broker_chrg)   
     else 0 end )    
    else 0 end )  
  + ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN c2.Other_chrg = 1 THEN  
    SUM(S.other_chrg)   
     else 0 end )    
    else 0 end )  
end),0),  
samt = isnull((case when sell_buy = 2 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate )   
 else    
   sum(tradeqty * n_NetRate- nsertax)   
 end ) - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Turnover_tax = 1 THEN  
    SUM(turn_tax)   
     else 0 end )    
    else 0 end )  
         - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Sebi_Turn_tax = 1 THEN  
    SUM(Sebi_Tax)   
     else 0 end )    
    else 0 end )  
         - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Insurance_Chrg = 1 THEN  
    SUM(Ins_chrg)   
     else 0 end )    
    else 0 end )  
  - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN Brokernote = 1 THEN  
    SUM(Broker_chrg)   
     else 0 end )    
    else 0 end )  
  - ( CASE WHEN dispcharge = 1 THEN  
   ( CASE WHEN c2.Other_chrg = 1 THEN  
    SUM(S.other_chrg)   
     else 0 end )    
    else 0 end )  
end),0),
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy2) Else 0 End),  
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy2) Else 0 End),
Brokerage = Sum(TradeQty*BrokApplied),
DelBrokerage = Sum(TradeQty*(NBrokApp - BrokApplied)),
Service_Tax = Sum(NSertax),
ExService_Tax = (Case When Service_chrg = 2 
		      Then Sum(NSertax)
		      Else 0 
		 End),
Turn_Tax = (Case WHEN dispcharge = 1 
		 THEN (Case WHEN Turnover_tax = 1 
		            THEN SUM(turn_tax)   
	   	            Else 0 
		       End)    
	         else 0 
	    End ),
Sebi_Tax = (Case WHEN dispcharge = 1 
		 THEN (CASE WHEN Sebi_Turn_tax = 1 
		            THEN SUM(Sebi_Tax)   
			    Else 0 
		       End)    
		 Else 0 
	    End),  
Ins_Chrg = (Case WHEN dispcharge = 1 
		 THEN (CASE WHEN Insurance_Chrg = 1 
			    THEN SUM(Ins_chrg)   
     			    Else 0 
		       End)    
		 Else 0 
	    End),
Broker_Chrg = (CASE WHEN dispcharge = 1 
		    THEN (CASE WHEN Brokernote = 1 
			       THEN SUM(Broker_chrg)   
		               Else 0 
		          End)    
		    Else 0 
	       End),
Other_Chrg = (CASE WHEN dispcharge = 1 
		   THEN (CASE WHEN c2.Other_chrg = 1 
		              THEN SUM(S.other_chrg)   
		              Else 0 
		         End)    
		   Else 0 
	      End),
TrdAmt = Sum(TradeQty*S.Dummy2),	
DelAmt = (Case When TMark = 'D'
 	       Then Sum(TradeQty*S.Dummy2)
	       Else 0 
	  End),	
sett_no,sett_type,billno,Branch_cd from History S, Client2 C2, OWNER,Client1  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
group by sett_no,sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,TMark
Union All
select s.party_code,sell_buy,
pamt = isnull((case when sell_buy = 1 then Sum(TradeQty*MarketRate) Else 0 End),0),  
Samt = isnull((case when sell_buy = 2 then Sum(TradeQty*MarketRate) Else 0 End),0), 
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy2) Else 0 End),  
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy2) Else 0 End) ,
Brokerage = 0,
DelBrokerage = 0,
Service_Tax = 0,
ExService_Tax = 0,
Turn_Tax = 0,
Sebi_Tax = 0,  
Ins_Chrg = 0,
Broker_Chrg = 0,
Other_Chrg = 0,  
TrdAmt = 0,	
DelAmt = 0,	
N.sett_no,N.sett_type,billno,Branch_cd from settlement S, Client2 C2, OWNER,Client1, Nodel N  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and s.sett_no = N.Settled_In
and s.sett_Type = N.sett_Type
and s.scrip_Cd = N.scrip_Cd
and Trade_No like '%C%' 
and N.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
group by N.sett_no,N.sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,TMark    
Union All
select s.party_code,sell_buy,
pamt = isnull((case when sell_buy = 1 then Sum(TradeQty*MarketRate) Else 0 End),0),
Samt = isnull((case when sell_buy = 2 then Sum(TradeQty*MarketRate) Else 0 End),0),  
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy2) Else 0 End),  
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy2) Else 0 End),
Brokerage = 0,
DelBrokerage = 0,
Service_Tax = 0,
ExService_Tax = 0,
Turn_Tax = 0,
Sebi_Tax = 0,  
Ins_Chrg = 0,
Broker_Chrg = 0,
Other_Chrg = 0,  
TrdAmt = 0,	
DelAmt = 0,	
N.sett_no,N.sett_type,billno,Branch_cd from History S, Client2 C2, OWNER,Client1, Nodel N  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and s.sett_no = N.Settled_In
and s.sett_Type = N.sett_Type
and s.scrip_Cd = N.scrip_Cd
and Trade_No like '%C%' 
and N.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
group by N.sett_no,N.sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,TMark  
union all
select s.party_code,sell_buy,pamt =   
isnull((case when sell_buy = 1 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate )   
 else    
   sum(tradeqty * n_NetRate + nsertax)   
 end ) end),0),  
samt = isnull((case when sell_buy = 2 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate )   
 else    
   sum(tradeqty * n_NetRate- nsertax)   
 end ) end),0),
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy2) Else 0 End),  
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy2) Else 0 End),
Brokerage = Sum(TradeQty*BrokApplied),
DelBrokerage = Sum(TradeQty*(NBrokApp - BrokApplied)),
Service_Tax = Sum(NSertax),
ExService_Tax = (Case When Service_chrg = 2 
		      Then Sum(NSertax)
		      Else 0 
		 End),
Turn_Tax = 0,
Sebi_Tax = 0,  
Ins_Chrg = 0,
Broker_Chrg = 0,
Other_Chrg = 0,  
TrdAmt = 0,	
DelAmt = 0,	
sett_no,sett_type,billno,Branch_cd from Isettlement S, Client2 C2, OWNER,Client1  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
group by sett_no,sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,TMark  
Union All
select s.party_code,sell_buy,pamt =   
isnull((case when sell_buy = 2 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate )   
 else    
   sum(tradeqty * n_NetRate - nsertax)   
 end ) end),0),  
samt = isnull((case when sell_buy = 1 then   
 ( case when  Service_chrg = 2 then  
   sum(tradeqty * n_NetRate)   
 else    
   sum(tradeqty * n_NetRate + nsertax)   
 end ) end),0),
PRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.N_NetRate) Else 0 End),  
SRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.N_NetRate) Else 0 End) ,
Brokerage = 0,
DelBrokerage = 0,
Service_Tax = 0,
ExService_Tax = 0,
Turn_Tax = 0,
Sebi_Tax = 0,  
Ins_Chrg = 0,
Broker_Chrg = 0,
Other_Chrg = 0,  
TrdAmt = 0,	
DelAmt = 0,	
sett_no,sett_type,billno,Branch_cd from Isettlement S, Client2 C2, OWNER,Client1  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
and Scrip_CD not in (Select Scrip_Cd from Nodel where Sett_no = S.Sett_no and Sett_Type = S.Sett_Type and Scrip_Cd = S.Scrip_CD )
group by sett_no,sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd ,TMark 
union All
select s.party_code,sell_buy,
pamt = isnull((case when sell_buy = 1 then Sum(TradeQty*MarketRate) Else 0 End),0),
Samt = isnull((case when sell_buy = 2 then Sum(TradeQty*MarketRate) Else 0 End),0),  
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy2) Else 0 End),  
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy2) Else 0 End),
Brokerage = 0,
DelBrokerage = 0,
Service_Tax = 0,
ExService_Tax = 0,
Turn_Tax = 0,
Sebi_Tax = 0,  
Ins_Chrg = 0,
Broker_Chrg = 0,
Other_Chrg = 0,  
TrdAmt = 0,	
DelAmt = 0,	
N.sett_no,N.sett_type,billno,Branch_cd from ISettlement S, Client2 C2, OWNER,Client1, Nodel N  
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code  
and s.sett_no = N.Settled_In
and s.sett_Type = N.sett_Type
and s.scrip_Cd = N.scrip_Cd
and Trade_No like '%C%' 
and N.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type
group by N.sett_no,N.sett_type,s.party_code,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,TMark

GO
