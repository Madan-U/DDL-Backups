-- Object: PROCEDURE dbo.recshortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.recshortage    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.recshortage    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.recshortage    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.recshortage    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.recshortage    Script Date: 12/27/00 8:59:08 PM ******/

CREATE PROCEDURE recshortage
@settno varchar(8),
@settype varchar(3)
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
from recdelivery r 
where r.sett_no=@settno and r.sett_type=@settype

GO
