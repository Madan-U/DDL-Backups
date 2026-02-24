-- Object: PROCEDURE dbo.Proc_newbasicreport_Combine1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE Procedure Proc_newbasicreport_Combine1 (         
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
	@exchange varchar(5),  
	@Consolid Varchar(15),            
	@Consolname Varchar(25) )      
As        
Declare      
	@@getstyle As Cursor,        
	@@sett_no As Varchar(10),        
	@@fromparty_code As Varchar(10),        
	@@toparty_code  As Varchar(10),        
	@@fromsett_type As Varchar(3),        
	@@tosett_type As Varchar(3),        
	@@myquery As Varchar(4000),        
	@@myreport As Varchar(50),        
	@@myorder As Varchar(1500),        
	@@mygroup As Varchar(1500),        
	@@part As Varchar(8000),        
	@@part1 As Varchar(8000),        
	@@part2 As Varchar(8000),        
	@@part3 As Varchar(8000),        
	@@part4 As Varchar(8000),        
	@@part5 As Varchar(8000),        
	@@part6 As Varchar(8000),        
	@@wisereport As Varchar(10),        
	@@dummy1 As Varchar(1000),        
	@@dummy2 As Varchar(1000),        
	@@fromfamily As Varchar(10),        
	@@tofamily  As Varchar(10),        
	@@frombranch_cd As Varchar(15),        
	@@tobranch_cd  As Varchar(15),        
	@@fromsub_broker As Varchar(15),        
	@@tosub_broker  As Varchar(15),        
	@@fromtrader As Varchar(15),        
	@@totrader  As Varchar(15),        
	@@fromregion Varchar(15),        
	@@toregion Varchar(15),        
	@@fromarea Varchar(15),        
	@@toarea Varchar(15),        
	@@dummy3 As Varchar(1000),        
	@@fromtable As Varchar(1000),     
	@@selectflex As Varchar (2000),    
	@@selectflex1 As Varchar (2000),     
	@@selectbody As Varchar(8000),    
	@@selectbody1 As Varchar(8000),     
	@@wheretext As Varchar(8000),    
	@@fromtable1 As Varchar(1000),     
	@@wherecond1 As Varchar(2000),        
	@@strexchange varchar(5)        

	Select @@fromparty_code = '0'
	Select @@toparty_code = 'ZZZZZZZZZZ' 
	Select @@fromfamily = '0'
	Select @@tofamily = 'ZZZZZZZZZZ' 
	Select @@frombranch_cd = '0'
	Select @@tobranch_cd = 'ZZZZZZZZZZ' 
	Select @@fromtrader = '0'
	Select @@totrader = 'ZZZZZZZZZZ' 
	Select @@fromsub_broker = '0'
	Select @@tosub_broker = 'ZZZZZZZZZZ' 
	Select @@fromregion = '0' 
	Select @@toregion = 'ZZZZZZZZZZ' 
	Select @@fromarea = '0' 
	Select @@toarea = 'ZZZZZZZZZZ' 

If @sett_type = ''
	Select @sett_type  =  '%'

If ((@consol = 'party_code' Or @consol = 'party' Or @consol = 'broker')) And  ((@from <> '') And (@to = '' ) ) 
Begin
          Select @@fromparty_code = @from
          Select @@toparty_code = @from 
End

If ((@consol = 'party_code' Or @consol = 'party' Or @consol = 'broker')) And  ((@from <> '') And (@to <> '' ) ) 
Begin
	Select @@fromparty_code = @from
	Select @@toparty_code = @to 
End

If (@consol = 'family') And  ((@from <> '') And (@to <> '' ) ) 
Begin
          Select @@fromfamily = @from
          Select @@tofamily = @to 
          Select @@fromparty_code = '0'
	  Select @@toparty_code = 'ZZZZZZZZZZ' 
End
Else If (@consol = 'family') And  ((@from = '') And (@to = '' ) ) 
Begin          
          Select @@fromparty_code = '0', @@toparty_code = 'ZZZZZZZZZZ', @@fromfamily = '0' , @@tofamily = 'ZZZZZZZZZZ'
End

If (@consol = 'branch_cd' Or @consol = 'Branch') And  ((@from <> '') And (@to <> '' ) ) 
Begin
          Select @@frombranch_cd = @from
          Select @@tobranch_cd = @to 
          Select @@fromparty_code = '0' , @@toparty_code = 'ZZZZZZZZZZ' 
End
Else If (@consol = 'branch_cd' Or @consol = 'Branch') And  ((@from = '') And (@to = '' ) ) 
Begin
          Select @@fromparty_code = '0', @@toparty_code = 'ZZZZZZZZZZ', @@frombranch_cd = '0', @@tobranch_cd = 'ZZZZZZZZZZ'
End

If (@consol = 'trader') And  ((@from <> '') And (@to <> '' ) ) 
Begin
          Select @@fromtrader = @from
          Select @@totrader = @to 
          Select @@fromparty_code = '0' , @@toparty_code = 'ZZZZZZZZZZ' 
End
Else If (@consol = 'trader')  And ( ( @from = '' ) And ( @to = '' ) )  
Begin
	Select @@fromparty_code = '0' , @@toparty_code = 'ZZZZZZZZZZ', @@fromtrader = '0', @@totrader = 'ZZZZZZZZZZ'
End


If (@consol = 'sub_broker') And  ((@from <> '') And (@to <> '' ) ) 
Begin
          Select @@fromsub_broker = @from
          Select @@tosub_broker = @to 
          Select @@fromparty_code = '0', @@toparty_code = 'ZZZZZZZZZZ' 
End
Else If (@consol = 'sub_broker')  And ( ( @from = '' ) And ( @to = '' ) )  
Begin
	Select @@fromparty_code = '0', @@toparty_code = 'ZZZZZZZZZZ', @@fromsub_broker = '0', @@tosub_broker = 'ZZZZZZZZZZ'
End

If (@consol = 'region')  And  ((@from <> '') And (@to <> '' ) ) 
Begin
     Select @@fromparty_code = '0', @@toparty_code = 'ZZZZZZZZZZ' 
     Select @@fromregion = @from 
     Select @@toregion = @to 	
End

Else If (@consol = 'region')  And  ((@from = '') And (@to = '' ) ) 
Begin
     Select @@toparty_code = 'ZZZZZZZZZZ', @@fromparty_code = '0'
     Select @@fromregion = '0', @@toregion = 'ZZZZZZZZZZ' 
End
If (@consol = 'area')  And  ((@from <> '') And (@to <> '' ) ) 
Begin
     Select @@toparty_code =  'ZZZZZZZZZZ', @@fromparty_code = '0' 
     Select @@fromarea = @from 
     Select @@toarea = @to 	
End

Else If (@consol = 'area')  And  ((@from = '') And (@to = '' ) ) 
Begin
     Select @@toparty_code = 'ZZZZZZZZZZ', @@fromparty_code = '0' 
     Select @@fromarea = '0', @@toarea = 'ZZZZZZZZZZ'
End

If ( (@consol = 'party_code' Or @consol = 'party' Or @consol = 'broker')) And ( ( @from = '' ) And ( @to = '' ) ) 
Begin
     Select @@toparty_code = 'ZZZZZZZZZZ', @@fromparty_code = '0' 
End

If @sett_type  <>  '%' 
Begin
     Select @@fromsett_type = @sett_type
     Select @@tosett_type = @sett_type
End

If @sett_type  =  '%' 
Begin
      Select @@fromsett_type = 'A', @@tosett_type = 'X'
End

If  ( (@fromscrip = '') And  (@toscrip = '') )
   Select @fromscrip = '0', @toscrip = 'ZZZZZZZZZZ' 

If (@fromscrip = '')
   Select @fromscrip = '0'

If (@toscrip = '')
   Select @toscrip = 'ZZZZZZZZZZ'


If @tosett_no = '' 
   Set @tosett_no = @sett_no

Select @sauda_date = Ltrim(rtrim(@sauda_date))
If Len(@sauda_date) = 10 
Begin
          Set @sauda_date = Stuff(@sauda_date, 4, 1,'  ')
End

Select @todate = Ltrim(rtrim(@todate))

If Len(@todate) = 10 
Begin
          Set @todate = Stuff(@todate, 4, 1,'  ')
End
--------------------------------------------------- Find Saudadate From To From Settlement Range  -------------------------------------------------------------------------------------------------------
If ( @todate  = '' ) 
Begin
        Select @todate = End_date From Sett_mst Where Sett_type Like @sett_type And Sett_no = @tosett_no 
End

If ( @sauda_date  = '' ) 
Begin
        Select @sauda_date = Start_date From Sett_mst Where Sett_type like @sett_type And Sett_no = @sett_no 
End
----------------------------------------------------find Settno From To From Sauda_date  Range -------------------------------------------------------------------------------------------------------
Set @@fromtable = ' From NSEBSEValan S'       
    
If @groupf = '1'       
Begin        
    If @consol = 'area'        
     Begin        
          Set @@mygroup =' Group By Area'        
          Set @@selectflex =' Select code=Area, Long_name=area,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel),
Stradedamt = Sum(samttrd + Samtdel), Buybrokerage = Sum(pbroktrd) ,     
Selbrokerage= Sum(sbroktrd) , Buydeliverychrg = Sum(pbrokdel), Selldeliverychrg = Sum(sbrokdel), Clienttype = 1, Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End), 
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),     
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax), 
turn_tax= sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd)'         
     End    
      
     If @consol = 'region'    
  Begin    
     Set @@mygroup = ' Group By Region'    
     Set @@selectflex =  ' Select code=Region, Long_name=region,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
Stradedamt = Sum(samttrd + Samtdel), Buybrokerage = Sum(pbroktrd), Selbrokerage= Sum(sbroktrd),  
Buydeliverychrg = Sum(pbrokdel), Selldeliverychrg = Sum(sbrokdel), Clienttype = 1,Billpamt = Sum(pamt) ,   
Billsamt = Sum(samt),Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax),  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
    End    
  
     If @consol = 'party'        
     Begin        
          Set @@mygroup = ' Group By S.party_code, Party_name,clienttype'        
          Set @@selectflex =  ' Select code=Party_code, Long_name=party_name, ptradedqty = Sum(pqtytrd + Pqtydel) , ptradedamt = Sum(pamttrd + Pamtdel) ,
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel), Buybrokerage = Sum(pbroktrd) ,     
Selbrokerage= Sum(sbroktrd) , Buydeliverychrg = Sum(pbrokdel), Selldeliverychrg = Sum(sbrokdel), Clienttype, Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax =sum(turn_tax),
sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End        
     If @consol = 'branch'        
     Begin         
          Set  @@mygroup = ' Group By Branch_cd, Clienttype'        
          Set @@selectflex =  ' Select Long_name=branch_cd,code=branch_cd,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd),  Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype,
Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End), 
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax), sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd)'         
     End        
     If @consol = 'family'        
     Begin         
          Set  @@mygroup = ' Group By Family, Family_name,clienttype'        
          Set @@selectflex =  ' Select code=Family, Long_name=family_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype, 
Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
 Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End         
     If @consol = 'trader'        
     Begin         
          Set  @@mygroup = ' Group By Trader, clienttype '        
          Set @@selectflex =  ' Select code=Trader,long_name=trader,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) , 
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel), buybrokerage = Sum(pbroktrd) ,    
 Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype,   
Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
 Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax), sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd)'         
     End               
     If @consol = 'sub_broker'        
     Begin         
          Set  @@mygroup = ' Group By Sub_broker, clienttype'                            
          Set @@selectflex =  ' Select code=Sub_broker,long_name=sub_broker,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) , 
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) ,     
Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype,  
Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End), 
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
 Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax), 
turn_tax=sum(turn_tax), sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End        
End        
     
If @groupf = '2'       
Begin        
   If @consol = 'area'        
     Begin         
          Set @@mygroup = ' Group By Sett_no, Sett_type,start_date,end_date'        
          Set @@selectflex = ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) ,   
Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End          
  
 If @consol = 'region'    
     Begin      
          Set @@mygroup = ' Group By Sett_no, Sett_type,start_date,end_date'    
          Set @@selectflex = ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,  
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),  
buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,  
selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,   
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End),  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End      
  
     If @consol = 'party'        
     Begin         
          Set @@mygroup = ' Group By Sett_no, Sett_type,start_date,end_date'        
          Set @@selectflex = ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) , 
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) , 
selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax), sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End        
     If @consol = 'branch'        
     Begin         
          Set @@mygroup = ' Group By Sett_no, Sett_type,start_date,end_date'        
          Set @@selectflex = ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel),  
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), 
Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), pnl = Sum(samttrd-pamttrd) '         
     End          
     If @consol = 'family'        
     Begin         
          Set @@mygroup =  ' Group By Sett_no, Sett_type,start_date,end_date'        
          Set @@selectflex =  ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) , 
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) ,    
Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) , 
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End                           
     If @consol = 'trader'        
     Begin         
          Set @@mygroup =  ' Group By Sett_no, Sett_type,start_date,end_date'        
          Set @@selectflex =  ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) , 
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , 
Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), 
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax), sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End         
     If @consol = 'sub_broker'        
     Begin         
          Set @@mygroup =  ' Group By Sett_no, Sett_type,start_date,end_date'        
          Set @@selectflex =  ' Select Sett_no, Sett_type,start_date,end_date,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) , 
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) ,     
 Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,    
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),  
turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '          
     End        
End        
  
If @groupf = '3'   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------    
Begin    
     If @consol = 'region'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd,series,scrip_name, region'    
          Set @@selectflex = ' Select  code = region,Scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,  
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),  
buybrokerage = Sum(pbroktrd) ,Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , 
Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),
pnl = Sum(samttrd-pamttrd) '     
     End      
     If @consol = 'area'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd,series,scrip_name, area'    
          Set @@selectflex = ' Select code = area, Scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,  
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),  
buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,  
selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,   
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
 Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End      
     If @consol = 'party'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd,series,scrip_name, party_code'    
          Set @@selectflex = ' Select code = party_code, Scrip_cd, Series, Scrip_name, Ptradedqty = Sum(pqtytrd + Pqtydel) ,  
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),  
buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,  
selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,   
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End    
     If @consol = 'branch'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd, series, scrip_name, branch_cd'    
          Set @@selectflex = ' Select code = branch_cd, Scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,  
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),  
buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,  
selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,   
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
 Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End      
     If @consol = 'family'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd,series,scrip_name, Family'    
          Set @@selectflex = ' Select code = Family, Scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,  
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd),
Selbrokerage = Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) ,   
Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End                       
     If @consol = 'trader'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd,series,scrip_name, trader'    
          Set @@selectflex = ' Select  code = trader, Scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), 
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd), Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel), Billpamt = Sum(pamt) ,  
 Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End     
     If @consol = 'sub_broker'    
     Begin     
          Set @@mygroup = ' Group By Scrip_cd,series,scrip_name, sub_broker'    
          Set @@selectflex = ' Select code = sub_Broker, Scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),  
buybrokerage = Sum(pbroktrd) ,Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel),  
Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End    
End    
      
If @groupf = '4'  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------        
Begin        
      If @consol = 'area'        
     Begin         
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'        
          Set  @@selectflex =  'select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11), 
ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel),     
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,
Billpamt = Sum(pamt) ,  Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,     
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),        
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt), delamt=sum(delamt), Serinex=sum(serinex),  
service_tax= Sum(service_tax),exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End   
  
    If @consol = 'region'    
     Begin     
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'    
          Set  @@selectflex =  'select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,  
stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) ,  
Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel),  
Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd+ Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End), 
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),  
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '     
     End             
        
     If @consol = 'party'        
     Begin         
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'         
Set  @@selectflex =  ' Select Sett_no, Sett_type,trade_date = S.sauda_date, sauda_date = Left(convert(varchar,sauda_date,109),11), ptradedqty = Sum(pqtytrd + Pqtydel) , 
ptradedamt = Sum(pamttrd + Pamtdel), stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel), buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) , 
buydeliverychrg = Sum(pbrokdel), selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,     
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End )  , 
Smarketrate = ( Sum(srate) / Case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ,  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd   + Pqtydel) Else 1 End ) ,  
Snetrate = ( Sum(samttrd + samtdel) /  Case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ), 
Trdamt= Sum(trdamt) ,delamt=sum(delamt),Serinex=sum(serinex),service_tax= Sum(service_tax) ,    
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End          
     If @consol = 'branch'        
     Begin         
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'        
          Set  @@selectflex =  'select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11), 
ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel),     
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) , 
selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,  Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End), 
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,
delamt=sum(delamt),  Serinex=sum(serinex),service_tax= Sum(service_tax),exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax), 
sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End          
     If @consol = 'family'        
     Begin         
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'        
          Set  @@selectflex =  'select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),    
ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Strade    
damt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,  
buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd     
+ Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,  
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt= Sum(trdamt) ,delamt=sum(delamt), 
Serinex=sum(serinex),service_tax= Sum(service_tax) , exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg), 
broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End          
     If @consol = 'trader'        
     Begin         
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'        
          Set  @@selectflex =  'select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) , 
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel),   Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) , 
selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,  Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),    
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax),exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),  
ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),pnl = Sum(samttrd-pamttrd) '         
     End          
     If @consol = 'sub_broker'        
     Begin         
          Set  @@mygroup = ' Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11)'        
          Set  @@selectflex =  'select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),ptradedqty = Sum(pqtytrd + Pqtydel) , 
ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel),     
Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) ,   
Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) ,   
Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
Trdamt= Sum(trdamt) ,delamt=sum(delamt),Serinex=sum(serinex),service_tax= Sum(service_tax),  
exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),
pnl = Sum(samttrd-pamttrd)'         
    End          
End        
      
if @exchange = 'ALL'            
   Set @@wheretext = ' Where Exchange IN (''NSE'',''BSE'',''NSEFO'') and S.sauda_date   Between ''' + @sauda_date  + ' 00:00:00''  And '''   + @todate  + ' 23:59:59'' And S.scrip_cd Between '''  + @fromscrip + ''' And  '''+  @toscrip +''''              
if @exchange = 'NSE'             
   Set @@wheretext = ' Where Exchange = ''NSE'' and S.sauda_date  Between ''' + @sauda_date  + ' 00:00:00''  And '''   + @todate  + ' 23:59:59'' And S.scrip_cd Between '''  + @fromscrip + ''' And  '''+  @toscrip +''''              
if @exchange = 'BSE'             
   Set @@wheretext = ' Where Exchange = ''BSE'' and S.sauda_date  Between ''' + @sauda_date  + ' 00:00:00''  And '''   + @todate  + ' 23:59:59'' And S.scrip_cd Between '''  + @fromscrip + ''' And  '''+  @toscrip +''''                      
if @exchange = 'NSEFO'             
   Set @@wheretext = ' Where Exchange = ''NSEFO'' and S.sauda_date Between ''' + @sauda_date  + ' 00:00:00''  And '''   + @todate  + ' 23:59:59'' And S.scrip_cd Between '''  + @fromscrip + ''' And  '''+  @toscrip +''''              
if @exchange = 'CAPITAL'             
   Set @@wheretext = ' Where Exchange IN (''NSE'',''BSE'') and S.sauda_date Between ''' + @sauda_date  + ' 00:00:00''  And '''   + @todate  + ' 23:59:59'' And S.scrip_cd Between '''  + @fromscrip + ''' And  '''+  @toscrip +''''

Set @@wheretext =  @@wheretext +   '  And Sett_Type Like ''' + @Sett_Type + ''' '
if @Sett_no <> '' 
	Set @@wheretext =  @@wheretext +   '  And Sett_No >= ''' + @Sett_No + ''' '
if @toSett_no <> '' 
	Set @@wheretext =  @@wheretext +   '  And Sett_No <= ''' + @ToSett_No + ''' '

Set @@wheretext =  @@wheretext +   '  And Party_Code Between ''' + @@fromparty_code  + ''' And ''' + @@toparty_code   +'''  '             
Set @@wheretext =  @@wheretext +   '  And Family Between ''' + @@fromfamily  + ''' And ''' + @@tofamily   +'''  '             
Set @@wheretext =  @@wheretext +   '  And Branch_Cd Between ''' + @@frombranch_cd  + ''' And ''' + @@tobranch_cd   +'''  '             
Set @@wheretext =  @@wheretext +   '  And Sub_Broker Between ''' + @@fromsub_broker  + ''' And ''' + @@tosub_broker   +'''  '             
Set @@wheretext =  @@wheretext +   '  And Trader Between ''' + @@fromtrader  + ''' And ''' + @@totrader   +'''  '             
Set @@wheretext =  @@wheretext +   '  And Area Between ''' + @@fromarea  + ''' And ''' + @@toarea   +'''  '             
Set @@wheretext =  @@wheretext +   '  And Region Between ''' + @@fromregion  + ''' And ''' + @@toregion   +'''  '             

If @statusid = 'family'             
 Begin            
  Set @@wheretext =  @@wheretext +   '  And Family Between ''' + @statusname  + ''' And ''' + @statusname   +''' '             
 End            
            
If @statusid = 'trader'            
Begin            
 Set @@wheretext =  @@wheretext + ' And  Trader Between ''' + @statusname  + ''' And ''' + @statusname   +'''  '             
End            
            
If @statusid = 'branch'             
Begin            
 Set @@wheretext =  @@wheretext + ' And Branch_cd Between ''' + @statusname  + ''' And ''' + @statusname   +'''  '             
End            
            
If @statusid = 'subbroker'             
Begin            
 Set @@wheretext =  @@wheretext + ' And Sub_broker Between ''' + @statusname  + ''' And ''' + @statusname   +'''  '             
End            
            
If @statusid = 'client'             Begin            
 Set @@wheretext =  @@wheretext + ' And Party_code Between ''' + @statusname  + ''' And ''' + @statusname   +'''  '             
End            
If @statusid = 'region'             
 Begin            
  Set @@wheretext =  @@wheretext +   '  And Region Between ''' + @statusname  + ''' And ''' + @statusname   +'''  '             
 End            
If @statusid = 'area'             
 Begin            
  Set @@wheretext =  @@wheretext +   '  And Area Between ''' + @statusname  + ''' And ''' + @statusname   +'''  '             
 End    
        
If @ConsolId = 'family'             
Begin            
 Set @@wheretext =  @@wheretext +   '  And Family Between ''' + @Consolname  + ''' And ''' + @Consolname   +''' '             
End            
            
If @ConsolId = 'trader'            
Begin            
 Set @@wheretext =  @@wheretext + ' And  Trader Between ''' + @Consolname  + ''' And ''' + @Consolname   +'''  '             
End            
            
If @ConsolId = 'branch'             
Begin            
 Set @@wheretext =  @@wheretext + ' And Branch_cd Between ''' + @Consolname  + ''' And ''' + @Consolname   +'''  '             
End            
            
If @ConsolId = 'sub_broker'             
Begin            
 Set @@wheretext =  @@wheretext + ' And Sub_broker Between ''' + @Consolname  + ''' And ''' + @Consolname   +'''  '             
End            
            
If @ConsolId = 'party'             
Begin            
 Set @@wheretext =  @@wheretext + ' And Party_code Between ''' + @Consolname  + ''' And ''' + @Consolname   +'''  '             
End            
If @ConsolId = 'region'             
 Begin            
  Set @@wheretext =  @@wheretext +   '  And Region Between ''' + @Consolname  + ''' And ''' + @Consolname   +'''  '             
 End            
If @ConsolId = 'area'             
 Begin            
  Set @@wheretext =  @@wheretext +   '  And Area Between ''' + @Consolname  + ''' And ''' + @Consolname   +'''  '             
 End
      
 Set @@wheretext = @@wheretext + ' And  Tradetype Not In ( ''ir'' )  '          

Print @@selectflex 
Print @@selectbody
Print @@fromtable 
Print @@wheretext 
Print @@mygroup
 
Exec (@@selectflex + @@selectbody+ @@fromtable + @@wheretext + @@mygroup )

GO
