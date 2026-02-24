-- Object: PROCEDURE dbo.rpt_datesettgrossexpalbm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datesettgrossexpalbm    Script Date: 04/27/2001 4:32:38 PM ******/

/* report : gross exposure report
    file : grossexptrdset.asp 
 */
/* displays details of trades of a particular previous albm settlement */

CREATE PROCEDURE rpt_datesettgrossexpalbm
@statusid varchar(15),
@statusname varchar(25),
@partyname varchar(21),
@scripcd varchar(12),
@partycode varchar(10),
@settno varchar(7),
@trader varchar(15)

AS
if @statusid = 'broker' 
begin
select party=(s.party_code),s.scrip_cd,s.series,qty=sum(s.tradeqty),Amount=sum(s.tradeqty*s.marketrate),s.sell_buy ,c1.short_name
from settlement s,client1 c1,client2 c2 
where c2.party_code = s.party_code and c1.cl_code = c2.cl_code and c1.short_name like ltrim(@partyname)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' and s.party_code like  ltrim(@partycode)+'%' and sett_no=@settno
and sett_type='l'  and c1.trader like ltrim(@trader)+'%'
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.sell_buy 
order  by s.party_code,s.scrip_cd,s.series,s.sell_buy 
end

GO
