-- Object: PROCEDURE dbo.cumdel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.cumdel    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.cumdel    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.cumdel    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.cumdel    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.cumdel    Script Date: 12/27/00 8:58:48 PM ******/

CREATE PROCEDURE cumdel
@partycode varchar(10)
as
 
select  scrip_cd,series,qty=sum(qty),inout,
actualqty=(case d.inout when 'I'  then isnull((select sum(qty) from certinfo c 
where c.party_code=d.party_code and c.scrip_cd=d.scrip_cd and c.series=d.series
group by c.party_code,c.scrip_cd,c.series),0) 
when 'O' then
isnull((select sum(qty) from certinfo c 
where c.targetparty=d.party_code and c.scrip_cd=d.scrip_cd and c.series=d.series
group by c.targetparty,c.scrip_cd,c.series),0) end),
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where 
s1.demat_date<=getdate() and s1.co_code=s2.co_code and s2.scrip_cd=d.scrip_cd
and s2.series=d.series ), '')
from deliveryclt d where d.inout <> 'N'
and d.party_code=@partycode
group by d.party_code,d.scrip_Cd,d.series,d.inout
order by scrip_cd,series,inout

GO
