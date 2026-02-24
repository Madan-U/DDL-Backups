-- Object: PROCEDURE dbo.sbclientshortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbclientshortage    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbclientshortage    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbclientshortage    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbclientshortage    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbclientshortage    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE sbclientshortage
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12),
@subbroker varchar(15)
AS
select d.sett_no,d.sett_type,d.party_code,d.scrip_cd,reqqty=sum(qty), 
actualqty=isnull((select sum(qty) from certinfo c where d.sett_no=c.sett_no and d.sett_type=c.sett_type 
and d.party_code=c.party_code and d.scrip_cd=c.scrip_Cd and d.series=c.series 
group by c.sett_no,c.sett_type,c.party_code,c.scrip_cd,c.series),0)from deliveryclt d,client1 c1, client2 c2, subbrokers sb
where d.sett_no=@settno and sb.sub_broker=c1.sub_broker  and c2.party_code=d.party_code and 
c1.cl_code=c2.cl_code and sb.sub_broker=@subbroker
and d.sett_type=@settype and inout='i' and d.scrip_Cd=@scripcd
group by d.sett_no,d.sett_type,d.party_code,d.scrip_Cd,d.series

GO
