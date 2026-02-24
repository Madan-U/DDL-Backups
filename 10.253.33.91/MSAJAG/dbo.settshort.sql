-- Object: PROCEDURE dbo.settshort
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.settshort    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.settshort    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.settshort    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.settshort    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.settshort    Script Date: 12/27/00 8:59:03 PM ******/

CREATE PROCEDURE settshort
@partycode varchar(10),
@scrip varchar(15)
 AS
select d.sett_no,d.sett_type,scrip_cd,series,qty,inout,actualqty=(case d.inout when 'I'  then isnull((select sum(qty) from certinfo c 
where c.party_code=d.party_code and c.scrip_cd=d.scrip_cd and c.series=d.series and d.sett_no=c.sett_no and d.sett_type=c.sett_type
group by c.sett_no,c.sett_type,c.party_code,c.sett_no,c.sett_type,c.scrip_cd,c.series),0) 
when 'O' then
isnull((select sum(qty) from certinfo c 
where c.targetparty=d.party_code and c.scrip_cd=d.scrip_cd and c.series=d.series and d.sett_no=c.sett_no and d.sett_type=c.sett_type
group by c.sett_no,c.sett_type,c.targetparty,c.sett_no,c.sett_type,c.scrip_cd,c.series ),0) end),
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() and s1.co_code=s2.co_code and s2.scrip_cd=d.scrip_cd
and s2.series=d.series ), '')
from deliveryclt d where d.inout <> 'N'
and d.party_code=@partycode and d.scrip_Cd=@scrip
order by scrip_cd

GO
