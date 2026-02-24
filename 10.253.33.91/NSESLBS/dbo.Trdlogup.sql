-- Object: PROCEDURE dbo.Trdlogup
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 01/15/2005 1:20:14 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 12/16/2003 2:31:29 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 05/08/2002 12:35:25 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 01/14/2002 20:33:25 ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 12/26/2001 1:23:59 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 3/17/01 9:56:12 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 3/21/01 12:50:33 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 20-mar-01 11:39:11 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 2/5/01 12:06:30 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.trdlogup    Script Date: 12/27/00 8:59:17 Pm ******/  
  
Create Procedure Trdlogup As  
Insert Into Trdlog  
Select T.user_id,sauda_date=left(convert(varchar,t.sauda_date,109),11), Time = Convert(char,getdate(),108),  
       Pqty = ( Select Isnull(sum(tradeqty),0) From Trade Where Sell_buy = 1 And User_id = T.user_id ),  
       Sqty = ( Select Isnull(sum(tradeqty),0) From Trade Where Sell_buy = 2 And User_id = T.user_id ),  
       Prate = ( Select Isnull(sum(tradeqty*marketrate),0) From Trade Where Sell_buy = 1 And User_id = T.user_id ),  
       Srate = ( Select Isnull(sum(tradeqty*marketrate),0) From Trade Where Sell_buy = 2 And User_id = T.user_id ),0,''       
From Trade T   
Group By User_id,left(convert(varchar,t.sauda_date,109),11)

GO
