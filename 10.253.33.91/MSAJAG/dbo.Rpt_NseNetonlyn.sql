-- Object: PROCEDURE dbo.Rpt_NseNetonlyn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : nseposition  datewise report  */

CREATE proc Rpt_NseNetonlyn

 (@sett_no varchar(7),@sett_type varchar(2)) as


select  Scrip_Cd,series,  pqty=isnull(sum(pqty),0),sqty=isnull(sum(sqty),0), pamt =isnull(sum(pamt),0), samt =isnull(sum(samt),0),  sett_no, sett_type
 from finalsumScripdatewise  where sett_no  like  ltrim(@sett_no)  and sett_type  like ltrim(@sett_type)
group by sett_no, sett_type, series, scrip_cd
order by sett_no, sett_type, series, scrip_cd

GO
