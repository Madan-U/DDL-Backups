-- Object: PROCEDURE citrus_usr.dp_poa_dtls_s
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

  
  
--exec dp_poa_dtls_s '00000070'  
  
create    PROCEDURE [citrus_usr].[dp_poa_dtls_s]    
(     
@PA_FROM_ACCTNO VARCHAR(8)    
  
)    
AS   
  
  
  begin 
    select * from dp_poa_dtls  where    DPPD_DPAM_ID  in (                
    SELECT DPAM_ID  FROM DP_ACCT_MSTR WHERE DPAM_STAM_CD = 'ACTIVE' AND DPAM_DELETED_IND = '1'  
    AND right(DPAM_SBA_NO,8) =  @PA_FROM_ACCTNO   )  
    and DPPD_DELETED_IND = '1'
      
    end

GO
