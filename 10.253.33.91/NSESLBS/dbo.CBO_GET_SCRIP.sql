-- Object: PROCEDURE dbo.CBO_GET_SCRIP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE    PROCEDURE [dbo].[CBO_GET_SCRIP]
(
	@scrip_cd VARCHAR(25) = '',
        @series VARCHAR(25)=''
	
)
AS
/*
	CBO_GET_SCRIP '', ''
*/
	Select
		S1.[Co_Code], S1.[Series], S1.[Short_Name], S1.[Long_Name], S1.[Market_Lot], S1.[Face_Val], CONVERT(VARCHAR(10), S1.[Book_Cl_Dt], 103)Book_Cl_Dt, S1.[Ex_Div_Dt], S1.[Ex_Bon_Dt], S1.[Ex_Rit_Dt], S1.[Eqt_Type], S1.[Sub_Type], S1.[Agent_Cd], S1.[Demat_Flag], S1.[Demat_Date], S1.[Res1], S1.[Res2], S1.[Res3], S1.[Res4],
		S2.[Co_Code], S2.[Series], S2.[Exchange], S2.[Scrip_Cd], S2.[Scrip_Cat], S2.[No_Del_Fr], S2.[No_Del_To], S2.[Cl_Rate], S2.[Clos_Rate_Dt], S2.[Min_Trd_Qty], S2.[Bsecode], S2.[Isin], S2.[Delsc_Cat], S2.[Sector], S2.[Track], S2.[Cdol_No], S2.[Res1], S2.[Res2], S2.[Res3], S2.[Res4], S2.[Globalcustodian], S2.[common_code], S2.[IndexName], S2.[Industry], S2.[Bloomberg], S2.[RicCode], S2.[Reuters], S2.[IES], S2.[NoofIssuedshares], S2.[Status], S2.[ADRGDRRatio], S2.[GEMultiple], S2.[GroupforGE], S2.[RBICeilingIndicatorFlag], S2.[RBICeilingIndicatorValue]
	From
		Scrip1 S1,
		Scrip2 S2
	Where
		S1.Co_Code = S2.Co_Code
		And S2.Scrip_Cd = (Case When Len(@scrip_cd) > 0 And @scrip_cd <> '%' Then @scrip_cd Else S2.Scrip_Cd End)
		And S2.Series = (Case When Len(@series) > 0 And @series <> '%' Then @series Else S2.series End)

/*			declare @co_code varchar(10)
  
			SELECT
				@co_code=co_code
			FROM
				scrip2
			
			where
				series=@series and scrip_cd=@scrip_cd




			select * from scrip1 a,scrip2 b where a.co_code=@co_code and b.co_code=@co_code
			

*/			--select * from scrip2 where co_code=@co_code

GO
