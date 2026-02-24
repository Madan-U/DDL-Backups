-- Object: PROCEDURE dbo.delsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.delsett    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.delsett    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.delsett    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.delsett    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.delsett    Script Date: 12/27/00 8:58:49 PM ******/

CREATE PROCEDURE delsett
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10)
as 
select  scrip_cd,series,qty,inout,recqty=isnull((select sum(qty) from certinfo c 
where c.sett_no=d.sett_no and c.sett_type=d.sett_type 
and c.party_code=d.party_code and c.scrip_cd=d.scrip_cd and c.series=d.series
group by c.sett_no,c.sett_type,c.party_code,c.scrip_cd,c.series),0),
delqty=isnull((select sum(qty) from certinfo c 
where c.sett_no=d.sett_no and c.sett_type=d.sett_type 
and c.targetparty=d.party_code and c.scrip_cd=d.scrip_cd and c.series=d.series 
group by c.sett_no,c.sett_type,c.targetparty,c.scrip_cd,c.series),0),
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() and s1.co_code=s2.co_code and s2.scrip_cd=d.scrip_cd
and s2.series=d.series ), '')
from deliveryclt d where d.sett_no=@settno and d.sett_type=@settype and d.inout <> 'N'
and d.party_code=@partycode
order by scrip_cd

GO
