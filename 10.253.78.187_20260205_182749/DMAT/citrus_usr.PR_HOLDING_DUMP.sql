-- Object: PROCEDURE citrus_usr.PR_HOLDING_DUMP
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



----PROCESS CREATED UNDER SRE-38346
CREATE PROCEDURE [citrus_usr].[PR_HOLDING_DUMP] 
	
--(@pa_id varchar(1))
AS
BEGIN
	
declare @holddate datetime  
set @holddate= ( select TOP 1 HLD_HOLD_DATE FROM HOLDINGDATA WITH(NOLOCK))   


Delete from synergy_holding where HLD_HOLD_DATE  =@holddate
	    
	INSERT INTO synergy_holding  (HLD_HOLD_DATE
		,HLD_AC_CODE
		,HLD_CAT
		,HLD_ISIN_CODE
		,HLD_AC_TYPE
		,HLD_AC_POS
		,HLD_CCID
		,HLD_MARKET_TYPE
		,HLD_SETTLEMENT
		,HLD_BLF
		,HLD_BLC
		,HLD_LRD
		,HLD_PENDINGDT)   
	SELECT 
		HLD_HOLD_DATE
		,HLD_AC_CODE
		,HLD_CAT
		,HLD_ISIN_CODE
		,HLD_AC_TYPE
		,HLD_AC_POS
		,HLD_CCID
		,HLD_MARKET_TYPE
		,HLD_SETTLEMENT
		,HLD_BLF
		,HLD_BLC
		,HLD_LRD
		,HLD_PENDINGDT FROM HOLDINGDATA    --5639639 --5651832

END

GO
