-- Object: PROCEDURE dbo.rpt_currentopentry
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/*
This gives us the open entry date for supplied yr
*/
CREATE procedure rpt_currentopentry
@sdtcur datetime ,
@ldtcur datetime
as
/*
select distinct isnull(convert(varchar,vdt,109),'')  from account.dbo.ledger where vtyp='18' and
vdt >= ltrim(@sdtcur) and vdt <= ltrim(@ldtcur) + ' 23:59:59'  
*/

select distinct isnull(left(convert(varchar,vdt,109),11),'')  from account.dbo.ledger where vtyp='18' and
vdt >= @sdtcur and vdt <= @ldtcur  + ' 23:59:59'

GO
