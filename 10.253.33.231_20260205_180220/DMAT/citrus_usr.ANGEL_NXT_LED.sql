-- Object: PROCEDURE citrus_usr.ANGEL_NXT_LED
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

 --ALTER THIS VIEW UNDER SRE-34226
CREATE PROC [citrus_usr].[ANGEL_NXT_LED]     
(@FROM_FIN_YEAR VARCHAR(4),@TO_FIN_YEAR VARCHAR(4),@DP_ID VARCHAR(16) ,@LTYPE VARCHAR(15))    
  
AS  
  
IF (@DP_ID <='1203320099999999'  )  
Begin   
 Exec AGMUBODPL3.DMAT.[citrus_usr].[ANGEL_NXT_LED] @FROM_FIN_YEAR  ,@TO_FIN_YEAR ,@DP_ID  ,@LTYPE     
End   
  
If   (@DP_ID >='1203320099999999'  AND @DP_ID  <='1203320199999999'  )  
 Begin   
 Exec AngelDP5.DMAT.[citrus_usr].[ANGEL_NXT_LED]  @FROM_FIN_YEAR  ,@TO_FIN_YEAR ,@DP_ID  ,@LTYPE    
End   
  
  
If   (@DP_ID >='1203320199999999'  AND @DP_ID  <='1203320299999999' )  
 Begin   
 Exec Angeldp202.DMAT.[citrus_usr].[ANGEL_NXT_LED]  @FROM_FIN_YEAR  ,@TO_FIN_YEAR ,@DP_ID  ,@LTYPE    
 END
If   (@DP_ID >='1203320299999999'    AND @DP_ID  <='1203320399999999' )  
 Begin   
 Exec ABVSDP203.DMAT.[citrus_usr].[ANGEL_NXT_LED]  @FROM_FIN_YEAR  ,@TO_FIN_YEAR ,@DP_ID  ,@LTYPE    
End 

If   (@DP_ID >='1203320399999999'   )  
 Begin   
 Exec ABVSDP204.DMAT.[citrus_usr].[ANGEL_NXT_LED]  @FROM_FIN_YEAR  ,@TO_FIN_YEAR ,@DP_ID  ,@LTYPE    
End

GO
