-- Object: PROCEDURE dbo.rpt_branchDelScripClients
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_branchDelScripClients    Script Date: 12/16/2003 2:31:43 PM ******/  
  
/* Displays position wrt to nse for delivery reports */  
CREATE PROCEDURE rpt_branchDelScripClients  
  
@dematid varchar(2),  
@settno varchar(7),  
@settype varchar(3),  
@scripcd varchar(20),  
@series varchar(3),  
@branch varchar(15)  
  
AS  
  
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,Scripname=d.series,  
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),  
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)),Branch=C1.Branch_Cd  
from client1 c1,client2 c2, deliveryclt d Left Outer Join DelTrans De  
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD  
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series )   
 where d.party_code = c2.party_code and c1.cl_code =c2.cl_code  
 and d.sett_no = @settno and d.sett_type = @settype and d.scrip_cd like @scripcd   
 and d.series like @series and c1.branch_cd like ltrim(@branch)+ '%'  
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty,C1.Branch_Cd  
 order by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code

GO
