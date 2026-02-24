-- Object: PROCEDURE dbo.rpt_branchDelScripClients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_branchDelScripClients    Script Date: 05/08/2002 12:35:08 PM ******/







/* Displays position wrt to nse for delivery reports */
CREATE PROCEDURE rpt_branchDelScripClients

@dematid varchar(2),
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(20),
@series varchar(3),
@branch varchar(15)

AS

if @dematid = 1
/* FOR DELEVIRY FROM NSE (DEMAT SCRIPS)*/
begin
 select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,
Qty= (case when inout = 'O' then Sum(d.Qty) else 0 end ),
demat_date=isnull(s1.demat_date,getdate()+2),Branch=C1.Trader
 from deliveryclt d,scrip1 s1,scrip2 s2,client1 c1,client2 c2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.scrip_cd like @scripcd 
 and d.series like @series and s1.demat_date < getdate() and c1.trader like ltrim(@branch)+ '%'
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,s1.demat_date,trader
 order by d.sett_no,d.sett_type,d.scrip_cd,d.series
end
if @dematid = 2
/* FOR DELEVIRY FROM NSE (NON DEMAT SCRIPS)*/
begin
 select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,
Qty= (case when inout = 'O' then Sum(d.Qty) else 0 end ),
demat_date=isnull(s1.demat_date,getdate()+2),Branch=C1.Trader
 from deliveryclt d,scrip1 s1,scrip2 s2,client1 c1,client2 c2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.scrip_cd like @scripcd 
 and d.series like @series and s1.demat_date > getdate() and c1.trader like ltrim(@branch)+ '%'
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,s1.demat_date,trader
 order by d.sett_no,d.sett_type,d.scrip_cd,d.series
end
if @dematid = 3 
/* FOR DELEVIRY FROM NSE (ALL SCRIPS)*/
begin
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,
Qty= (case when inout = 'O' then Sum(d.Qty) else 0 end ),
demat_date=isnull(s1.demat_date,getdate()+2),Branch=C1.Trader
 from deliveryclt d,scrip1 s1,scrip2 s2,client1 c1,client2 c2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.scrip_cd like ltrim(@scripcd)+'%'
 and d.series like ltrim(@series)+'%' and c1.trader like ltrim(@branch)+ '%'
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,s1.demat_date,trader
 order by d.sett_no,d.sett_type,d.scrip_cd,d.series
end

GO
