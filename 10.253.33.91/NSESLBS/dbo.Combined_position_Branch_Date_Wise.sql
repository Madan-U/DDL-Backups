-- Object: PROCEDURE dbo.Combined_position_Branch_Date_Wise
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC Combined_position_Branch_Date_Wise '0','99999999999','N','','','','','','','Branch','','0','4','4','','broker','broker','All'

CREATE  Procedure Combined_position_Branch_Date_Wise (   
@sett_no Varchar(10),
@tosett_no Varchar(10), 
@sett_type Varchar(3), 
@sauda_date Varchar(11), 
@todate Varchar(11),   
@fromscrip Varchar(10), 
@toscrip Varchar(10), 
@from Varchar(20), 
@to Varchar (20),
@consol Varchar(10),
@detail Varchar(3),
@level  Smallint,
@groupf Varchar(500),
@orderf Varchar(500),
@use1 Varchar(10),
@statusid Varchar(15),  
@statusname Varchar(25),  
@exchange varchar(3))
as
Declare
@@fromsett_type varchar(3),
@@tosett_type varchar(3)

If @sett_type  <>  '%'    
Begin  
     Select @@fromsett_type = @sett_type  
     Select @@tosett_type = @sett_type  
End  
  
If @sett_type  =  '%'   
Begin  
      Select @@fromsett_type = Min(sett_type), @@tosett_type = Max(sett_type) From set_mst  
End  
  
If  (@fromscrip = '') And  (@toscrip = '')
Begin
   Select @fromscrip = '0', @toscrip = 'ZZZZZZZZZZ'   
end
  
If (@fromscrip = '')  
begin
   Select @fromscrip = '0'  
end
  
If (@toscrip = '')  
begin
   Select @toscrip = 'ZZZZZZZZZZ'  
end

If (@todate  = '')   
Begin  
    Select @todate = End_date From Sett_mst Where Sett_type Like @sett_type And Sett_no = @tosett_no   
End  
  
If (@sauda_date  = '')   
Begin  
    Select @sauda_date = Start_date From Sett_mst Where Sett_type like @sett_type And Sett_no = @sett_no   
End  

print @sauda_date
print @todate
if @groupf = '4'
Select
	Sett_no,Scrip_cd,Sett_type,trade_date = S.sauda_date,
	sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,
	ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
	Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,
	buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,
	Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),
	Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),
	Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,
	Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),
  	Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,
	exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),
	broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) 
From 
	nsebsevalan S
Where 
	--S.sauda_date Between @sauda_date And @todate And 
	S.scrip_cd Between @fromscrip And @toscrip And 
	S.sett_no Between @sett_no And @sett_no And 
	S.party_code Between '0' And 'zzzzzz' And 
	S.sett_type Between 'N' And 'N' --And Tradetype Not In ( 'ir' )  
Group By 
	Sett_no,Scrip_cd, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),membertype, Companyname 
else
Select 
	Branch_cd,Scrip_cd, Series, Scrip_name, Ptradedqty = Sum(pqtytrd + Pqtydel),
	ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
	Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd), Selbrokerage= Sum(sbroktrd), 
	buydeliverychrg = Sum(pbrokdel), selldeliverychrg = Sum(sbrokdel), Billpamt = Sum(pamt), Billsamt = Sum(samt),
	Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End), 
	Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),
	Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),
	Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),
	Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax), 
	exservice_tax=Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),
	broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd)
From 
	nsebsevalan S 
Where 
	--S.sauda_date Between @sauda_date And @todate And S.scrip_cd Between @fromscrip And @toscrip and 
--	S.sett_no Between @sett_no And @tosett_no And S.party_code Between @from And @to And  
	--S.sett_type Between @@fromsett_type And @@tosett_type And Tradetype Not In ( 'ir' )  

	--S.sauda_date Between @sauda_date And @todate And 
	S.scrip_cd Between @fromscrip And @toscrip And 
	S.sett_no Between @sett_no And @sett_no And 
	S.party_code Between '0' And 'zzzzzz' And 
	S.sett_type Between 'N' And 'N' --And Tradetype Not In ( 'ir' )  

Group By 
	Scrip_cd,series,scrip_name,membertype, Companyname,Branch_cd

GO
