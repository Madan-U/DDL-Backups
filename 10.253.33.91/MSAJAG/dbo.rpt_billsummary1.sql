-- Object: PROCEDURE dbo.rpt_billsummary1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_billsummary1    Script Date: 04/27/2001 4:32:33 PM ******/
/*Created by amolika on 19 april 2001 1:21 pm*/
/*This report displays the bill summary before posting is done */
CREATE proc rpt_billsummary1 
@sett_no varchar(7),
@sett_type varchar(3)
As
select c1.short_name, a.party_code, a.bill_no,
dramt = isnull((case when sell_buy = 1 then Amount else 0 end) ,0),
cramt = isnull((case when sell_buy = 2 then Amount else 0 end ),0)
from accbill a ,client2 c2 ,client1 c1
where a.party_code = c2.party_code and c1.cl_code = c2.cl_code
and sett_no = @sett_no and sett_type = @sett_type
order by a.bill_no,c1.short_name

GO
