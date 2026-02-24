-- Object: PROCEDURE dbo.Usp_CMBill_BSE_NSE_Daywise_data
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
	CREATE proc [dbo].[Usp_CMBill_BSE_NSE_Daywise_data]
AS
BEGIN
    
	select *  into #rcs from INTRANET.[Risk].dbo.Tbl_BSE_NSE_Scrip_Master

	select Party_code, ISIN,sauda_date,PQTYDEL ,PAMTDEL,'NSE' as segment,SQTYDEL,SAMTDEL into #NSE  
	from CMBillValan with (nolock)
	where ISIN in (select ISIN from #rcs) and convert(date,SAUDA_DATE) = convert(date,getdate()-1)
		
	select  Party_code, ISIN,sauda_date,PQTYDEL ,PAMTDEL,'BSE' as segment,SQTYDEL,SAMTDEL into #BSE
	from angelbsecm.bsedb_ab.dbo.CMBillValan with (nolock)
	where ISIN in (select ISIN from #rcs) and convert(date,SAUDA_DATE) = convert(date,getdate()-1)



	select Party_code, ISIN,sauda_date,PQTYDEL ,PAMTDEL,segment,SQTYDEL,SAMTDEL into #temp
	from
	(
		select * from #NSE
		union all
		Select * from #BSE
	)A

	insert into INTRANET.[Risk].dbo.Tbl_CMBill_BSE_NSE
	select Party_code, ISIN,sauda_date,PQTYDEL ,PAMTDEL,segment,SQTYDEL,SAMTDEL from #temp order by segment

	

END

GO
