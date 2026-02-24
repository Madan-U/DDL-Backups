-- Object: PROCEDURE dbo.brscripparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brscripparty    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brscripparty    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brscripparty    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brscripparty    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brscripparty    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : motm
    FIle : mtomrepot.asp*/ 
CREATE PROCEDURE brscripparty
@br varchar(3),
@partycode varchar(10),
@shortname varchar(21)
AS
select s.scrip_cd,s.series,sum(s.tradeqty),sum(s.amount),s.sell_buy,c1.short_name,
c2.party_code,sum(s.N_NetRate) 
from settlement s,client1 c1,client2 c2,branches b 
where c1.cl_code=c2.cl_code 
and s.party_code = c2.party_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and s.billno = '0' and s.sett_type='N' 
and s.party_code like ltrim(@partycode)+'%' 
and c1.short_name like ltrim(@shortname)+'%'
group by c1.short_name,c2.party_code,s.scrip_cd ,s.series,s.sell_buy

GO
