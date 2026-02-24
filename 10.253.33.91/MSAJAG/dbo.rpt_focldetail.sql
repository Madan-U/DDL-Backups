-- Object: PROCEDURE dbo.rpt_focldetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 4/30/01 5:50:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focldetail    Script Date: 12/27/00 8:59:09 PM ******/
CREATE PROCEDURE rpt_focldetail
@code varchar(10)
AS
select distinct t.party_code, t.inst_type, t.symbol, convert(varchar,t.expirydate,106) as expirydate ,
buyopenqty = isnull((select sum(tradeqty) from  fotrade f where f.sell_buy = 1 and f.o_c_flag = 1 and f.party_code = t.party_code
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
sellcloseqty = isnull((select sum(tradeqty) from fotrade f where f.sell_buy = 2 and f.o_c_flag = 0 and f.party_code = t.party_code
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
sellopenqty = isnull((select sum(tradeqty) from fotrade f where f.sell_buy = 2 and f.o_c_flag = 1 and f.party_code = t.party_code
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
buycloseqty = isnull((select sum(tradeqty) from fotrade f where f.sell_buy = 1 and f.o_c_flag = 0 and f.party_code = t.party_code
              and f.inst_type = t.inst_type and f.symbol = t.symbol and f.expirydate = t.expirydate ),0),
bqty        = isnull((select sum(tradeqty)from fotrade f where f.party_code = t.party_code and  f.sell_buy =1),0),
sqty        = isnull((select sum(tradeqty)from fotrade f where f.party_code = t.party_code and  f.sell_buy =2),0) 
from fotrade t
where t.party_code = @code

GO
