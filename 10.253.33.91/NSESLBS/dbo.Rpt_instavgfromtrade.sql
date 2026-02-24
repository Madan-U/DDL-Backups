-- Object: PROCEDURE dbo.Rpt_instavgfromtrade
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_instavgfromtrade    Script Date: 01/15/2005 1:40:29 Pm ******/  
Create Procedure Rpt_instavgfromtrade  
@type Varchar(3), @frompartycode Varchar(10), @topartycode Varchar(10), @fromscripcode Varchar(10),  
@toscripcode Varchar(10), @orderno Varchar(16), @statusid Varchar(15), @statusname Varchar(25)  
  
-- @type Varchar(3)  
As  
If @type = 'ins'  
  
Begin  
/*  
Select Scrip_cd,series,party_code,sell_buy,left(convert(varchar,sauda_date,109),11) As Sauda_date,  
Tradeqty = Sum(tradeqty),avgrate = Sum(marketrate*tradeqty)/sum(tradeqty)  
From Trade Where Partipantcode <> (select Membercode From Owner)  
Group By Scrip_cd,series,party_code,sell_buy,left(convert(varchar,sauda_date,109),11)  
Order By Party_code,scrip_cd,sell_buy,left(convert(varchar,sauda_date,109),11)  
*/  
Select Scrip_cd = ( Case     
   When Partipantcode <> (select Membercode From Owner)     
   Then Scrip_cd     
   Else ' *' + Ltrim(rtrim(scrip_cd)) End ),    
Series,trade.party_code,sell_buy,left(convert(varchar,sauda_date,109),11) As Sauda_date,      
Tradeqty = Sum(tradeqty),avgrate = Sum(marketrate*tradeqty)/sum(tradeqty),partipantcode,user_id, Trade.order_no  
From Trade,client1 C1,client2 C2   
Where (partipantcode <> (select Membercode From Owner) Or C1.cl_type In ('ins','pro'))    
And Trade.party_code = C2.party_code And C2.cl_code = C1.cl_code  
And Trade.party_code>= @frompartycode And Trade.party_code<= @topartycode   
And Trade.scrip_cd>= @fromscripcode And Trade.scrip_cd<= @toscripcode  
And Trade.order_no Like @orderno + '%'   
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)   
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)   
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)   
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)   
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)   
Group By Scrip_cd,series,trade.party_code,sell_buy,left(convert(varchar,sauda_date,109),11),partipantcode,user_id, Trade.order_no  
Order By Trade.party_code,scrip_cd,sell_buy,left(convert(varchar,sauda_date,109),11),user_id  
  
End  
  
If @type = 'cli'  
  
Begin  
/*  
Select Scrip_cd,series,party_code,sell_buy,left(convert(varchar,sauda_date,109),11) As Sauda_date,  
Tradeqty = Sum(tradeqty),avgrate = Sum(marketrate*tradeqty)/sum(tradeqty)  
From Trade Where Partipantcode = (select Membercode From Owner)  
Group By Scrip_cd,series,party_code,sell_buy,left(convert(varchar,sauda_date,109),11)  
Order By Party_code,scrip_cd,sell_buy,left(convert(varchar,sauda_date,109),11)  
*/  
Select Scrip_cd = ( Case     
   When Partipantcode = (select Membercode From Owner)     
   Then Scrip_cd     
   Else ' *' + Ltrim(rtrim(scrip_cd)) End ),series,trade.party_code,sell_buy,left(convert(varchar,sauda_date,109),11) As Sauda_date,      
Tradeqty = Sum(tradeqty),avgrate = Sum(marketrate*tradeqty)/sum(tradeqty),partipantcode,user_id,   
Trade.order_no  
From Trade,client1 C1,client2 C2   
Where C1.cl_type Not In ('ins','pro')  
And Trade.party_code = C2.party_code And C2.cl_code = C1.cl_code    
And Trade.party_code>= @frompartycode And Trade.party_code<= @topartycode   
And Trade.scrip_cd>= @fromscripcode And Trade.scrip_cd<= @toscripcode  
And Trade.order_no Like @orderno + '%'   
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)   
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)   
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)   
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)   
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)   
Group By Scrip_cd,series,trade.party_code,sell_buy,left(convert(varchar,sauda_date,109),11),  
Partipantcode,user_id, Trade.order_no  
Order By Trade.party_code,scrip_cd,sell_buy,left(convert(varchar,sauda_date,109),11),user_id  
  
End  
  
If @type = 'all'  
  
Begin  
/*  
Select Scrip_cd,series,party_code,sell_buy,left(convert(varchar,sauda_date,109),11) As Sauda_date,  
Tradeqty = Sum(tradeqty),avgrate = Sum(marketrate*tradeqty)/sum(tradeqty)  
From Trade   
Group By Scrip_cd,series,party_code,sell_buy,left(convert(varchar,sauda_date,109),11)  
Order By Party_code,scrip_cd,sell_buy,left(convert(varchar,sauda_date,109),11)  
*/  
Select Scrip_cd,series,trade.party_code,sell_buy,left(convert(varchar,sauda_date,109),11) As Sauda_date,      
Tradeqty = Sum(tradeqty),avgrate = Sum(marketrate*tradeqty)/sum(tradeqty),partipantcode,user_id,   
Trade.order_no  
From Trade,client1 C1,client2 C2   
Where Trade.party_code = C2.party_code And C2.cl_code = C1.cl_code    
And Trade.party_code>= @frompartycode And Trade.party_code<= @topartycode   
And Trade.scrip_cd>= @fromscripcode And Trade.scrip_cd<= @toscripcode  
And Trade.order_no Like @orderno + '%'    
And Branch_cd Like (case When @statusid = 'branch' Then @statusname Else '%' End)   
And Sub_broker Like (case When @statusid = 'subbroker' Then @statusname Else '%' End)   
And Trader Like (case When @statusid = 'trader' Then @statusname Else '%' End)   
And Family Like (case When @statusid = 'family' Then @statusname Else '%' End)   
And C2.party_code Like (case When @statusid = 'client' Then @statusname Else '%' End)   
Group By Scrip_cd,series,trade.party_code,sell_buy,left(convert(varchar,sauda_date,109),11),  
Partipantcode,user_id, Trade.order_no  
Order By Trade.party_code,scrip_cd,sell_buy,left(convert(varchar,sauda_date,109),11),user_id      
  
End

GO
