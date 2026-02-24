-- Object: PROCEDURE dbo.Rpt_positionsettscrip
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 01/15/2005 1:43:50 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 12/16/2003 2:31:57 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 05/08/2002 12:35:17 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 01/14/2002 20:33:10 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 12/14/2001 1:25:18 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 11/30/01 4:48:58 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 11/5/01 1:29:26 Pm ******/  
  
  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 09/07/2001 11:09:22 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 7/1/01 2:26:47 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 06/26/2001 8:49:15 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 04/27/2001 4:32:48 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 3/21/01 12:50:22 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 20-mar-01 11:39:02 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 2/5/01 12:06:22 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_positionsettscrip    Script Date: 12/27/00 8:58:57 Pm ******/  
  
/* Report : Position Report   
   File : Demat/scriptrans.asp  
   Displays Detailed Saudas Of A Particular Scrip Of A Particular Party And Particular Settlement  
*/  
Create Procedure Rpt_positionsettscrip   
@settno Varchar(7),  
@settype Varchar(3),  
@partycode Varchar(10),  
@scripcd Varchar(12),  
@series Varchar(3)  
As  
Select Sett_no,sett_type,party_code,scrip_cd,series,tradeqty,n_netrate,sell_buy,  
Sauda_date,user_id,amount   
From Settlement   
Where Sett_no = @settno And Sett_type = @settype And Party_code = @partycode  
And Scrip_cd = @scripcd And Series =@series  
Order By Sett_no,sett_type,party_code,scrip_cd,series,sauda_date,sell_buy,tradeqty,n_netrate,user_id

GO
