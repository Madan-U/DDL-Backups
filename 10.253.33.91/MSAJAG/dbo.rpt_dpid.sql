-- Object: PROCEDURE dbo.rpt_dpid
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_dpid    Script Date: 04/27/2001 4:32:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_dpid    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_dpid    Script Date: 20-Mar-01 11:38:55 PM ******/

/****** Object:  Stored Procedure dbo.rpt_dpid    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_dpid    Script Date: 12/27/00 8:59:08 PM ******/

CREATE PROCEDURE rpt_dpid
@dpid varchar(12),
@cltdpno varchar(12)
AS
select c2.party_code,c1.Short_Name, c1.L_Address1,c1.L_Address2,c1.L_Address3,c1.L_city c1,L_Zip, 
c1.Res_Phone1,c1.Off_Phone1,c1.Credit_Limit,c1.trader,b.BankId ,m.CltDpNo, 
b.bankname from client1 c1, multicltid m,  
client2 c2 , bank b where c2.party_code=m.party_code and 
c1.cl_code=c2.cl_code and b.bankid=m.dpid and m.party_code in  
(select distinct party_code from multicltid where 
m.dpid = @dpid and m.cltdpno like @cltdpno +'%')

GO
