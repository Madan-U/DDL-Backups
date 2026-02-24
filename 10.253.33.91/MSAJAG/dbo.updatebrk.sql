-- Object: PROCEDURE dbo.updatebrk
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.updatebrk    Script Date: 3/17/01 9:56:13 PM ******/

/****** Object:  Stored Procedure dbo.updatebrk    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.updatebrk    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.updatebrk    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.updatebrk    Script Date: 12/27/00 8:59:05 PM ******/

CREATE procedure updatebrk as
update settlement
set brokapplied = sb.brokapplied , 
 netrate = sb.netrate , 
 amount = sb.amount ,
 table_no = sb.table_no ,
 line_no =sb.line_no ,
 val_perc = sb.val_perc ,
 service_tax = sb.service_tax ,
 n_netrate = sb.netrate ,
 nsertax = sb.service_tax,
 nbrokapp = sb.brokapplied,
 normal = sb.normal ,
 day_puc = sb.day_puc ,
 day_sales = sb.day_sales ,
 sett_purch = sb.sett_purch ,
 sett_sales = sb.sett_sales
from settbrkchg  sb , settlement st
where sb.party_code = st.party_code
and sb.trade_no = st.trade_no
and sb.scrip_cd = st.scrip_cd
and sb.series = st.series
and sb.sell_buy = st.sell_buy
 and st.sett_no= sb.sett_no
and st.sett_type = sb.sett_type

GO
