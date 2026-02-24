-- Object: PROCEDURE dbo.Rpt_nsenetreport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 01/15/2005 1:25:15 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 12/16/2003 2:31:40 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 05/08/2002 12:35:16 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 01/14/2002 20:33:08 ******/  
  
  
  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 09/07/2001 11:09:21 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 7/1/01 2:26:46 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 06/26/2001 8:49:12 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 04/27/2001 4:32:47 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 3/21/01 12:50:22 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 20-mar-01 11:39:02 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 2/5/01 12:06:22 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_nsenetreport    Script Date: 12/27/00 8:58:57 Pm ******/  
  
/* Report : Netposition Report  
   File : Nsenetreport.asp */  
/* Displays Netposition Report For A Particular  Settlement  Type And Number For A Client Or Clients*/  
Create Procedure Rpt_nsenetreport  
@partycode Varchar(10),  
@partyname Varchar(21),  
@settno Varchar(7),  
@settype Varchar(3)  
As  
If ( Select Count(sett_no) From Settlement Where Sett_no =@settno And Sett_type =@settype ) > 0   
 Begin  
 Select S.party_code,c1.short_name,s.scrip_cd,s.series,quantity = Sum(s.tradeqty),  
 Amount = Sum(s.amount),s.sell_buy,s.sett_no,s.sett_type   
 From Settlement S,client1 C1,client2 C2   
 Where S.party_code = C2.party_code And C1.cl_code = C2.cl_code   
 And S.party_code Like Ltrim(@partycode)+'%' And C1.short_name Like  Ltrim(@partyname)+'%'  
 And S.sett_no Like  Ltrim(@settno)+'%' And S.sett_type Like  Ltrim(@settype)+'%'   
 Group By S.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy   
 Order By C1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy   
 End  
Else  
 Begin  
 Select S.party_code,c1.short_name,s.scrip_cd,s.series,quantity = Sum(s.tradeqty),  
 Amount = Sum(s.amount),s.sell_buy,s.sett_no,s.sett_type   
 From History S,client1 C1,client2 C2   
 Where S.party_code = C2.party_code And C1.cl_code = C2.cl_code   
 And S.party_code Like Ltrim(@partycode)+'%' And C1.short_name Like  Ltrim(@partyname)+'%'  
 And S.sett_no Like  Ltrim(@settno)+'%' And S.sett_type Like  Ltrim(@settype)+'%'   
 Group By S.party_code,c1.short_name,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy   
 Order By C1.short_name,s.party_code,s.scrip_cd,s.series,s.sett_no,s.sett_type,s.sell_buy   
 End

GO
