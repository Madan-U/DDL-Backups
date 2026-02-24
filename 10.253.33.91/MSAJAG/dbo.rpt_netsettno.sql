-- Object: PROCEDURE dbo.rpt_netsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : datewisensenetposition */

CREATE PROCEDURE  rpt_netsettno

@settype varchar(3)

as

select distinct sett_no from settlement 
where sett_type=@settype
union 
select distinct sett_no from history
where sett_type=@settype
order by sett_no desc

GO
