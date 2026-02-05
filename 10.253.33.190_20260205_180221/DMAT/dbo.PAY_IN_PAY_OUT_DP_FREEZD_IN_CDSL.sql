-- Object: PROCEDURE dbo.PAY_IN_PAY_OUT_DP_FREEZD_IN_CDSL
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [dbo].[PAY_IN_PAY_OUT_DP_FREEZD_IN_CDSL]
AS

  Select distinct Party_code into #check from ANGELDEMAT.[MSAJAG].[dbo].deliveryclt d,ANGELDEMAT.[MSAJAG].[dbo].sett_mst s
where d.sett_no=s.sett_no  and d.sett_type =s.sett_type
and start_date=convert(varchar(11),getdate(),120) ;

insert into PAY_IN_PAY_OUT_DP_FREEZD_IN_CDSL_Report 
 select fre.*, cd.Freezed_ID as Freezed_ID_CDSL,cd.Remarks as FreezeRmks_CDSL,  Create_Date=GETDATE()   from [10.253.65.29].[UCC_Data].[dbo].freezed_all fre 
 left outer join  [10.253.65.29].[UCC_Data].[dbo].CDSL_Freezed cd on fre.boid = cd.dp_id where fre.nise_party_code in ( Select  Party_code from #check) 
 
 select * from PAY_IN_PAY_OUT_DP_FREEZD_IN_CDSL_Report where CONVERT(DATE, Create_Date) = CONVERT(DATE, GETDATE());

GO
