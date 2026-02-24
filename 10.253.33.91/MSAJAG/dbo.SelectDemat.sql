-- Object: PROCEDURE dbo.SelectDemat
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SelectDemat    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.SelectDemat    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.SelectDemat    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.SelectDemat    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.SelectDemat    Script Date: 12/27/00 8:59:16 PM ******/

CREATE Proc SelectDemat  As
select sett_no,sett_type, CltDpNo 'Client-Id',short_name 'Client-Name', 
c.bankid 'Dp-id',b.BankName 'Participants Name' ,c.scrip_Cd 'Security',  ISIN,qty 
from dematintimate c,bank b
where c.bankid = b.bankid 
order by c.scrip_cd,c.sett_no,c.sett_type,CltDpNo

GO
