-- Object: PROCEDURE dbo.sbtopscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtopscrip    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtopscrip    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtopscrip    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtopscrip    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtopscrip    Script Date: 12/27/00 8:59:02 PM ******/

/* ***  file :topclient_scrip.asp
 report :managementinfo
displays 5 top traded scrips till moment
 ***/
CREATE PROCEDURE sbtopscrip
@subbroker varchar(15)
AS
select t.scrip_cd,t.series,nettamt = sum(t.tradeqty *t.marketrate),sell_Buy from trade4432 t, client2 c2, client1 c1,
subbrokers sb 
where t.party_code=c2.party_code and c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker
and sb.sub_broker=@subbroker
group by t.scrip_cd,t.series ,t.sell_Buy having sum(t.tradeqty * t.marketrate) >500000

GO
