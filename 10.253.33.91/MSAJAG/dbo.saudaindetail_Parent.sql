-- Object: PROCEDURE dbo.saudaindetail_Parent
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--- EXEC [saudaindetail_Parent] '', '', 'Dec 12 2008', 'Dec 12 2008', '', '', '', '', '', 'PARTY_CODE', '2','broker', 'broker'

CREATE   Procedure [dbo].[saudaindetail_Parent]
@fromparty Varchar(20), 	---1 From Consol
@toparty Varchar (20), 		---2 To Consol
@sauda_date Varchar(11),	---3 Sauda_date (from)
@todate Varchar(11),		---4 Sauda_date (to)
@fromscrip Varchar(12),		---5 From Scrip_cd (from)
@toscrip Varchar(12),		---6 To Scrip_cd (to)
@sett_no Varchar(10), 		---7 Settlement No(from)
@tosett_no Varchar(10),		---8 Settlement No (to)
@sett_type Varchar(3),		---9 Settlement Type 
@consol Varchar(10),        ---  This Is Used For Selection Criteria -'party_code' Or 'family'
@groupby Varchar(10),       ---  This Is Used For Order By Clause
@statusid Varchar(20),		---  longin Id
@statusname Varchar(50)		---  login Name

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

--- ADDED ON 24TH JUNE 2009 BY MEGHA JADHAV--------
SET @sauda_date = CONVERT(VARCHAR(11),CONVERT(DATETIME,@sauda_date,103),109)
SET @todate = CONVERT(VARCHAR(11),CONVERT(DATETIME,@todate,103),109)
--- ADDED ON 24TH JUNE 2009 BY MEGHA JADHAV--------


If (@consol = "party_code") And  ((@fromparty <> "") And (@toparty <> "" ) ) 
Begin
	Select @@fromparty_code = @fromparty
	Select @@toparty_code = @toparty 
	Select @@fromfamily = ''
	Select @@tofamily = 'zzzzzzzz'
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
	Select @@sett_type = "%"
End

If (@fromscrip = "")
Begin
	Select @fromscrip = ""
End

If (@toscrip = "")
Begin
	Select @toscrip = "zzzzzzzzzz"
End 

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

If ((@sett_no = "" ) And ( Len(@sauda_date) > 1)) 
Begin
        Select @sett_no = Min(sett_no) From Sett_mst Where Sett_type Like @@sett_type And Start_date >= @sauda_date + ' 00:00'  And End_date <= @todate + ' 23:59:59'   
        If @todate = "" 
        Set @tosett_no = @sett_no
End

If ( (@tosett_no = "" ) And ( Len(@todate) > 1)) 
Begin
        Select @tosett_no = Max(sett_no) From Sett_mst Where Sett_type Like @@sett_type And Start_date >= @sauda_date + ' 00:00'  And End_date <= @todate + ' 23:59:59'   
End

/*
print '@sauda_date '+ @sauda_date
print '@todate '+ @todate
print '@@fromparty_code '+ @@fromparty_code
print '@@toparty_code '+ @@toparty_code
print '@@fromfamily '+ @@fromfamily
print '@@tofamily '+ @@tofamily
print '@sett_type ' + @sett_type
print '@sett_no ' + @sett_no
print '@tosett_no ' + @tosett_no
print '@fromscrip ' + @fromscrip
print '@toscrip ' + @toscrip
*/

CREATE TABLE #SAUDADETAIL
	(
	Tradedt VARCHAR(11), 
    Sauda_date VARCHAR(11),
	sett_no VARCHAR(11), 
	scrip_cd VARCHAR(15), 
	sett_type VARCHAR(2), 
	Scrip_name VARCHAR(35),
	Marketrate MONEY,
	Ptradeqty INT,
	Stradeqty INT,
	Pamt MONEY,
	Samt MONEY,
	sell_buy INT, 
	Brokapplied MONEY,
	netrate MONEY, 
	trade_no VARCHAR(15), 
	order_no VARCHAR(20),
	Tm VARCHAR(11),
	party_code VARCHAR(15),
	short_name VARCHAR(25), 
	service_tax MONEY, 
	branch_id VARCHAR(15), 
	user_id VARCHAR(15),
	L_Address1 VARCHAR(100),
	L_Address2  VARCHAR(100),
	L_city  VARCHAR(20),
	L_State VARCHAR(20),
	L_Nation VARCHAR(20),
	L_Zip VARCHAR(20),
	BILLFLAG INT,
	SERIES VARCHAR(5)
	)

Begin
If @groupby = '2' 
   Begin
	INSERT INTO #SAUDADETAIL
	Select Convert(varchar(12),sauda_date,111) As Tradedt, 
    Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , 
	S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2),
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no ,
	Tm = Convert(char(10),s.sauda_date , 108),
	S.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,
	BILLFLAG,
	SERIES = S.SERIES
	From Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And C2.ParentCode >= @@fromparty_code  And C2.ParentCode <= @@toparty_code And S.tradeqty >0  
	And C1.Family >= @@fromfamily And C1.Family <= @@tofamily
	And S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
	and Trade_No not like '%C%'
	and AuctionPart Not Like 'A%'
	And MarketRate > 0 

	/*login Conditions*/
	And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
	And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
	And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
	And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
	And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
	And C1.area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)
	And C1.region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)
	/*end Login Conditions*/

	--Union All

	INSERT INTO #SAUDADETAIL
	Select Convert(varchar(12),sauda_date,111) As Tradedt, 
    Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , 
	S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2),
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no ,
	Tm = Convert(char(10),s.sauda_date , 108),
	S.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,
	BILLFLAG,
	SERIES = S.SERIES
	From ISettlement S, Scrip2 S2, Client1 C1, Client2 C2, Scrip1 S1
	Where S.sauda_date >= @sauda_date And S.sauda_date <= @todate  + ' 23:59:59'
	And C2.ParentCode >= @@fromparty_code  And C2.ParentCode <= @@toparty_code And S.tradeqty >0  
	And C1.Family >= @@fromfamily And C1.Family <= @@tofamily
	And S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
	And MarketRate > 0 

	/*login Conditions*/
	And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
	And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
	And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
	And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
	And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
	And C1.area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)
	And C1.region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)
	/*end Login Conditions*/

	--Union All

	INSERT INTO #SAUDADETAIL
	Select Convert(varchar(12),sauda_date,111) As Tradedt, 
    Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , 
	S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2),
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End ),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no ,
	Tm = Convert(char(10),s.sauda_date , 108),
	S.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id, L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,
	BILLFLAG,
	SERIES = S.SERIES
	From History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And C2.ParentCode >= @@fromparty_code  And C2.ParentCode <= @@toparty_code And S.tradeqty >0  
	And C1.Family >= @@fromfamily And C1.Family <= @@tofamily
	And S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
	and Trade_No not like '%C%'
	and AuctionPart Not Like 'A%'
	And MarketRate > 0 

	/*login Conditions*/
	And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
	And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
	And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
	And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
	And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
	And C1.area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)
	And C1.region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)
	/*end Login Conditions*/
	Order By Tradedt,s1.short_name, S.scrip_cd ,s.party_code,tm


	 UPDATE #SAUDADETAIL SET 
	 NETRATE = (CASE WHEN SELL_BUY = 1   
      			THEN MARKETRATE + (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)/PTRADEQTY 
      			ELSE MARKETRATE - (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)/STRADEQTY 
        		   END), 
	 BROKAPPLIED = (CASE WHEN SELL_BUY = 1   
      				THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)/PTRADEQTY 
      				ELSE (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)/STRADEQTY 
        			   END), 
	 SERVICE_TAX = (CASE WHEN SELL_BUY = 1   
      				THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END) 
      				ELSE (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END) 
        			   END), 
	 PAMT     = (CASE WHEN SELL_BUY =1     
					THEN PAMT + (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)    
					ELSE 0    
				END)    
				+ (CASE WHEN SERVICE_CHRG = 1     
					THEN CASE WHEN SELL_BUY =1     
						THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END)    
						ELSE 0    
						END        
					ELSE 0     
					END),    
	 SAMT     = (CASE WHEN SELL_BUY = 2    
					THEN SAMT - (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)    
					ELSE 0    
				END)    
				+ (CASE WHEN SERVICE_CHRG = 1     
					THEN CASE WHEN SELL_BUY = 2    
						THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END)    
						ELSE 0    
						END        
				ELSE 0     
				END)
	 FROM CHARGES_DETAIL C, CLIENT2 C2  
	 WHERE 
	 CD_PARTY_CODE = C2.PARTY_CODE
	 AND CD_SETT_NO = #SAUDADETAIL.SETT_NO 
	 AND CD_SETT_TYPE = #SAUDADETAIL.SETT_TYPE 
	 AND CD_PARTY_CODE = #SAUDADETAIL.PARTY_CODE 
	 AND CD_SCRIP_CD = #SAUDADETAIL.SCRIP_CD 
	 AND CD_SERIES = #SAUDADETAIL.SERIES 
	 AND CD_TRADE_NO = TRADE_NO 
	 AND CD_ORDER_NO = ORDER_NO 
	 AND LEFT(SAUDA_DATE,11) = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,103),11) 

   End 
Else
   Begin
	INSERT INTO #SAUDADETAIL
	Select Convert(varchar(12),sauda_date,111) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id , L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,
	BILLFLAG,
	SERIES = S.SERIES
	From Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And C2.ParentCode >= @@fromparty_code  And C2.ParentCode <= @@toparty_code And S.tradeqty >0  
	And C1.Family >= @@fromfamily And C1.Family <= @@tofamily
	And S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
	and Trade_No not like '%C%'
	and AuctionPart Not Like 'A%'
	And MarketRate > 0 

	/*login Conditions*/
	And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
	And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
	And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
	And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
	And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
	And C1.area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)
	And C1.region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)
	/*end Login Conditions*/
	
	--Union All
	
	INSERT INTO #SAUDADETAIL
	Select Convert(varchar(12),sauda_date,111) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id , L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,
	BILLFLAG,
	SERIES = S.SERIES
	From ISettlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And C2.ParentCode >= @@fromparty_code  And C2.ParentCode <= @@toparty_code And S.tradeqty >0  
	And C1.Family >= @@fromfamily And C1.Family <= @@tofamily
	And S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
	And MarketRate > 0 

	/*login Conditions*/
	And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
	And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
	And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
	And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
	And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
	And C1.area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)
	And C1.region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)
	/*end Login Conditions*/
	
	--Union All

	INSERT INTO #SAUDADETAIL
	Select Convert(varchar(12),sauda_date,111) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Round((s.marketrate),2), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	Samt = (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),2) Else 0 End),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),2),netrate = Round((s.n_netrate),2), S.trade_no , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id , L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,
	BILLFLAG,
	SERIES = S.SERIES
	From History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	And C2.ParentCode >= @@fromparty_code  And C2.ParentCode <= @@toparty_code And S.tradeqty >0  
	And C1.Family >= @@fromfamily And C1.Family <= @@tofamily
	And S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
	And C2.party_code = S.party_code And C1.cl_code = C2.cl_code
	And Sett_type Like @sett_type + '%' 
	And Sett_no >= @sett_no And Sett_no <= @tosett_no
	And S.scrip_cd >= @fromscrip And S.scrip_cd <= @toscrip
	and Trade_No not like '%C%'
	and AuctionPart Not Like 'A%'
	And MarketRate > 0 

	/*login Conditions*/
	And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End) 
	And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End) 
	And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)
	And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)
	And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End) 
	And C1.area Like (case When @statusid = 'area' Then  @statusname Else '%' End)
	And C1.region Like (case When @statusid = 'region' Then  @statusname Else '%' End)
	/*end Login Conditions*/

	Order By Tradedt ,s.party_code,s1.short_name, S.scrip_cd,tm

	 UPDATE #SAUDADETAIL SET 
	 NETRATE = (CASE WHEN SELL_BUY = 1   
      			THEN MARKETRATE + (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)/PTRADEQTY 
      			ELSE MARKETRATE - (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)/STRADEQTY 
        		   END), 
	 BROKAPPLIED = (CASE WHEN SELL_BUY = 1   
      				THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)/PTRADEQTY 
      				ELSE (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)/STRADEQTY 
        			   END), 
	 SERVICE_TAX = (CASE WHEN SELL_BUY = 1   
      				THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END) 
      				ELSE (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END) 
        			   END), 
	 PAMT     = (CASE WHEN SELL_BUY =1     
					THEN PAMT + (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYBROKERAGE ELSE CD_DELBUYBROKERAGE END)    
					ELSE 0    
				END)    
				+ (CASE WHEN SERVICE_CHRG = 1     
					THEN CASE WHEN SELL_BUY =1     
						THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDBUYSERTAX ELSE CD_DELBUYSERTAX END)    
						ELSE 0    
						END        
					ELSE 0     
					END),    
	 SAMT     = (CASE WHEN SELL_BUY = 2    
					THEN SAMT - (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLBROKERAGE ELSE CD_DELSELLBROKERAGE END)    
					ELSE 0    
				END)    
				+ (CASE WHEN SERVICE_CHRG = 1     
					THEN CASE WHEN SELL_BUY = 2    
						THEN (CASE WHEN BILLFLAG IN (2,3) THEN CD_TRDSELLSERTAX ELSE CD_DELSELLSERTAX END)    
						ELSE 0    
						END        
				ELSE 0     
				END)
	 FROM CHARGES_DETAIL C, CLIENT2 C2
	 WHERE 
	 CD_PARTY_CODE = C2.PARTY_CODE
	 AND CD_SETT_NO = #SAUDADETAIL.SETT_NO 
	 AND CD_SETT_TYPE = #SAUDADETAIL.SETT_TYPE 
	 AND CD_PARTY_CODE = #SAUDADETAIL.PARTY_CODE 
	 AND CD_SCRIP_CD = #SAUDADETAIL.SCRIP_CD 
	 AND CD_SERIES = #SAUDADETAIL.SERIES 
	 AND CD_TRADE_NO = TRADE_NO 
	 AND CD_ORDER_NO = ORDER_NO 
	 AND LEFT(SAUDA_DATE,11) = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,103),11) 

   End
End


UPDATE #SAUDADETAIL
	SET 
	PARTY_CODE	= C2.PARENTCODE
FROM 
	CLIENT2 C2
WHERE 
	#SAUDADETAIL.PARTY_CODE = C2.PARTY_CODE


UPDATE #SAUDADETAIL
	SET SHORT_NAME = C1.SHORT_NAME,
	L_Address1	= C1.L_Address1,
	L_Address2	= C1.L_Address2,
	L_city		= C1.L_city,
	L_State		= C1.L_State,
	L_Nation	= C1.L_Nation,
	L_Zip		= C1.L_Zip
FROM 
	CLIENT1 C1
WHERE 
	C1.CL_CODE = #SAUDADETAIL.PARTY_CODE

/*
SELECT * FROM #SAUDADETAIL
Order By Tradedt,party_code,Scrip_name,scrip_cd,tm
*/

If @groupby = '2'
Begin
	SELECT *,ORDDATE = CONVERT(VARCHAR,CONVERT(DATETIME,TRADEDT,111),112) FROM #SAUDADETAIL
	Order By Scrip_name,scrip_cd,CONVERT(VARCHAR,CONVERT(DATETIME,TRADEDT,111),112),party_code,tm
End
Else
Begin
	SELECT *,ORDDATE = CONVERT(VARCHAR,CONVERT(DATETIME,TRADEDT,111),112) FROM #SAUDADETAIL
	Order By party_code,CONVERT(VARCHAR,CONVERT(DATETIME,TRADEDT,111),112),Scrip_name,scrip_cd,tm
End 

DROP TABLE #SAUDADETAIL

GO
