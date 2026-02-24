-- Object: PROCEDURE dbo.rpt_useridwsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_useridwsett    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_useridwsett    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_useridwsett    Script Date: 20-Mar-01 11:39:04 PM ******/



/* report : partywiseturnover 
    file : partywiseturn.asp
    displays settlement whose sec payin date is greater than today's date	
*/


CREATE PROCEDURE rpt_useridwsett

AS



select distinct s.sett_no from settlement s , sett_mst st
where st.sett_no=s.sett_no and s.sett_type=st.sett_type and s.sett_type='w'
and ( st.Sec_Payin  > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.Sec_Payin ,109),11))
order by s.sett_no

GO
