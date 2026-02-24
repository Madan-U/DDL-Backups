-- Object: PROCEDURE dbo.rpt_albmsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmsett    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmsett    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmsett    Script Date: 20-Mar-01 11:38:53 PM ******/











/* report: misnews
   file : topscrip_Client.asp
*/
/* finds current settlement number */
/* changed by mousami on 15/02/2001 
    if there is no n type record in settlement it was not showing 
    latest settlement number of n and report was going wrong
    so to find current settlement number there is no need to relate to settlement table
*/

CREATE PROCEDURE rpt_albmsett

AS


select distinct sett_no from sett_mst  where sett_type='N'
AND (getdate() between start_date and end_date) 
 
/*
select distinct s.sett_no from settlement s, sett_mst st where billno='0' and s.sett_type='N'
AND (getdate() between st.start_date and st.end_date) and st.sett_no=s.sett_no and
s.sett_type=st.sett_type
*/

GO
