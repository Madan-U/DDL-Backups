-- Object: PROCEDURE citrus_usr.DP_ACCT_MSTR_S
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec DP_ACCT_MSTR_S '00000066'  
  
CREATE  PROCEDURE [citrus_usr].[DP_ACCT_MSTR_S]    
(     
@PA_FROM_ACCTNO VARCHAR(8)    
  
)    
AS   
  
  
  
  
 BEGIN                          
    --                          
    SELECT * FROM DP_ACCT_MSTR WHERE DPAM_STAM_CD = 'ACTIVE' AND DPAM_DELETED_IND = '1'  
    AND right(DPAM_SBA_NO,8) =  @PA_FROM_ACCTNO     
      
    select * from client_list_modified where  right(clic_mod_dpam_sba_no,8)  =     @PA_FROM_ACCTNO             
    --                          
    END

GO
