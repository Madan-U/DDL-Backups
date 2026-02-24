-- Object: PROCEDURE dbo.rpt_mtomtablefill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtomtablefill    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomtablefill    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomtablefill    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomtablefill    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtomtablefill    Script Date: 12/27/00 8:58:56 PM ******/

/* report: newmtom 
   file : mtomtablefill
*/
CREATE PROCEDURE rpt_mtomtablefill
@partycode varchar(10),
@partyname varchar(21)
AS
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,c2.party_code,c1.cl_code 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code and s.party_code = c2.party_code 
and s.billno = '0' and s.sett_type='N' 
and s.party_code like ltrim(@partycode)
and c1.short_name like ltrim(@partyname)
group by c1.short_name,c2.party_code,c1.cl_code,s.scrip_cd ,s.series,s.sell_buy

GO
