-- Object: PROCEDURE dbo.ContCumBillSect
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 


/*
sp_helptext contCumBillsect_bak
 exec contCumBillsect_bak 'Jun 23 2002','N','63','rd7446'
 drop proc  ContCumBillSect
 exec ContCumBillSect 'Oct 28 2002','N  ','23','H08075'
 exec ContCumBillSect 'Nov  5 2002','N  ','9237','N00617'
This stored procedure used in Refco
*/

CREATE proc ContCumBillSect (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(9),@Party_code varchar(10))
as 
Declare 
@@Getstyle As Cursor,
@@Sett_no As Varchar(12)

Select @Sdate = Ltrim(Rtrim(@Sdate))
If Len(@Sdate) = 10 
Begin
          Select @Sdate = STUFF(@Sdate, 4, 1,'  ')
End

Print @sdate 

Set @@Getstyle = Cursor for 
        Select Sett_no from sett_mst where Sett_type = @Sett_type and Start_Date < @Sdate + ' 00:01:01' and End_date > @Sdate + ' 00:01:01' 
        Open @@Getstyle
        Fetch next from @@Getstyle into @@sett_no
        Close @@Getstyle
Print @@sett_no

Declare Tax_Flag cursor read_only for select Top 1 isnull(Turnover_tax,0), isnull(Sebi_Turn_tax,0), isnull(Insurance_Chrg,0), isnull(Service_chrg,2) , isnull(Other_chrg,0) ,isnull(BrokerNote,0) from client2  where client2.party_code = @Party_code
Declare @TurnOver_tax tinyInt,
@Sebi_turn_tax tinyInt,
@Insurance_Chrg tinyInt,
@Service_chrg tinyInt,
@Other_chrg tinyInt,
@StampDuty  tinyInt
Open Tax_flag
fetch next from Tax_flag into @TurnOver_tax ,@Sebi_turn_tax , @Insurance_Chrg , @Service_chrg ,@Other_chrg ,@StampDuty

Deallocate Tax_flag

 SELECT  settlement.contractNo,settlement.party_code,settlement.order_no ,tm=convert(char,sauda_date,108),
  settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
  settlement.sell_buy,settlement.markettype,/* broker_chrg=isnull(settlement.broker_chrg,0), */
  service_tax=  case when @Service_chrg = 0 then isnull(nsertax,0) else 0 end   /* ( case when service_chrg = 1 then  
			0
		else
			isnull(settlement.service_tax,0)
		end)  */  ,
  pqty=isnull((case sell_buy
  when 1 then settlement.tradeqty end),0),
  sqty=isnull((case sell_buy
  when 2 then settlement.tradeqty end),0),
  prate=isnull((case sell_buy
   when 1 then settlement.Marketrate end),0),
  srate=isnull((case sell_buy
  when 2 then settlement.Marketrate end),0),
  pbrok=isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then  
			settlement.NBrokApp   /*  + (nsertax/tradeqty)   */
		else 
			settlement.NBrokApp 
		end)
	end),0),
  sbrok=isnull((case sell_buy
   when 2 then  ( case when service_chrg = 1 then  
			settlement.NBrokApp    /*   - (nsertax/tradeqty)  */
		else 
			settlement.NBrokApp 
		end)
	end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			settlement.N_NetRate /* + settlement.NBrokApp     + (nsertax/tradeqty) */
		else
			settlement.N_NetRate
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			settlement.N_NetRate /* - settlement.NBrokApp      - (nsertax/tradeqty)  */
		else
			settlement.N_NetRate
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(settlement.N_NetRate + settlement.NBrokApp) * tradeqty   /*  + nsertax  */
		else
			(settlement.N_NetRate ) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(settlement.N_NetRate ) * tradeqty    /*    - nsertax   */
		else
			(settlement.N_NetRate) * tradeqty
		end ) 
	 end),0),
  Brokerage=isnull((tradeqty*NBrokApp),0), Sett_no = settlement.sett_no,Sett_type = Settlement.Sett_type 
  ,Isin =""-- isnull(m.Isin,'')
 , turn_tax = Case when @TurnOver_tax = 1 then turn_tax else 0 end ,
 NSERtax = case when @Service_chrg = 0 then nsertax else 0 end ,
 sebi_tax = case when @Sebi_turn_tax = 1 then sebi_tax else 0 end ,
 Ins_chrg = case when @Insurance_Chrg = 1 then Ins_chrg else 0 end ,
 other_chrg = case when @Other_chrg = 1 then settlement.other_chrg else 0 end ,
 Broker_chrg = case when @stampDuty = 1 then Broker_chrg else 0 end  
,Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then 'D' else '' end 

  from settlement /*Left outer join MultiIsin m 
  on m.scrip_cd = settlement.scrip_cd and valid = 1*/,scrip1,scrip2, client2 
  where settlement.scrip_cd=scrip2.scrip_cd
  and settlement.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
  and rtrim(settlement.sett_type) = @sett_Type
  and settlement.sauda_date LIKE  @sdate + '%'
  and settlement.tradeqty <> 0
  and convert(int,settlement.contractno) = @ContNo 
  and client2.Party_code = Settlement.party_code
  and settlement.party_code = @Party_code
  And Settlement.sett_no <> @@sett_no 

/*  and settlement.scrip_cd like 'Mastek%' 
  and trade_no = 'RR93506'*/

Union All

 SELECT  settlement.contractNo,settlement.party_code,settlement.order_no ,tm=convert(char,sauda_date,108),
  settlement.trade_no, settlement.sauda_date,settlement.scrip_cd,scripname=scrip1.short_name,sdt=convert(char,sauda_date,103),
  settlement.sell_buy,settlement.markettype , /*broker_chrg=isnull(settlement.broker_chrg,0), */
 service_tax=   case when @Service_chrg = 0 then nsertax else 0 end ,
 pqty=isnull((case sell_buy
  when 1 then settlement.tradeqty end),0),
  sqty=isnull((case sell_buy
  when 2 then settlement.tradeqty end),0),
  prate=isnull((case sell_buy
when 1 then settlement.Marketrate end),0),
  srate=isnull((case sell_buy
  when 2 then settlement.Marketrate end),0),
  pbrok=isnull((case sell_buy
  when 1 then  ( case when service_chrg = 1 then  
			settlement.NBrokApp   
		else 
			settlement.NBrokApp 
		end)
	end),0),
  sbrok=isnull((case sell_buy
   when 2 then  ( case when service_chrg = 1 then  
			settlement.NBrokApp    
		else 
			settlement.NBrokApp 
		end)
	end),0),
pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			settlement.N_NetRate 
		else
			settlement.N_NetRate
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			settlement.N_NetRate 
		else
			settlement.N_NetRate
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(settlement.N_NetRate + settlement.NBrokApp) * tradeqty   
		else
			(settlement.N_NetRate ) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(settlement.N_NetRate ) * tradeqty   
		else
			(settlement.N_NetRate) * tradeqty
		end ) 
	 end),0),
  Brokerage=isnull((tradeqty*NBrokApp),0), Sett_no = settlement.sett_no,Sett_type = Settlement.Sett_type
   ,Isin = ""--isnull(m.Isin,'')
 , turn_tax = Case when @TurnOver_tax = 1 then turn_tax else 0 end ,
 NSERtax = case when @Service_chrg = 0 then nsertax else 0 end ,
 sebi_tax = case when @Sebi_turn_tax = 1 then sebi_tax else 0 end ,
 Ins_chrg = case when @Insurance_Chrg = 1 then Ins_chrg else 0 end ,
 other_chrg = case when @Other_chrg = 1 then settlement.other_chrg else 0 end ,
 Broker_chrg = case when @stampDuty = 1 then Broker_chrg else 0 end  
,Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then 'D' else '' end 
  from settlement/* Left outer join MultiIsin m 
  on m.scrip_cd = settlement.scrip_cd and valid = 1*/,scrip1,scrip2, client2 
  where settlement.scrip_cd=scrip2.scrip_cd
  and settlement.series=scrip2.series
  and scrip2.co_code=scrip1.co_code
  and scrip2.series=scrip1.series
  and rtrim(settlement.sett_type) = @sett_Type
  and settlement.Sett_no = @@Sett_no
  and settlement.tradeqty <> 0
/*  and convert(int,settlement.contractno) = @ContNo */
and client2.Party_code = Settlement.party_code
and settlement.party_code = @party_code 
/*  and settlement.sauda_date LIKE  @sdate + '%' */

/*  and settlement.scrip_cd like 'Mastek'
  and trade_no = 'RR93506' */

 order by sett_no,sett_type,scrip1.short_name,settlement.order_no , settlement.trade_no

GO
