-- Object: PROCEDURE dbo.Moslsaudareport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/****** Object:  Stored Procedure Dbo.moslsaudareport    Script Date: 01/15/2005 1:11:16 Pm ******/



/****** Object:  Stored Procedure Dbo.moslsaudareport    Script Date: 12/16/2003 2:21:09 Pm ******/



/* This Procedure Is Created For Customised Mosl Sauda Summary Report On 09/07/2003*/
Create  Proc Moslsaudareport( 
@sett_no Varchar(10), 		 ---1  Settlement No(from)
@tosett_no Varchar(10),		 ---2  Settlement No (to)
@sett_type Varchar(3),		 ---3  Settlement Type 
@sauda_date Varchar(11),		 ---4 Sauda_date (from)
@todate Varchar(11),			 ---5 Sauda_date (to)
@fromfamily Varchar(20),        		  --- Family 
@tofamily Varchar(20),           		 --- Family
@fromparty Varchar(20), 		 ---8  From Consol
@toparty Varchar (20), 		 ---9  To Consol
@fromscrip Varchar(10),		 ---6 From Scrip_cd (from)
@toscrip Varchar(10),			 ---7 To Scrip_cd (to)
@consol Varchar(10),            		--- This Is Used For Selection Criteria -'party_code' Or 'family'
@groupby Varchar(10),            		--- This Is Used For Order By Clause
@statusid Varchar(20),		---longin Id
@statusname Varchar(50))		---login Name
As 

Declare
@@getstyle As Cursor,
@@fromsett_no As Varchar(10),
@@tosett_no As Varchar(10),
@@fromparty_code As Varchar(10),
@@toparty_code  As Varchar(10),
@@sett_type As Varchar(3),
@@fromfamily As Varchar(10),
@@tofamily  As Varchar(10)

If (@consol = "party_code") And  ((@fromparty <> "") And (@toparty <> "" ) ) 
Begin
          Select @@fromparty_code = @fromparty
          Select @@toparty_code = @toparty 
          Select @@fromfamily = Min(family)  , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code  And Client2.party_code Between @@fromparty_code  And @@toparty_code
End
Else If (@consol = "party_code") And  ((@fromparty = "") And (@toparty = "" ) ) 
Begin          
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code 
/*     	Select @@toparty_code =  Max(party_code) ,@@fromparty_code = Min(party_code) From Details */
End

If (@consol = "family") And  ((@fromfamily <> "") And (@tofamily <> "" ) ) 
Begin
          Select @@fromfamily = @fromfamily
          Select @@tofamily = @tofamily 
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code And Client1.family Between @@fromfamily  And @@tofamily
End
Else If (@consol = "family") And  ((@fromfamily = "") And (@tofamily = "" ) ) 
Begin          
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code 
End

If @sett_type  <>  "%" And @sett_type <> ''
Begin
     Select @@sett_type = @sett_type
End

If (@sett_type  =  "%" Or @sett_type = '' )
Begin
      Select @@sett_type = Min(sett_type) From Details
End


If  ( (@fromscrip = "") And  (@toscrip = "") )
   Select @fromscrip = Min(scrip_cd) ,@toscrip = Max(scrip_cd) From Scrip2

If (@fromscrip = "")
   Select @fromscrip = Min(scrip_cd) From Scrip2

If (@toscrip = "")
   Select @toscrip = Max(scrip_cd) From Scrip2


Select @sauda_date = Ltrim(rtrim(@sauda_date))
If Len(@sauda_date) = 10 
Begin
          Set @sauda_date = Stuff(@sauda_date, 4, 1,"  ")
End

Select @todate = Ltrim(rtrim(@todate))

If Len(@todate) = 10 
Begin
          Set @todate = Stuff(@todate, 4, 1,"  ")
End

If ( @sauda_date  = "" ) 
Begin
        Select @sauda_date = Start_date From Sett_mst Where Sett_type = @sett_type And Sett_no = @sett_no 
End

If ( @todate  = "" ) 
Begin
        Select @todate = End_date From Sett_mst Where Sett_type = @sett_type And Sett_no = @tosett_no 
End

If ( (@sett_no = "" ) And (@tosett_no = "" ) ) 
         Select @sett_no = Min(sett_no),@tosett_no=max(sett_no) From  Details  

If ( (@sett_no = "" ) ) 
         Select @sett_no = Min(sett_no) From  Details  

If ( (@tosett_no = "" ) ) 
         Select @tosett_no=max(sett_no) From  Details  
--select @fromscrip,@toscrip,@sett_no,@tosett_no,@@fromparty_code,@@toparty_code,@@sett_type,@@fromfamily,@@tofamily

Begin
If @groupby = '1' 
	Begin
		 Select Sett_no, Sett_type,party_code, Party_name,scrip_cd,series,scrip_name, Ptradedqty = Sum(pqtytrd + Pqtydel) , Ptradedamt = Sum(pamttrd + Pamtdel) , 
		 Stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , 
		 Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  
		 Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
		 Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
		 Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
		 Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
		 Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
		 Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,
		 Exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),
		 Broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) ,
		 Netqty = Sum(pqtytrd + Pqtydel) - Sum(sqtytrd + Sqtydel),
		 Netamt = Sum(pamt) - Sum(samt) 
		 From Cmbillvalan S
		 Where S.sauda_date   Between @sauda_date + ' 00:00:00'  And @todate + ' 23:59:00' 
		 And S.scrip_cd Between @fromscrip And  @toscrip 
		 And S.sett_no Between @sett_no And @tosett_no
		 And S.party_code Between @@fromparty_code And @@toparty_code
		 And  S.sett_type Like @@sett_type  +'%'
		 And Pqtytrd > 0 And Sqtytrd > 0 
		 And Family Between @@fromfamily And @@tofamily
		/*login Conditions*/
		And Branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
		And Sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
		And Trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
		And Family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
		And Party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
		/*end Login Conditions*/
		 Group By Sett_no, Sett_type,party_code,party_name,membertype, Companyname,scrip_cd ,series,scrip_name /* ,participantcode , Clienttype */
		 Order By Party_code,party_name ,sett_no , Scrip_cd,series,scrip_name 
	End 
Else
	Begin
		 Select Sett_no, Sett_type,party_code, Party_name,scrip_cd,series,scrip_name, Ptradedqty = Sum(pqtytrd + Pqtydel) , Ptradedamt = Sum(pamttrd + Pamtdel) , 
		 Stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , 
		 Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  
		 Billpamt = Sum(pamt) , Billsamt = Sum(samt) , 
		 Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
		 Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   
		 Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , 
		 Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  
		 Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,
		 Exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),
		 Broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) ,
		 Netqty = Sum(pqtytrd + Pqtydel) - Sum(sqtytrd + Sqtydel),
		 Netamt = Sum(pamt) - Sum(samt)
		 From Cmbillvalan S
		 Where S.sauda_date   Between @sauda_date + ' 00:00:00'  And @todate + ' 23:59:00' 
		 And S.scrip_cd Between @fromscrip And  @toscrip 
		 And S.sett_no Between @sett_no And @tosett_no
		 And S.party_code Between @@fromparty_code And @@toparty_code
		 And  S.sett_type Like @@sett_type  + '%'
		 And Pqtytrd > 0 And Sqtytrd > 0 
		 And Family Between @@fromfamily And @@tofamily
		/*login Conditions*/
		And Branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
		And Sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
		And Trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
		And Family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
		And Party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
		/*end Login Conditions*/
		 Group By Sett_no, Sett_type,party_code,party_name,membertype, Companyname,scrip_cd,series,scrip_name /* ,participantcode , Clienttype */
		 Order By  Scrip_cd,series,scrip_name ,party_code,party_name
	End 
End

GO
