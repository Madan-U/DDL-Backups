-- Object: PROCEDURE dbo.rpt_onlynormal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_onlynormal    Script Date: 04/27/2001 4:32:47 PM ******/

/* displays details for n-l or w-p option from datewise position report */


CREATE PROCEDURE  rpt_onlynormal 

@sett_type varchar(3),
@fromsett varchar(7),
@tosett varchar(7),
@code varchar(10)


 AS

delete from settrptgrpexp
insert into  settrptgrpexp 
select sett_no,sett_type,party_code,scrip_cd,series,sell_buy,pqty,pamt,Sqty,samt 
 from tempsettsumExp where sett_no in (select distinct sett_no from sett_mst where sett_type like  ltrim(@sett_type)+'%' and sett_no between @fromsett and  @tosett) and party_code like ltrim(@code)+'%'
and sett_type like ltrim(@sett_type)+'%'
order by party_code, scrip_cd

GO
