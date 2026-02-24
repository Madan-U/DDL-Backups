-- Object: PROCEDURE dbo.brsettnotype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettnotype    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsettnotype    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsettnotype    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsettnotype    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsettnotype    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : Netnsereport
    File : dematscrips.asp
displays settwise scripwise netposition
*/
CREATE PROCEDURE brsettnotype
@br varchar(3),
@settno varchar(7),
@setttype varchar(3)
AS
select s.scrip_cd,s.series,s.sell_buy,Qty=sum(s.tradeqty),
Amt=sum(s.tradeqty*marketrate),s.sett_no,s.sett_Type,isnull(s1.demat_date,0) 
from settlement s,scrip1 s1, scrip2 s2, branches b, client1 c1, client2 c2
where s1.co_code = s2.co_code 
and s1.series = s2.series 
and s2.scrip_cd = s.scrip_cd 
and s2.series =s.series 
and s.sett_no = @settno
and s.sett_type = @setttype
and s.party_code=c2.party_code
and c1.cl_code=c2.cl_code
and b.short_name=c1.trader
and b.branch_cd=@br
group by s.scrip_cd,s.series,s.sell_buy,s.sett_no,s.sett_Type,s1.demat_date 
order by s.scrip_cd,s.series,s.sett_no,s.sett_Type,s.sell_buy

GO
