-- Object: FUNCTION citrus_usr.FN_GETSUBTRANSDTLS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_GETSUBTRANSDTLS] (@pa_transtype_cd varchar(100))    
RETURNS  TABLE     
AS    
    
     
 RETURN (SELECT  TRASTM_CD AS CD
,TRASTM_DESC AS DESCP 
--,  TRASTM_ID  
  FROM  TRANSACTION_TYPE_MSTR,    
        TRANSACTION_SUB_TYPE_MSTR    
  WHERE TRANTM_CODE =  @pa_transtype_cd    
  AND TRANTM_ID   =  TRASTM_TRATM_ID 
    
  )

GO
