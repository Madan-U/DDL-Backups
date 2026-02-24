-- Object: PROCEDURE dbo.rpt_netsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : nse datewise position 
*/

     
CREATE PROCEDURE rpt_netsettype 

as

select distinct sett_type from settlement 
union 
select distinct sett_type from history

GO
