-- Object: PROCEDURE dbo.brrecshort
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brrecshort    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brrecshort    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brrecshort    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brrecshort    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brrecshort    Script Date: 12/27/00 8:59:06 PM ******/

CREATE PROCEDURE brrecshort
@settno varchar(8),
@settype varchar(3),
@br varchar(3)
as
select distinct r.scrip_Cd,r.series, r.entitycode,r.name, r.TorecieveQty, 
r.received_Qty, 
qty=isnull((select sum(qty)from certinfo c where c.sett_no=r.sett_no 
and c.sett_type=r.sett_type and c.scrip_cd=r.scrip_Cd and 
c.series=r.series and c.party_code=r.entitycode 
group by c.sett_no,c.sett_type, c.scrip_Cd,c.series),0), 
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 
where s1.demat_date<=getdate() and s1.co_code=s2.co_code and 
s2.scrip_cd=r.scrip_cd ), '') 
from recdelivery r , deliveryclt clt , client1 c1, client2 c2, branches b 
where r.sett_no=@settno and r.sett_type=@settype and
r.sett_no=clt.sett_no and clt.sett_type=r.sett_type and clt.series=r.series and clt.scrip_cd=r.scrip_Cd and
b.short_name=c1.trader and c2.party_code=clt.party_code and c1.cl_code=c2.cl_code and b.branch_cd=@br
Group by R.sett_no,r.sett_Type,r.scrip_Cd,r.series, r.entitycode,r.name, r.TorecieveQty,r.received_Qty

GO
