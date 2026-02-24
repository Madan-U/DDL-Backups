-- Object: PROCEDURE dbo.Clientposition
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Clientposition    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.Clientposition    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.Clientposition    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.Clientposition    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.Clientposition    Script Date: 12/27/00 8:58:47 PM ******/

CREATE PROC Clientposition 
(@SETT_TYPE AS VARCHAR(3),
@SETT_NO VARCHAR(7),
@SHORT_NAME VARCHAR(21),
@PARTY_CODE VARCHAR(10)) 
AS
select s.Party_Code, scrip_cd,PQty = ( Select isnull(sum(Tradeqty),0) From Settlement  where  
sett_no = @SETT_NO and sett_Type = @SETT_TYPE and sell_buy = 1 
and s.Party_code = party_code and s.scrip_cd = Scrip_cd ),
 PAmt = ( Select isnull(sum(Tradeqty*marketrate),0) From Settlement 
where  sett_no = @SETT_NO and sett_Type = @SETT_TYPE 
and sell_buy = 1 and s.Party_code = party_code and s.scrip_cd = Scrip_cd), 
 SQty = ( Select isnull(sum(Tradeqty),0) From Settlement  
where  sett_no = @SETT_NO and sett_Type = @SETT_TYPE 
and sell_buy = 2 and s.Party_code = party_code and s.scrip_cd = Scrip_cd), 
 SAmt = ( Select isnull(sum(Tradeqty*marketrate),0) From Settlement  
where  sett_no =@SETT_NO and sett_Type = @SETT_TYPE and sell_buy = 2
 and s.Party_code = party_code and s.scrip_cd = Scrip_cd) ,series
 from Settlement s ,client1 c1,client2 c2 
where sett_no = @SETT_NO and sett_Type = @SETT_TYPE 
and  tradeqty > 0 and c1.trader = @SHORT_NAME  and s.party_code =@PARTY_CODE
 and c2.party_code = s.party_code and c1.cl_code = c2.cl_code 
 group by s.party_code,scrip_Cd ,series

GO
