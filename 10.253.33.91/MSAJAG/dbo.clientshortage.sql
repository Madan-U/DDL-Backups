-- Object: PROCEDURE dbo.clientshortage
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientshortage    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.clientshortage    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clientshortage    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clientshortage    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clientshortage    Script Date: 12/27/00 8:58:47 PM ******/

CREATE PROCEDURE clientshortage
@settno varchar(8),
@settype varchar(3),
@scripcd varchar(12)
as
select d.sett_no,d.sett_type,d.party_code,d.scrip_cd,reqqty=sum(qty), 
actualqty=isnull((select sum(qty) from certinfo c where d.sett_no=c.sett_no and d.sett_type=c.sett_type 
and d.party_code=c.party_code and d.scrip_cd=c.scrip_Cd and d.series=c.series 
group by c.sett_no,c.sett_type,c.party_code,c.scrip_cd,c.series),0)from deliveryclt d where d.sett_no=@settno and 
d.sett_type=@settype  and inout='i' and d.scrip_Cd=@scripcd 
group by d.sett_no,d.sett_type,d.party_code,d.scrip_Cd,d.series

GO
