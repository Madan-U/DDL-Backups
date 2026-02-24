-- Object: PROCEDURE dbo.rpt_dateclosingrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*
This procedure is written by neelambari on 10 may 2001
This procedure gives aclosing rates of scrips entered by user for selected date
*/
create  proc rpt_dateclosingrate
@scripcd varchar(12),
@sdate varchar(14)
as
select market ,scrip_cd,series,Cl_Rate   from closing  where scrip_cd like @scripcd+'%'
and left(convert(varchar,sysdate,109),12) = @sdate
order by scrip_cd

GO
