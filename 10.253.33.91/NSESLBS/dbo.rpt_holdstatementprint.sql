-- Object: PROCEDURE dbo.rpt_holdstatementprint
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 12/16/2003 2:31:24 PM ******/    
    
    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 05/08/2002 12:35:16 PM ******/    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 01/14/2002 20:33:08 ******/    
    
    
    
    
    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 09/07/2001 11:09:21 PM ******/    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 7/1/01 2:26:46 PM ******/    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 06/26/2001 8:49:11 PM ******/    
    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 04/27/2001 4:32:47 PM ******/    
    
/****** Object:  Stored Procedure dbo.Rpt_NseNet    Script Date: 3/21/01 12:50:22 PM ******/    
    
CREATE Proc rpt_holdstatementprint (@FromDate varchar(11), @ToDate varchar(11), @FromParty varchar(10), @ToParty varchar(10),     
@FromScrip varchar(12), @ToScrip varchar(12),@DpId varchar(10),@CltDpId varchar(16), @StatusId Varchar(20), @StatusName Varchar(25)) As    
Truncate Table StockHold    
Insert into StockHold    
Exec Rpt_TransStatementBen @FromDate, @ToDate, @FromParty, @ToParty,@FromScrip, @ToScrip,@CltDpId, @DpId, 2, @StatusId,@StatusName    
    
select Party_Code, long_name, l_address1, l_address2, l_city, l_zip,    
Sett_no, Sett_Type, Scrip_Cd, IsIn = CertNo, Qty = Sum(CQty-DQty) From StockHold    
Where Party_Code >= @FromParty    
And Party_Code <= @ToParty    
And Scrip_Cd >= @FromScrip    
And Scrip_Cd <= @ToScrip    
Group By Party_Code, Sett_no, Sett_Type, Scrip_Cd, CertNo, long_name, l_address1, l_address2, l_city, l_zip    
Having Sum(CQty-DQty) > 0     
Order By Party_Code, Scrip_Cd, CertNo, Sett_no, Sett_Type

GO
