-- Object: PROCEDURE dbo.saudaindetail_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--EXEC SaudaInDetail_New '0A149', '0A149', 'Jun  1 2007', 'Jun  1 2007', '', '', '2007102', '2007102', 'N', 'PARTY_CODE', '1','broker', 'broker'

CREATE    Procedure [dbo].[saudaindetail_New]
(
	@fromparty Varchar(20), 	 ---1  From Consol
	@toparty Varchar (20), 		 ---2  To Consol
	@sauda_date Varchar(11),	 ---3  Sauda_date (from)
	@todate Varchar(11),		 ---4  Sauda_date (to)
	@fromscrip Varchar(12),		 ---5  From Scrip_cd (from)
	@toscrip Varchar(12),		 ---6  To Scrip_cd (to)
	@sett_no Varchar(10), 		 ---7  Settlement No(from)
	@tosett_no Varchar(10),		 ---8  Settlement No (to)
	@sett_type Varchar(3),		 ---9  Settlement Type 
	@consol Varchar(10),         ---10 This Is Used For Selection Criteria -'party_code' Or 'family'
	@groupby Varchar(10),        ---11 This Is Used For Order By Clause
	@statusid Varchar(20),		 ---12 longin Id
	@statusname Varchar(50)		 ---13 login Name
)

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

If (@consol = 'party_code')
begin
	Set @@fromfamily ='0'
	Set @@tofamily  ='zzzzzz'
	if @toparty = ''
		begin
			Set @toparty ='zzzzzzz'
		end
	Set @@fromparty_code = @fromparty
	Set @@toparty_code  = @toparty	
end


If (@consol = 'family')
begin
	Set @@fromparty_code ='0'
	Set @@toparty_code  ='zzzzzz'
	if @@tofamily = ''
		begin
			Set @@tofamily ='zzzzzzz'
		end
	Set @@fromfamily = @fromparty
	Set @@tofamily  = @toparty
end



If @sett_type  <>  '%'And @sett_type <> ''
Begin
		Select @@sett_type = @sett_type
End

If (@sett_type  =  '%'Or @sett_type = '' )
Begin
      Select @@sett_type = '%'
End


If  ( (@fromscrip = '') And  (@toscrip = '') )
   Select @fromscrip = Min(scrip_cd) ,@toscrip = Max(scrip_cd) From Scrip2

If (@fromscrip = '')
   Select @fromscrip = Min(scrip_cd) From Scrip2

If (@toscrip = '')
   Select @toscrip = Max(scrip_cd) From Scrip2

Select @sauda_date = Ltrim(rtrim(@sauda_date))
--Select @sauda_date = CONVERT(DATETIME, @sauda_date, 103)

If Len(@sauda_date) = 10 
Begin
          Set @sauda_date = Stuff(@sauda_date, 4, 1,'  ')
End

Select @todate = Ltrim(rtrim(@todate))
--Select @todate = CONVERT(DATETIME, @todate + ' 23:59:59', 103)

If Len(@todate) = 10 
Begin
          Set @todate = Stuff(@todate, 4, 1,'  ')
End

If ( @Sauda_date  = '' )         
Begin        
        Select @Sauda_date = Min(Start_date) from sett_mst where Sett_type Like @@Sett_type and Sett_no >= @Sett_no And Sett_No <= @ToSett_no 
End        
        
If ( @Todate  = '' )         
Begin        
        Select @Todate = End_date from sett_mst where Sett_type Like @@Sett_type and Sett_no >= @Sett_no And Sett_No <= @ToSett_no 
End 

If ( (@sett_no = '  ' ) And (@tosett_no = '  ' ) ) 
         Select @sett_no = Min(sett_no),@tosett_no=max(sett_no) From  Details  

If ( (@sett_no = '  ' ) ) 
         Select @sett_no = Min(sett_no) From  Details  

If ( (@tosett_no = '  ' ) ) 
         Select @tosett_no=max(sett_no) From  Details  
--select @fromscrip,@toscrip,@sett_no,@tosett_no,@@fromparty_code,@@toparty_code,@@sett_type

Begin
If @groupby = '2' 
   Begin
	Select Convert(varchar,s.sauda_date,103) As Tradedt, 
        	Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , 
	S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Convert(Numeric(18, 4), s.marketrate),
	Ptradeqty = (case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty = (case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = Convert(Numeric(18, 4), (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End )),
	Samt = Convert(Numeric(18, 4), (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End )),
	S.sell_buy,
	Brokapplied = Round((s.nbrokapp),4, 1),netrate = Convert(Numeric(18, 4), s.n_netrate), TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO), S.order_no ,
	Tm = Convert(char(10),s.sauda_date , 108),
	S.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip 
	From Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'

	--And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code 
	And S.Party_Code Between @@fromparty_code And @@toparty_code
	And C1.Family Between @@fromfamily And @@tofamily
	And S.tradeqty >0

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
		/*end Login Conditions*/
	Union All

	Select Convert(varchar,s.sauda_date,103) As Tradedt, 
        	Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , 
	S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Convert(Numeric(18, 4), s.marketrate),
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = Convert(Numeric(18, 4),(case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End )),
	Samt = Convert(Numeric(18, 4),(case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End )),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),4, 1),netrate = Convert(Numeric(18, 4), s.n_netrate), TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO) , S.order_no ,
	 Tm = Convert(char(10),s.sauda_date , 108),
	S.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id, L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip 
	From History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'
	--And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code 
	And S.Party_Code Between @@fromparty_code And @@toparty_code
	And C1.Family Between @@fromfamily And @@tofamily
	And S.tradeqty >0

	and S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series
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
		/*end Login Conditions*/

		Order By s1.short_name, SAUDA_DATE,S.scrip_cd ,s.party_code,tm
		COMPUTE SUM((case S.sell_buy When 1 Then S.tradeqty Else 0 End )),
		SUM((case S.sell_buy When 2 Then S.tradeqty Else 0 End )),
		SUM(Convert(Numeric(18, 4), (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End))),
		SUM(Convert(Numeric(18, 4), (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End)))
		BY s1.short_name
   End 
Else
     Begin
	Select Convert(varchar,s.sauda_date,103) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name,
	Marketrate = Convert(Numeric(18, 4), s.marketrate), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = Convert(Numeric(18, 4), (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End )),
	Samt = Convert(Numeric(18, 4), (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End)),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),4, 1),netrate = Convert(Numeric(18, 4), s.n_netrate), TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO) , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id , L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip 
	From Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'

	--And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code 
	And S.Party_Code Between @@fromparty_code And @@toparty_code
	And C1.Family Between @@fromfamily And @@tofamily
	And S.tradeqty >0

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
		/*end Login Conditions*/
	
	Union All
	
	Select Convert(varchar,s.sauda_date,103) As Tradedt, Convert(varchar,s.sauda_date,103) As Sauda_date ,s.sett_no, S.scrip_cd , S.sett_type, S1.short_name As Scrip_name ,
	Marketrate = Convert(Numeric(18, 4), s.marketrate), 
	Ptradeqty =(case S.sell_buy When 1 Then S.tradeqty Else 0 End ),
	Stradeqty =(case S.sell_buy When 2 Then S.tradeqty Else 0 End ),
	Pamt = Convert(Numeric(18, 4),(case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End )),
	Samt = Convert(Numeric(18, 4),(case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End)),
	S.sell_buy, 
	Brokapplied = Round((s.nbrokapp),4, 1),netrate = Convert(Numeric(18, 4), s.n_netrate), TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO) , S.order_no , Tm = Convert(char(10),s.sauda_date , 108)
	,s.party_code , C1.short_name , S.service_tax, S.branch_id , S.user_id , L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip 
	From History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1
	Where S.sauda_date >= @sauda_date  And S.sauda_date <= @todate  + ' 23:59:59'

	--And S.party_code >= @@fromparty_code  And S.party_code <= @@toparty_code 
	And S.Party_Code Between @@fromparty_code And @@toparty_code
	And C1.Family Between @@fromfamily And @@tofamily
	And S.tradeqty >0

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
		/*end Login Conditions*/
	ORDER BY s.party_code,sauda_date,s1.short_name, S.scrip_cd,tm

	COMPUTE SUM((case S.sell_buy When 1 Then S.tradeqty Else 0 End )),
	SUM((case S.sell_buy When 2 Then S.tradeqty Else 0 End )),
	SUM(Convert(Numeric(18, 4), (case S.sell_buy When 1 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End))),
	SUM(Convert(Numeric(18, 4), (case S.sell_buy When 2 Then Round((s.n_netrate * S.tradeqty),4, 1) Else 0 End)))
	BY S.PARTY_CODE
   End
End

GO
