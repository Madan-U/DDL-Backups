-- Object: PROCEDURE dbo.rpt_cldpno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_cldpno    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldpno    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldpno    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldpno    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_cldpno    Script Date: 12/27/00 8:58:54 PM ******/

CREATE PROCEDURE rpt_cldpno
@dpid varchar(12),
@cldpno varchar(12)
AS
select c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,c2.BankId ,c2.CltDpNo 
from client1 c1,client2 c2
where c1.cl_code = c2.cl_code 
and c2.BankId =@dpid and c2.CltDpNo like ltrim(@cldpno)+'%'
order by c1.Short_Name,c2.party_code

GO
