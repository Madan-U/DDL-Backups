-- Object: PROCEDURE dbo.Online_SettMastFile
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Online_SettMastFile    Script Date: 04/13/2004 2:28:35 PM ******/
Create Proc Online_SettMastFile AS

select sett_no,sett_type,exchange,convert(varchar(10),start_date,103) as start_date,
convert(varchar(10),end_date,103) as end_date,convert(varchar(10),sec_payin,103) as sec_payin,
convert(varchar(10),sec_payout,103) as sec_payout,convert(varchar(10),funds_payin,103) as funds_payin,
convert(varchar(10),funds_payout,103) as funds_payout, 
Year=Year(Sec_Payin),Month=Month(Sec_Payin) from sett_mst 
Where Sett_Type In ('N','W') And Start_Date > GetDate()
Union All 
select sett_no,sett_type,exchange,convert(varchar(10),start_date,103) as start_date,
convert(varchar(10),end_date,103) as end_date,convert(varchar(10),sec_payin,103) as sec_payin,
convert(varchar(10),sec_payout,103) as sec_payout,convert(varchar(10),funds_payin,103) as funds_payin,
convert(varchar(10),funds_payout,103) as funds_payout, 
Year=Year(Sec_Payin),Month=Month(Sec_Payin) from bsedb.dbo.sett_mst 
Where Sett_Type In ('D','C') And Start_Date > GetDate()
Order By Exchange, Start_Date

GO
