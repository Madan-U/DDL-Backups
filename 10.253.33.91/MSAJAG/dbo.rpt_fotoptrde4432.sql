-- Object: PROCEDURE dbo.rpt_fotoptrde4432
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 4/30/01 5:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotoptrde4432    Script Date: 12/27/00 8:59:11 PM ******/
CREATE PROCEDURE rpt_fotoptrde4432
AS
select t.party_code,c1.short_name,inst_type,symbol,convert(varchar,expirydate,106)'expirydate',
sell_Buy 
from fotrade4432 t,client1 c1,client2 c2 
where t.party_code = c2.party_code  
and c1.cl_code = c2.cl_code 
group by t.party_code,c1.short_name,inst_type,symbol,expirydate,sell_Buy
order by t.party_code,c1.short_name,inst_type,symbol,expirydate,sell_Buy

GO
