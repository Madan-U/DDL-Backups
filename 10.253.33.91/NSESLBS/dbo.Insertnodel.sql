-- Object: PROCEDURE dbo.Insertnodel
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 01/15/2005 1:24:09 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 12/16/2003 2:31:38 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 05/08/2002 12:35:04 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 01/14/2002 20:32:44 ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 12/26/2001 1:23:10 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 3/17/01 9:55:53 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 3/21/01 12:50:09 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 20-mar-01 11:38:51 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 2/5/01 12:06:14 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.insertnodel    Script Date: 12/27/00 8:58:51 Pm ******/  
  
Create Procedure Insertnodel  
@srno Int,  
@scrip_cd Char(12) ,  
@series Char(6) ,  
@sett_no Varchar(10),  
@sett_type Varchar(2),  
@start_date Smalldatetime ,  
@end_date Smalldatetime ,  
@settledin Char(9)   
As   
Insert Into Nodel Values(@srno,@scrip_cd,@series,@sett_no,@sett_type,@start_date,@end_date,@settledin)

GO
