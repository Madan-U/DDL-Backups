-- Object: PROCEDURE dbo.SubbrokerNseAmt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SubbrokerNseAmt    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.SubbrokerNseAmt    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.SubbrokerNseAmt    Script Date: 20-Mar-01 11:39:10 PM ******/


CREATE Proc SubbrokerNseAmt (@Sett_no varchar(7) ,@sett_type varchar(2)) as 
/*SELECT sett_no,sett_type,BROKERAGE = -isnull(SUM(TRADEQTY*BROKAPPLIED),0), SERVICE_TAX = -isnull(SUM(NSERTAX),0) , 
DELCHRG =  -isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0)  FROM trdbackup WHERE sett_no = @Sett_no and sett_type = @Sett_Type
group by sett_no,sett_type
union all
SELECT sett_no,sett_type=( case when ( Sett_Type = 'L' ) then 'N' else 'W' end ),BROKERAGE = -isnull(SUM(TRADEQTY*BROKAPPLIED),0), SERVICE_TAX = -isnull(SUM(NSERTAX),0) , 
DELCHRG = -isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0)  FROM trdbackup WHERE sett_no = ( select min(Sett_no) from sett_mst where sett_mst.sett_no > @Sett_no and sett_Type = 'N' ) 
and sett_type = ( case when ( @Sett_Type = 'N' ) then 'L' else 'P' end )
group by sett_no,sett_type
union all
SELECT sett_no,sett_type,BROKERAGE = isnull(SUM(TRADEQTY*BROKAPPLIED),0), SERVICE_TAX = isnull(SUM(NSERTAX),0) , 
DELCHRG =  isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0)  FROM settlement  
where sett_no = @Sett_no and sett_type = @Sett_Type
group by sett_no,sett_type
union all
SELECT sett_no,sett_type=( case when ( Sett_Type = 'L' ) then 'N' else 'W' end ),BROKERAGE = isnull(SUM(TRADEQTY*BROKAPPLIED),0), SERVICE_TAX = isnull(SUM(NSERTAX),0) , 
DELCHRG =  isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0) FROM settlement WHERE sett_no = ( select min(Sett_no) from sett_mst where sett_mst.sett_no > @Sett_no and sett_Type = @sett_type) 
and sett_type = ( case when ( @Sett_Type = 'N' ) then 'L' else 'P' end )
group by sett_no,sett_type

*/

select Brokerage = Sum(BrokApplied*TradeQty),
delchrg=isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0),
Service_Tax = Isnull(Sum(nsertax),0),
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
sett_no,sett_type from settlement S, Client2 C2, OWNER
where C2.Party_Code = S.Party_Code and sett_no = @sett_no and sett_Type = @Sett_Type
group by sett_no,sett_type,service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg
union all
select Brokerage = Sum(BrokApplied*TradeQty),
delchrg=isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0),
Service_Tax = Isnull(Sum(nsertax),0),
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
sett_no,sett_type =( case when ( Sett_Type = 'L' ) then 'N' else 'W' end ) from settlement S, Client2 C2, OWNER
where C2.Party_Code = S.Party_Code and  sett_no = ( select min(Sett_no) from sett_mst where sett_mst.sett_no > @Sett_no and sett_Type = @sett_type) 
and sett_type = ( case when ( @Sett_Type = 'N' ) then 'L' else 'P' end )
group by sett_no,sett_type,service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg

union all
select Brokerage = -Sum(BrokApplied*TradeQty),
delchrg=-isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0),
Service_Tax = -Isnull(Sum(nsertax),0),
Turn_Tax = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Turnover_tax = 1 THEN
				SUM(turn_tax) 
			  else 0 end ) 	
		  else 0 end ),0),
Sebi_Tax = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Sebi_Turn_tax = 1 THEN
				SUM(Sebi_Tax) 
			  else 0 end ) 	
		  else 0 end ),0),
Ins_chrg = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Insurance_Chrg = 1 THEN
				SUM(Ins_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
Broker_chrg = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Brokernote = 1 THEN
				SUM(Broker_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
other_chrg = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN c2.Other_chrg = 1 THEN
				SUM(S.other_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
sett_no,sett_type from TrdBackUp S, MultiBroker C2, OWNER
where S.PartiPantCode = C2.CltCode and sett_no = @sett_no and sett_Type = @Sett_Type
group by sett_no,sett_type,service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg
union all
select Brokerage = -Sum(BrokApplied*TradeQty),
delchrg=-isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0),
Service_Tax = -Isnull(Sum(nsertax),0),
Turn_Tax = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Turnover_tax = 1 THEN
				SUM(turn_tax) 
			  else 0 end ) 	
		  else 0 end ),0),
Sebi_Tax = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Sebi_Turn_tax = 1 THEN
				SUM(Sebi_Tax) 
			  else 0 end ) 	
		  else 0 end ),0),
Ins_chrg = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Insurance_Chrg = 1 THEN
				SUM(Ins_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
Broker_chrg = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN Brokernote = 1 THEN
				SUM(Broker_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
other_chrg = -IsNull(( CASE WHEN dispcharge = 1 THEN
			( CASE WHEN c2.Other_chrg = 1 THEN
				SUM(S.other_chrg) 
			  else 0 end ) 	
		  else 0 end ),0),
sett_no,sett_type  =( case when ( Sett_Type = 'L' ) then 'N' else 'W' end ) from TrdBackUp S, MultiBroker C2, OWNER
where S.PartiPantCode = C2.CltCode and  sett_no = ( select min(Sett_no) from sett_mst where sett_mst.sett_no > @Sett_no and sett_Type = @sett_type) 
and sett_type = ( case when ( @Sett_Type = 'N' ) then 'L' else 'P' end )
group by sett_no,sett_type,service_chrg,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg

GO
