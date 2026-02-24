-- Object: PROCEDURE dbo.Rpt_billreportdelchrg
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 01/15/2005 1:27:48 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 12/16/2003 2:31:43 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 05/08/2002 12:35:08 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 01/14/2002 20:32:52 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 12/14/2001 1:25:14 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 11/30/01 4:48:31 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_billreportdelchrg    Script Date: 11/5/01 1:27:16 Pm ******/  
Create Procedure Rpt_billreportdelchrg  
  
@settno Varchar(10),  
@settype Varchar(3),  
@partycode Varchar(10)  
  
As  
  
Select   
Delchrg = (case When C2.service_chrg = 1 Then (convert(numeric(9,2),isnull(sum(tradeqty*nbrokapp),0) -  
 Isnull(sum(tradeqty*brokapplied),0)) + ( Sum(nsertax - Service_tax))) Else  
 (convert(numeric(9,2),isnull(sum(tradeqty*nbrokapp),0) -  
 Isnull(sum(tradeqty*brokapplied),0))) End)   
From Client1 C1, Client2 C2, Settlement S  
Where C1.cl_code = C2.cl_code  
And C2.party_code = S.party_code  
And S.sett_type = @settype  
And S.sett_no = @settno And S.party_code = @partycode  
Group By C2.service_chrg

GO
