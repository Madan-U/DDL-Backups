-- Object: PROCEDURE dbo.Subfinalob
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 01/15/2005 1:19:36 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 12/16/2003 2:31:28 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 05/08/2002 12:35:25 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 01/14/2002 20:33:24 ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 12/26/2001 1:23:58 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 3/17/01 9:56:12 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 3/21/01 12:50:32 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 20-mar-01 11:39:10 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 2/5/01 12:06:30 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 12/27/00 8:59:16 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.subfinalob    Script Date: 11/24/2000 4:05:15 Pm ******/  
Create Proc Subfinalob (@sett_no Varchar(7),@sett_type Varchar(3),@party Varchar(10),@userid Varchar(8)) As  
Delete From Finob Where Sett_no = @sett_no And Sett_type = @sett_type   
/*insert Into Finob Select Sett_no,sett_type,getdate(),pqty = ( Select Isnull(sum(tradeqty),0) From Settlement  Where S.sett_no = Sett_no And S.sett_type = Sett_type And Sell_buy = 1),  
Pamt = ( Select Isnull(sum(tradeqty*marketrate),0) From Settlement Where S.sett_no = Sett_no And S.sett_type = Sett_type And Sell_buy = 1),  
Sqty = ( Select Isnull(sum(tradeqty),0) From Settlement  Where S.sett_no = Sett_no And S.sett_type = Sett_type And Sell_buy = 2),  
Samt = ( Select Isnull(sum(tradeqty*marketrate),0) From Settlement  Where S.sett_no = Sett_no And S.sett_type = Sett_type And Sell_buy = 2)  
From Settlement S Where Sett_no = @sett_no And Sett_type = @sett_type And  Billno > 0 And Tradeqty > 0  
Group By Sett_no,sett_type*/  
Insert Into Finob Select Sett_no,sett_type,getdate(),isnull(sum(pqty) ,0),isnull(sum(pamt) ,0),isnull(sum(sqty) ,0),isnull(sum(samt) ,0) From Subtempfinalobl  
Where Sett_no = @sett_no And Sett_type = @sett_type And Party_code Like @party + '%' And User_id Like @userid + '%'  
Group By Sett_no,sett_type

GO
