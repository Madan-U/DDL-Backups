-- Object: PROCEDURE dbo.rpt_dateclosing1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*
This procedure is written by neelambari on 10 may 2001
This procedure gives all distinct dates from closing table
*/
create  proc rpt_dateclosing1 as
select distinct left(convert(varchar,sysdate,109),11) ,convert(varchar,sysdate,101)
from closing
order by convert(varchar,sysdate,101)

GO
