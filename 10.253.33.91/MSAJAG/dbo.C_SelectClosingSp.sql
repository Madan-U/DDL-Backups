-- Object: PROCEDURE dbo.C_SelectClosingSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







/****** Object:  Stored Procedure dbo.C_SelectClosingSp    Script Date: 12/26/2001 12:13:13 PM ******/
create Proc C_SelectClosingSp 
@ClosingDate varchar(11)
as
select distinct c.scrip_cd, c.Series, c.cl_rate, c.sysdate  from closing C, C_securitiesMst C1
where cl_rate = isnull((select cl_rate from closing where sysdate like @ClosingDate + '%' and 
	C.scrip_cd = scrip_cd and C.series = series and C.market = market),
	(select cl_rate from closing where sysdate = (select max(sysdate) from closing where sysdate < @ClosingDate + ' 23:59:59'
	and C.scrip_cd = scrip_cd and C.series = series and C.market = market)
	and C.scrip_cd = scrip_cd and C.series = series and C.market = market))
and c.scrip_cd = c1.scrip_cd and c.series = c1.series
group by c.scrip_cd, c.series, c.sysdate, c.cl_rate

GO
