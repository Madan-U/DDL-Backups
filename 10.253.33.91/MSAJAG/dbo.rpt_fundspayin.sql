-- Object: PROCEDURE dbo.rpt_fundspayin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_fundspayin    Script Date: 04/27/2001 4:32:42 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fundspayin    Script Date: 3/21/01 12:50:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fundspayin    Script Date: 20-Mar-01 11:38:58 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fundspayin    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fundspayin    Script Date: 12/27/00 8:58:54 PM ******/

/* report : traderwiseturnover report 
   file :traderwiseturn.asp
   displays settlement numbers whose funds pay in date is greater than or equal to today's date (includes settlements in 
    nodelivery and all settlement types)
*/    
CREATE PROCEDURE rpt_fundspayin
AS
select distinct s.sett_no, s.sett_type from settlement s, sett_mst st where  
st.sett_no=s.sett_no  and st.sett_type=s.sett_type 
and ( st.funds_payin > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.funds_payin,109),11))
union 
select distinct s.sett_no, s.sett_type from history s, sett_mst st where  
st.sett_no=s.sett_no  and st.sett_type=s.sett_type 
and ( st.funds_payin > getdate() or left(convert(varchar,getdate(),109),11) = left(convert(varchar,st.funds_payin,109),11))
order by s.sett_type,s.sett_no

GO
