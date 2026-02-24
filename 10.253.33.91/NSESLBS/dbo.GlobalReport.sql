-- Object: PROCEDURE dbo.GlobalReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--EXEC GlobalReport '0000', 'zzz', 'Jul 1 2005', 'Jul 1 2007', '0000', 'zzzz', '0000', 'zzzz', 'n', 'PARTY_CODE', '1','broker', 'broker'  
CREATE   Procedure [dbo].[GlobalReport]     
(     
 @FROMPARTY VARCHAR(15),             
 @TOPARTY VARCHAR(15),  
 @FROMDATE VARCHAR(11),           
 @TODATE VARCHAR(11),        
 @FROMSUB_BROKER VARCHAR(10),              
 @TOSUB_BROKER VARCHAR(10),                       
 @FROMBRANCH VARCHAR(15),            
 @TOBRANCH VARCHAR(15),     
 @SETT_TYPE VARCHAR(2),  
 @consol Varchar(10),              --- This Is Used For Selection Criteria -'party_code' Or 'family'    
 @groupby Varchar(10), 
 @STATUSID VARCHAR(15),              
 @STATUSNAME VARCHAR(25)          --- This Is Used For Order By Clause    
 )     
  
  
As       
      
--EXEC SaudaInDetail'0000', 'zzz', 'Oct  8 2005', 'Oct  8 2007', '', '', '2007102', '2007102', 'n', 'PARTY_CODE', '1','broker', 'broker'    
--GlobalReport 'BROKER','BROKER','JAN  1 2004','JAN  1 2007','0','ZZZZZZ','0','ZZZZZZZ','0','ZZZZZZZ','N' 
 DECLARE     
 @sauda_date VARCHAR(11),    
 @@getstyle As Cursor,    
 @@fromsett_no As Varchar(10),    
 @@tosett_no As Varchar(10),    
 @sett_no As Varchar(10),    
 @@fromparty_code As Varchar(10),    
 @@toparty_code  As Varchar(10),    
 @@sett_type As Varchar(3),    
 @@fromfamily As Varchar(10),    
 @@tofamily  As Varchar(10)    
             
 If @TOBRANCH = ''
 Begin
	Set @TOBRANCH = 'zzzzzzzzzzz'
 End

 If (@TOSUB_BROKER = '')
 Begin
	Set @TOSUB_BROKER = 'zzzzzzzzzzz' 
 End 
   
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
       Select @@sett_type = "%"    
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
    

  
SET NOCOUNT ON               
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
     
SELECT               
  S.Party_code,               
  S.ContractNo,             
  Sett_no = S.Sett_no,               
  branch_cd=C1.branch_cd,              
  cl_type= cl_type,              
  sett_type= S.sett_type,              
  PRATE = (case S.sell_buy When 1 Then S.MARKETRATE Else 0 End ),              
  SRATE = (case S.sell_buy When 2 Then S.MARKETRATE Else 0 End ),           
 --AMOUNT = TRADEQTY*MARKETRATE,              
  Partyname = C1.Long_name,              
--Partipantcode = S.Partipantcode,            
  Order_No= S.Order_No,            
  Trade_No = Pradnya.DBO.ReplaceTradeNo(s.Trade_No),          
  Scrip_Cd = S.scrip_cd,          
  Series=S.Series,            
  PTradeqty = (case S.sell_buy When 1 Then S.tradeqty Else 0 End ),    
  STradeqty = (case S.sell_buy When 2 Then S.tradeqty Else 0 End ),      
  Pamt = (case S.sell_buy When 1 Then s.n_netrate * S.tradeqty Else 0 End ),      
  Samt = (case S.sell_buy When 2 Then s.n_netrate * S.tradeqty Else 0 End ),     
  Sell_Buy= S. Sell_Buy ,    
  Brokapplied = s.nbrokapp,    
  service_tax=S.service_tax,  
  Tradedate = left(convert(varchar,sauda_date,109),11),              
  BranchName = C1.Branch_CD,       
  netrate = s.n_netrate,    
  S.branch_id , S.user_id ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,     
  Tm = Convert(char(10),s.sauda_date , 108),
  pan_gir_no,               
  SDATE = Convert(varchar,s.sauda_date,112)

  Into #GlobalReport             
  FROM               
  Settlement S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1      
  Where Sauda_date >= @FROMDATE  And Sauda_date <= @TODATE + ' 23:59'          
  And S.party_code >= @FROMPARTY  And S.party_code <= @TOPARTY
  And Branch_Cd >= @FROMBRANCH And Branch_CD <= @TOBRANCH
  And Sub_Broker >= @FROMSUB_BROKER And Sub_Broker <= @TOSUB_BROKER
  
  And S.tradeqty >0  
  And S.scrip_cd = S2.scrip_cd And S.series = S2.series 
  And S1.co_code = S2.co_code And S1.series = S2.series      
  And C2.party_code = S.party_code And C1.cl_code = C2.cl_code      
  And Sett_type Like @sett_type + '%'       
  and Trade_No not like '%C%'      
  and AuctionPart Not Like 'A%'      
  And MarketRate > 0       

  /*login Conditions*/      
  And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End)       
  And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End)       
  And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)      
  And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)      
  And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End)         
  And C1.Area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)         
  And C1.Region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)         
     
  Insert Into #GlobalReport      
  SELECT               
  S.Party_code,               
  S.ContractNo,             
  Sett_no = S.Sett_no,               
  branch_cd=C1.branch_cd,              
  cl_type= cl_type,              
  sett_type= S.sett_type,              
  PRATE = (case S.sell_buy When 1 Then S.MARKETRATE Else 0 End ),              
  SRATE = (case S.sell_buy When 2 Then S.MARKETRATE Else 0 End ),    
 --AMOUNT = TRADEQTY*MARKETRATE,              
  Partyname = C1.Long_name,              
--Partipantcode = S.Partipantcode,            
  Order_No= S.Order_No,            
  Trade_No=Pradnya.DBO.ReplaceTradeNo(s.Trade_No),          
  Scrip_Cd = S.scrip_cd,          
  Series=S.Series,            
  PTradeqty = (case S.sell_buy When 1 Then S.tradeqty Else 0 End ),    
  STradeqty = (case S.sell_buy When 2 Then S.tradeqty Else 0 End ),      
  Pamt = (case S.sell_buy When 1 Then s.n_netrate * S.tradeqty Else 0 End ),      
  Samt = (case S.sell_buy When 2 Then s.n_netrate * S.tradeqty Else 0 End ),     
  Sell_Buy= S. Sell_Buy ,    
  Brokapplied = s.nbrokapp,  
  service_tax=S.service_tax,    
  Tradedate = left(convert(varchar,sauda_date,109),11),              
  BranchName = C1.Branch_CD,       
  netrate = s.n_netrate,    
  S.branch_id , S.user_id ,L_Address1,L_Address2,L_city,L_State,L_Nation,L_Zip,     
  Tm = Convert(char(10),s.sauda_date , 108),
  pan_gir_no,               
  SDATE = Convert(varchar,s.sauda_date,112)
             
  FROM               
  History S , Scrip2 S2 , Client1 C1 , Client2 C2 , Scrip1 S1      
  Where  Sauda_date >= @FROMDATE  And Sauda_date <= @TODATE + ' 23:59'          
  And S.party_code >= @FROMPARTY  And S.party_code <= @TOPARTY And S.tradeqty >0  And       
  S.scrip_cd = S2.scrip_cd  And S.series = S2.series And S1.co_code = S2.co_code And S1.series = S2.series      
  And C2.party_code = S.party_code And C1.cl_code = C2.cl_code      
  And Branch_Cd >= @FROMBRANCH And Branch_CD <= @TOBRANCH
  And Sub_Broker >= @FROMSUB_BROKER And Sub_Broker <= @TOSUB_BROKER

  And Sett_type Like @sett_type + '%'       
  and Trade_No not like '%C%'      
  and AuctionPart Not Like 'A%'      
  And MarketRate > 0       
  /*login Conditions*/      
  And C1.branch_cd Like (case When @statusid  = 'branch' Then  @statusname  Else '%' End)       
  And C1.sub_broker Like (case When  @statusid  = 'subbroker' Then @statusname  Else '%' End)       
  And C1.trader Like (case When  @statusid = 'trader' Then  @statusname Else '%' End)      
  And C1.family Like (case When  @statusid  = 'family' Then  @statusname Else '%' End)      
  And C2.party_code Like (case When  @statusid = 'client' Then  @statusname Else '%' End)        
  And C1.Area Like (case When  @statusid = 'area' Then  @statusname Else '%' End)         
  And C1.Region Like (case When  @statusid = 'region' Then  @statusname Else '%' End)         


    
If @groupby = 1
BEGIN
	SELECT * FROM #GlobalReport
	Order By Party_Code,Scrip_cd,SDATE,TM      
END 
ELSE
BEGIN
	SELECT * FROM #GlobalReport
	Order By Scrip_cd,Party_code,SDATE, tm      
END

GO
