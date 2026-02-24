-- Object: PROCEDURE dbo.rpt_cmsaudasummaryBranch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_cmsaudasummaryBranch    Script Date: 05/20/2002 5:36:55 PM ******/
create procedure rpt_cmsaudasummaryBranch

@statusid varchar(15),
@statusname varchar(25),
@codefrom as varchar(20),
@codeto as varchar(20),
@sdate as varchar(12),
@tdate as varchar(12),
@symbol as varchar(12),
@pr as varchar(5),
@Sub_Broker as Varchar(10)


as 


if @pr='price'
begin


/* condition for broker begins here */

if @statusid = 'broker'
begin

select branch_cd,sub_broker,trader,scrip_cd,series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and branch_cd >= @codefrom
and branch_cd <= @codeto
and scrip_cd like @symbol
and Sub_Broker like @Sub_Broker
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for broker ends here */



/* procedure for subbroker starts here */

if @statusid = 'subbroker'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and branch_cd >= @codefrom
and branch_cd <= @codeto
and scrip_cd like @symbol
and Sub_Broker = @Statusname
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for subbroker ends here */



/* procedure for branch starts here */

if @statusid = 'branch'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and Branch_Cd = @statusname
and Sub_Broker like @Sub_Broker
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for branch ends here */


/* procedure for trader starts here */

if @statusid = 'trader'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and trader = @Statusname
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for trader ends here */


/* procedure for family starts here */

if @statusid = 'family'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Family = @statusname
and scrip_cd like @symbol
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for family ends here */


/* procedure for client starts here */

if @statusid = 'client'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummaryview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and party_code = @statusname
and scrip_cd like @symbol
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end
 /* condition for client ends here */

end

if @pr = 'net'
begin


/* condition for broker begins here */

if @statusid = 'broker'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Branch_cd >= @codefrom
and Branch_cd <= @codeto
and scrip_cd like @symbol
and Sub_Broker like @Sub_Broker
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for broker ends here */



/* procedure for subbroker starts here */

if @statusid = 'subbroker'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and branch_cd >= @codefrom
and branch_cd <= @codeto
and scrip_cd like @symbol
and Sub_Broker = @Statusname
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for subbroker ends here */



/* procedure for branch starts here */

if @statusid = 'branch'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and Branch_Cd = @statusname
and Sub_Broker like @Sub_Broker
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for branch ends here */


/* procedure for trader starts here */

if @statusid = 'trader'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and scrip_cd like @symbol
and trader = @Statusname
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for trader ends here */


/* procedure for family starts here */

if @statusid = 'family'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and Family = @statusname
and scrip_cd like @symbol
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end

/* condition for family ends here */


/* procedure for client starts here */

if @statusid = 'client'
begin

select branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type,
pqty=sum(pqty),sqty=sum(sqty),pval=sum(pval),sval=sum(sval)
from rpt_cmsaudasummarynetview
where sauda_date >= @sdate
and sauda_date <= @tdate + ' 23:59:00'
and party_code = @statusname
and scrip_cd like @symbol
group by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type
order by branch_cd,sub_broker,trader,scrip_cd,Series,yr,mn,dt,sett_no,sett_type

end
 /* condition for client ends here */

end

GO
