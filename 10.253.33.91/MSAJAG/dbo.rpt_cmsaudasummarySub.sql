-- Object: PROCEDURE dbo.rpt_cmsaudasummarySub
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_cmsaudasummarySub    Script Date: 05/20/2002 5:36:56 PM ******/
create procedure rpt_cmsaudasummarySub

@statusid varchar(15),
@statusname varchar(25),
@codefrom as varchar(20),
@codeto as varchar(20),
@sdate as varchar(12),
@tdate as varchar(12),
@symbol as varchar(12),
@pr as varchar(5)

as 


if @pr='price'
begin


/* condition for broker begins here */

if @statusid = 'broker'
begin

select sub_broker,trader,scrip_cd,series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Sub_Broker >= @codefrom
and Sub_Broker <= @codeto
and scrip_cd like @symbol
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for broker ends here */



/* procedure for subbroker starts here */

if @statusid = 'subbroker'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Sub_Broker >= @codefrom
and Sub_Broker <= @codeto
and scrip_cd like @symbol
and Sub_Broker = @Statusname
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for subbroker ends here */



/* procedure for branch starts here */

if @statusid = 'branch'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and Sub_Broker = @statusname
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for branch ends here */


/* procedure for trader starts here */

if @statusid = 'trader'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and trader = @Statusname
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for trader ends here */


/* procedure for family starts here */

if @statusid = 'family'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Family = @statusname
and scrip_cd like @symbol
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for family ends here */


/* procedure for client starts here */

if @statusid = 'client'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and party_code = @statusname
and scrip_cd like @symbol
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end
 /* condition for client ends here */

end

if @pr = 'net'
begin


/* condition for broker begins here */

if @statusid = 'broker'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Sub_Broker >= @codefrom
and Sub_Broker <= @codeto
and scrip_cd like @symbol

group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for broker ends here */



/* procedure for subbroker starts here */

if @statusid = 'subbroker'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Sub_Broker >= @codefrom
and Sub_Broker <= @codeto
and scrip_cd like @symbol
and Sub_Broker = @Statusname
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for subbroker ends here */



/* procedure for branch starts here */

if @statusid = 'branch'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and Sub_Broker = @statusname

group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for branch ends here */


/* procedure for trader starts here */

if @statusid = 'trader'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and trader = @Statusname
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for trader ends here */


/* procedure for family starts here */

if @statusid = 'family'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Family = @statusname
and scrip_cd like @symbol
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for family ends here */


/* procedure for client starts here */

if @statusid = 'client'
begin

select sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and party_code = @statusname
and scrip_cd like @symbol
group by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end
 /* condition for client ends here */

end

GO
