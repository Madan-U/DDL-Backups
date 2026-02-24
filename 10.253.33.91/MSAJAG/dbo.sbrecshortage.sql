-- Object: PROCEDURE dbo.sbrecshortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbrecshortage    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbrecshortage    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbrecshortage    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbrecshortage    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbrecshortage    Script Date: 12/27/00 8:59:15 PM ******/

/***   report : nse shortage
      file : recshortage.asp   ***/
CREATE PROCEDURE sbrecshortage
@settno varchar(8),
@settype varchar(3),
@subbroker varchar(15)
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
from recdelivery r ,client1 c1,subbrokers sb
where r.sett_no=@settno and r.sett_type=@settype and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker

GO
