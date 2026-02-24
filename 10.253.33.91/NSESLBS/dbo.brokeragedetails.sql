-- Object: PROCEDURE dbo.brokeragedetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





--EXEC MoslBrokerageDetails'', '', '', '', '', '', '2005019', '2005050', 'N', 'PARTY_CODE', '1','broker', 'broker'

/****** Object:  Stored Procedure Dbo.moslbrokeragedetails    Script Date: 01/15/2005 1:11:13 Pm ******/



/****** Object:  Stored Procedure Dbo.moslbrokeragedetails    Script Date: 12/16/2003 2:21:09 Pm ******/



/* This Procedure Is Created For Customised Mosl Brokerage Details Report On 14/07/2003*/
CREATE  Procedure brokeragedetails(
@fromparty Varchar(20), 		 ---1  From Consol
@toparty Varchar (20), 		 ---2  To Consol
@sauda_date Varchar(11),		 ---3 Sauda_date (from)
@todate Varchar(11),			 ---4 Sauda_date (to)
@fromscrip Varchar(12),		 ---5 From Scrip_cd (from)
@toscrip Varchar(12),			 ---6 To Scrip_cd (to)
@sett_no Varchar(10), 		 ---7  Settlement No(from)
@tosett_no Varchar(10),		 ---8  Settlement No (to)
@sett_type Varchar(3),		 ---9  Settlement Type 
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
End
Else If (@consol = "party_code") And  ((@fromparty = "") And (@toparty = "" ) ) 
Begin          
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code 
End

If (@consol = "family") And  ((@fromparty <> "") And (@toparty <> "" ) ) 
Begin
          Select @@fromfamily = @fromparty
          Select @@tofamily = @toparty
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code And Client1.family Between @@fromfamily  And @@tofamily
End
Else If (@consol = "family") And  ((@fromparty = "") And (@toparty = "" ) ) 
Begin          
          Select @@fromparty_code = Min(party_code) , @@toparty_code = Max(party_code), @@fromfamily = Min(family) , @@tofamily = Max(family) From Client2, Client1  Where  Client2.cl_code = Client1.cl_code 
End

If @sett_type  <>  "%" And @sett_type <> ''
Begin
     Select @@sett_type = @sett_type
End

If (@sett_type  =  "%" Or @sett_type = '' )
Begin
      Select @@sett_type ="%"
End


If  ( (@fromscrip = "") And  (@toscrip = "") )
   Select @fromscrip = Min(Scrip_Cd) ,@toscrip = Max(Scrip_Cd) From Scrip2

If (@fromscrip = "")
   Select @fromscrip = Min(Scrip_Cd) From Scrip2

If (@toscrip = "")
   Select @toscrip = Max(Scrip_Cd) From Scrip2


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

If ( @Sauda_date  = "" )         
Begin        
        Select @Sauda_date = Min(Start_date) from sett_mst where Sett_type Like @@Sett_type and Sett_no >= @Sett_no And Sett_No <= @ToSett_no 
End        
        
If ( @Todate  = "" )         
Begin        
        Select @Todate = End_date from sett_mst where Sett_type Like @@Sett_type and Sett_no >= @Sett_no And Sett_No <= @ToSett_no 
End 

If ( (@sett_no = " " ) And (@tosett_no = " " ) ) 
         Select @sett_no = Min(sett_no),@tosett_no=max(sett_no) From  Details  

If ( (@sett_no = " " ) ) 
         Select @sett_no = Min(sett_no) From  Details  

If ( (@tosett_no = " " ) ) 
         Select @tosett_no=max(sett_no) From  Details  


--Select @groupby,@fromscrip,@toscrip,@sett_no,@tosett_no,@@fromparty_code,@@toparty_code,@@sett_type
--return

Begin
If @groupby = '2' 
   Begin
     	Select Convert(varchar(12),sauda_date,111) As Tradedt, 
      	 Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2),
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then (s.tradeqty * -1) Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp * S.tradeqty ),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id 
	,perbrok = (case 
	When S.marketrate > 0 Then Round((abs(s.marketrate - S.n_netrate )*100 / ( S.marketrate )),2) Else 0.000 End )
	From Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >=  @sauda_date  And S.sauda_date <=  @todate  + ' 23:59:59'
	And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code And S.tradeqty >0  And 
	S.scrip_cd = S2.Scrip_Cd And S1.co_code = S2.co_code And S1.series = S2.series
	And S.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%'
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
		/*login Conditions*/
		And C1.Region Like (case When @statusid  = 'region' Then  @statusname  Else '%' End) 
		And C1.Area Like (case When @statusid  = 'area' Then  @statusname  Else '%' End) 
		And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
		And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
		And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
		And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
		And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
		/*end Login Conditions*/

	Union All

	Select Convert(varchar(12),sauda_date,111) As Tradedt, 
      	 Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2),
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then (s.tradeqty * -1) Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp * S.tradeqty ),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id 
	,perbrok = (case 
	When S.marketrate > 0 Then Round((abs(s.marketrate - S.n_netrate )*100 / ( S.marketrate )),2) Else 0.000 End )
	From History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >=  @sauda_date  And S.sauda_date <=  @todate  + ' 23:59:59'
	And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code And S.tradeqty >0  And 
	S.scrip_cd = S2.Scrip_Cd  And S1.co_code = S2.co_code And S1.series = S2.series
	And S.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%'
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
		/*login Conditions*/
		And C1.Region Like (case When @statusid  = 'region' Then  @statusname  Else '%' End) 
		And C1.Area Like (case When @statusid  = 'area' Then  @statusname  Else '%' End) 
		And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
		And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
		And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
		And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
		And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
		/*end Login Conditions*/
	Order By Tradedt, S1.short_name, S.scrip_cd ,s.party_code,tm
    End 
Else
     Begin
	Select Convert(varchar(12),sauda_date,111) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then (s.tradeqty * -1 )else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),s.sell_buy, 
	Brokapplied = Round((s.nbrokapp * S.tradeqty),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id
	,perbrok = (case 
	When S.marketrate > 0 Then Round(abs(s.marketrate - S.n_netrate )*100 / ( S.marketrate ),2) Else 0 End )
	From Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >=   @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code And S.tradeqty >0  And 
	S.scrip_cd = S2.Scrip_Cd  And S1.co_code = S2.co_code And S1.series = S2.series
	And S.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like  @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
		/*login Conditions*/
		And C1.Region Like (case When @statusid  = 'region' Then  @statusname  Else '%' End) 
		And C1.Area Like (case When @statusid  = 'area' Then  @statusname  Else '%' End) 
		And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
		And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
		And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
		And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
		And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
		/*end Login Conditions*/

	Union All

	Select Convert(varchar(12),sauda_date,111) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then (s.tradeqty * -1 )else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),s.sell_buy, 
	Brokapplied = Round((s.nbrokapp * S.tradeqty),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id
	,perbrok = (case 
	When S.marketrate > 0 Then Round(abs(s.marketrate - S.n_netrate )*100 / ( S.marketrate ),2) Else 0 End )
	From History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >=   @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code And S.tradeqty >0  And 
	S.scrip_cd = S2.Scrip_Cd  And S1.co_code = S2.co_code And S1.series = S2.series
	And S.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like  @sett_type + '%'
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
		/*login Conditions*/
		And C1.Region Like (case When @statusid  = 'region' Then  @statusname  Else '%' End) 
		And C1.Area Like (case When @statusid  = 'area' Then  @statusname  Else '%' End) 
		And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
		And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
		And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
		And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
		And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
		/*end Login Conditions*/
	Order By Tradedt,s.party_code, S1.short_name, S.scrip_cd ,tm
	
   End
End

GO
