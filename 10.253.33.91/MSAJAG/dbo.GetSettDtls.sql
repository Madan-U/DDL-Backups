-- Object: PROCEDURE dbo.GetSettDtls
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetSettDtls    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.GetSettDtls    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.GetSettDtls    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.GetSettDtls    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.GetSettDtls    Script Date: 12/27/00 8:58:51 PM ******/

create proc GetSettDtls as
select distinct settlement.sett_no from settlement , SETT_MST  where billno <> '0'  
and settlement.Sett_no = sett_mst.sett_no and sett_mst.sec_payin < getdate()
order by settlement.sett_no

GO
