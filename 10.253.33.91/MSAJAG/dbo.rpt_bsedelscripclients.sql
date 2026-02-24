-- Object: PROCEDURE dbo.rpt_bsedelscripclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bsedelscripclients    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelscripclients    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelscripclients    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelscripclients    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsedelscripclients    Script Date: 12/27/00 8:58:53 PM ******/

CREATE PROCEDURE rpt_bsedelscripclients
@dematid varchar(2),
@settno varchar(7), 
@scripname varchar(7)
AS
if @dematid = 1
begin
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,
Qty=Sum(d.Qty),demat_date=isnull(s1.demat_date,getdate()+2), s2.scrip_cd 'scripname'
from deliveryclt d,msajag.dbo.scrip1 s1,msajag.dbo.scrip2 s2,
msajag.dbo.client1 c1,msajag.dbo.client2 c2
where s1.co_code = s2.co_code and s2.bsecode = d.scrip_cd  
and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and s2.scrip_cd like ltrim(@scripname)+'%'
and s1.demat_date < getdate()
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.party_code,
c1.short_name,d.inout,s1.demat_date, s2.scrip_cd
end
if @dematid = 2
begin
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,
Qty=Sum(d.Qty),demat_date=isnull(s1.demat_date,getdate()+2), s2.scrip_cd 'scripname'
from deliveryclt d,msajag.dbo.scrip1 s1,msajag.dbo.scrip2 s2,
msajag.dbo.client1 c1,msajag.dbo.client2 c2
where s1.co_code = s2.co_code and s2.bsecode = d.scrip_cd  
and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno  and s2.scrip_cd like ltrim(@scripname)+'%'
and s1.demat_date > getdate()
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.party_code,
c1.short_name,d.inout,s1.demat_date, s2.scrip_cd 
end
if @dematid = 3
begin
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,
Qty=Sum(d.Qty),s2.scrip_cd 'scripname'
from deliveryclt d,msajag.dbo.scrip1 s1, msajag.dbo.scrip2 s2, 
msajag.dbo.client1 c1, msajag.dbo.client2 c2
where s1.co_code = s2.co_code and s2.bsecode = d.scrip_cd  
and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no =@settno and s2.scrip_cd like ltrim(@scripname)+'%'
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.party_code,
c1.short_name,d.inout,s2.scrip_cd
end

GO
