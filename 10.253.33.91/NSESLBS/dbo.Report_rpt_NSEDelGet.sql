-- Object: PROCEDURE dbo.Report_rpt_NSEDelGet
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------










/****** Object:  Stored Proc Report_dbo.rpt_NSEDelGet    Script Date: 05/08/2002 12:35:16 PM ******/









/****** Object:  Stored Proc Report_dbo.rpt_NSEDelGet    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Proc Report_dbo.rpt_NSEDelGet    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Proc Report_dbo.rpt_NSEDelGet    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Proc Report_dbo.rpt_NSEDelGet    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Proc Report_dbo.rpt_NSEDelGet    Script Date: 12/27/00 8:59:13 PM ******/
CREATE Proc Report_rpt_NSEDelGet
@dematid varchar(2),
@settno varchar(7),
@settype varchar(3)
AS

Set Transaction Isolation level read uncommitted
 select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GetFromNse=d.Qty,
 givenNse= isnull(Sum(Case When DrCr = 'D' Then DT.qty Else 0 End),0),
 RecievedNse=isnull(Sum(Case When DrCr = 'C' Then DT.qty Else 0 End),0)
 from DelNet d Left Outer Join Deltrans_Report DT
 On (DT.sett_no = d.sett_no and Dt.sett_type = d.sett_type and 
 DT.scrip_cd = d.scrip_cd and Dt.series = d.series and TrType = 906 
 And filler2 = 1 )
 where d.sett_no = @settno and d.sett_type = @settype and inout = 'O' 
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,D.Qty
 Order By d.sett_no,d.sett_type,D.scrip_cd,d.series

GO
