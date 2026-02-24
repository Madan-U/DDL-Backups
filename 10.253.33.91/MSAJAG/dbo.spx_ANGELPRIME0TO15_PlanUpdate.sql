-- Object: PROCEDURE dbo.spx_ANGELPRIME0TO15_PlanUpdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 -- =============================================
-- Author:		Shravan
-- Create date: 13/01/2020
-- Description:	To Get Angel Prime Eligible Clients
/*
 Declare @Msg varchar(50)
 Exec spx_ANGELPRIME0TO15_PlanUpdate @ClientCode='J8060',@CampaignType='ZERO2TEN',@Msg=@Msg out
 select @Msg
 */
-- =============================================
CREATE procedure [dbo].[spx_ANGELPRIME0TO15_PlanUpdate]
@ClientCode varchar(20)='',
@CampaignType varchar(50) ,
@Msg varchar(50) output
as 
BEGIN
 
SELECT  @ClientCode AS PARTY_CODE, @CampaignType AS  TABLE_NAME INTO #CLT 

 
Declare @SchemeTRD varchar(50)='' , @SchemeDEL varchar(50)=''
DECLARE @COUNT INT ,@COUNT1 INT ,@COUNT2 INT , @COUNT3 INT , @COUNT4 INT, @COUNT5 INT
  
SELECT @SchemeTRD= case when @CampaignType='ZERO2TEN' then 'ANGEL_PRIME_TEN_SCHEME' 
when @CampaignType='ZERO2FIVE' then  'ANGEL_PRIME_FIVE_SCHEME'  
when @CampaignType='ZERO2ZERO' then  'ANGEL_PRIME_ZERO_SCHEME'  
when @CampaignType='ZERO2FIFTEEN' then  'ANGEL_PRIME_FIFTEEN_SCHEME' end 

SELECT  CL_CODE,EXCHANGE, SEGMENT INTO #CLIENT_BROK_DETAILS  
from CLIENT_BROK_DETAILS with(nolock)
WHERE CL_CODE = @ClientCode
AND InActive_From > GETDATE()

SELECT @COUNT= COUNT(1) FROM #CLIENT_BROK_DETAILS
IF  @COUNT > 0 
	BEGIN

	--If scheme already added and active then no change
	IF NOT EXISTS( SELECT SP_Scheme_Id FROM  SCHEME_MAPPING WITH(NOLOCK)  WHERE SP_Party_Code = @ClientCode AND SP_DATE_TO >= GETDATE() AND 
				SP_Scheme_Id IN (75,77,79,81))
		BEGIN

		UPDATE SCHEME_MAPPING SET SP_DATE_TO = GETDATE()-1,SP_ModifiedBy = 'ANGELPRIME0TO15' ,SP_ModifiedOn = GETDATE()
		 WHERE SP_Party_Code = @ClientCode AND SP_DATE_TO >= GETDATE()

		INSERT INTO SCHEME_MAPPING
		 SELECT DISTINCT * FROM (
		SELECT  PARTY_CODE,'O' A , '' B ,'ALL' V,CAST(SCHEME_ID AS NUMERIC) E,SM_Trd_Type, 0 SR,SM_Multiplier,SM_Buy_Brok_Type,SM_Sell_Brok_Type,
		SM_Buy_Brok,SM_Sell_Brok,SM_Res_Multiplier='0.0000',SM_Res_Buy_Brok,SM_Res_Sell_Brok,
		SM_Value_From,SM_Value_To,SM_TurnOverOn,SM_ComputationOn,SM_ComputationType,	MIN_BROK	,MAX_BROK,'0.0000' S,'-1.0000' T,
		convert(varchar(11),GETDATE(),120) ERE,'2049-12-31 23:59:00.000' U,'ANGELPRIME0TO15' VX,GETDATE() RE,'' Z,GETDATE() R FROM 
		(
		SELECT  SCHEME_NAME,DEL_SCHEME_ID SCHEME_ID,DEL_FROM_TURNOVER AS FROM_TURNOVER,	DEL_TO_TURNOVER AS TO_TURNOVER	,DEL_MIN_BROK as MIN_BROK,MAX_BROK= 0.000000000
		FROM MAPPING_TABLE WHERE EXCHANGE ='NSE' AND SEGMENT ='CAPITAL' AND GETDATE()  BETWEEN FROM_DATE AND TO_DATE  
		and DEL_SCHEME_ID <> ''
		UNION ALL

		SELECT  SCHEME_NAME,TRD_SCHEME_ID,FROM_TURNOVER,TO_TURNOVER	,MIN_BROK,	MAX_BROK 
		FROM MAPPING_TABLE WHERE EXCHANGE ='NSE' AND SEGMENT ='CAPITAL' AND GETDATE()  BETWEEN FROM_DATE AND TO_DATE  
		and TRD_SCHEME_ID <> ''
		) A ,
		Scheme_Master S ,#CLT V
		WHERE SM_Scheme_Id = SCHEME_ID  AND RTRIM(LTRIM(@SchemeTRD)) = RTRIM(LTRIM(SCHEME_NAME))
		AND SM_Value_From = FROM_TURNOVER AND  SM_Value_To = TO_TURNOVER
 
		) A WHERE  NOT EXISTS (SELECT SP_PARTY_CODE FROM Scheme_Mapping S WHERE S.SP_PARTY_CODE= PARTY_CODE AND S.SP_CreatedBy = 'ANGELPRIME0TO15' 
		AND S.SP_Date_To >=GETDATE())


		
		UPDATE R SET CR_Date_To = CR_Date_FROM-1 + ' 23:59:59.000'
		FROM  CONTRACT_ROUNDING R, #CLT C WHERE CR_Party_Code =C.Party_Code  AND CR_Date_To >= GETDATE()


		UPDATE R SET TODATE = CONVERT(VARCHAR(11),GETDATE()-1,120)  + ' 23:59:59.000'
		FROM  TBL_ADDITIONAL_BROEKRAGE R, #CLT C WHERE R.Party_Code =C.Party_Code  AND TODATE >= GETDATE()
		 
			set @msg ='success'
		END
	ELSE
		set @msg ='scheme already exists'
		RETURN
	END
		drop table #CLIENT_BROK_DETAILS
		drop table #CLT
END

GO
