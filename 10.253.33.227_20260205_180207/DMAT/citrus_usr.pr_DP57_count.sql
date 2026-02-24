-- Object: PROCEDURE citrus_usr.pr_DP57_count
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE   PROC [citrus_usr].[pr_DP57_count](@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)          
AS          
BEGIN 
select  CDSHM_CREATED_DT [DP57 IMPORTED ON] , COUNT (1) [COUNT] from cdsl_holding_dtls where CDSHM_TRAS_DT  =  @pa_from_dt-- substring (CONVERT(varchar, getdate(),109 ),1,11)
group by CDSHM_CREATED_DT 
order by 1
end

GO
