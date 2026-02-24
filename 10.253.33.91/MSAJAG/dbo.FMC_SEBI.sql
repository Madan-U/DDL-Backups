-- Object: PROCEDURE dbo.FMC_SEBI
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[FMC_SEBI] (@DATE DATETIME,@RPT VARCHAR(1))

AS 


IF @RPT ='C' 
 BEGIN 
	SELECT * FROM (
	Select 'Total_List' Details , count(Party_code) as clt,'SSCS' PAY_OUT_TYPE from [MIS].SCCS.DBO.SCCS_Clientmaster WITH (NOLOCK) where SCCS_SettDate_Last >=@DATE AND SCCS_SettDate_Last<=@DATE +' 23:59'
	union 
	Select 'Inactive_list' Details , count(Party_code) as clt,'SSCS' PAY_OUT_TYPE from [MIS].SCCS.DBO.SCCS_Clientmaster WITH (NOLOCK) where SCCS_SettDate_Last >=@DATE AND SCCS_SettDate_Last<=@DATE +' 23:59'
	and Exclude <> 'Y' --- 29514
	UNION 
	Select 'Total_List' Details , count(Party_code) as clt,'FMC' from [MIS].FCCS.DBO.SCCS_Clientmaster_commodities where SCCS_SettDate_Last >=@DATE AND SCCS_SettDate_Last<=@DATE +' 23:59'
	UNION 
	Select 'Inactive_list' Details , count(Party_code) as clt,'FMC' from [MIS].FCCS.DBO.SCCS_Clientmaster_commodities where SCCS_SettDate_Last >=@DATE AND SCCS_SettDate_Last<=@DATE +' 23:59'
	and Exclude = 'N'  -- 12767 
	) A ORDER BY  PAY_OUT_TYPE,Details DESC
 END

IF @RPT ='S' 
 BEGIN 
	Select Region,Count(Party_code) as Clt, 
	FudPO = Sum ([Funds Payout]),Sh_PO = sum([Payout Value]),'SEBI_Payout' Payout_Type
	from [MIS].SCCS.DBO.VW_SCCS_PO_Summary WITH (NOLOCK)  
	--where [Funds Payout] <= -500 or [Payout Value] > 25
	Group by Region
	Order by Region
 
 END


--------------------------------------------FMC Report-------------------------------------------------------------------

--use FCCS

IF @RPT ='F' 
 BEGIN 

SELECT REGION,Count(Party_code) as Clt,SUM([fUNDS pAYOUT]) as Fund,'FMC_Payout' Payout_Type
FROM [MIS].FCCS.DBO.VW_FMC_PO_SUMMARY
WHERE Region is not null --- [Funds Payout] < -500 and 
Group by Region
Order by Region

END

GO
