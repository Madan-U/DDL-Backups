-- Object: FUNCTION citrus_usr.fn_get_total_holding
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_total_holding](@pa_dpam_id varchar(16))
returns  numeric(18,2)
as 
begin 

 declare @l_valuation numeric(18,2)
 declare  @PA_FORDATE datetime
 set @PA_FORDATE  = convert(datetime,convert(varchar,getdate(),109)) 

 declare @@TMPHOLDING_DT  datetime

 SELECT TOP 1 @@TMPHOLDING_DT = CASE WHEN DPHMC_HOLDING_DT > @PA_FORDATE THEN @PA_FORDATE ELSE DPHMC_HOLDING_DT END 
 FROM DP_HLDG_MSTR_CDSL WHERE DPHMC_DELETED_IND =1   
  

 SELECT @l_valuation=sum(CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0)))
 FROM DP_DAILY_HLDG_CDSL               
 LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD              
 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @@TMPHOLDING_DT and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                     
 WHERE DPHMCD_HOLDING_DT = @@TMPHOLDING_DT               
 AND DPHMCD_DPAM_ID = @pa_dpam_id
 AND ISNULL(DPHMCD_CURR_QTY,0) <> 0              
 group BY DPHMCD_DPAM_ID ,ISIN_NAME,DPHMCD_ISIN    

return @l_valuation  

end

GO
