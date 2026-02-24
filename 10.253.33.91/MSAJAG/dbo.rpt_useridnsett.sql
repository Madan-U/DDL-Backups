-- Object: PROCEDURE dbo.rpt_useridnsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_useridnsett    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_useridnsett    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_useridnsett    Script Date: 20-Mar-01 11:39:04 PM ******/




/* report : useridwise turnover  
file :useridwiseturn.asp
*/
/* finds settlement numbers whose security payin date is greater than getdate or equal to getdate and of type='n'*/

CREATE PROCEDURE rpt_useridnsett

AS

select distinct s.sett_no from settlement s , sett_mst st
where st.sett_no=s.sett_no and s.sett_type=st.sett_type and s.sett_type='n'
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
order by s.sett_no

GO
