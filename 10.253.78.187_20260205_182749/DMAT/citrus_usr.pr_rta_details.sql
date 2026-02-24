-- Object: PROCEDURE citrus_usr.pr_rta_details
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_rta_details]( @pa_exch          VARCHAR(20)      
          ,@pa_login_name    VARCHAR(20)      
          ,@pa_mode          VARCHAR(10)                                      
          ,@pa_db_source     VARCHAR(250)      
          ,@rowdelimiter     CHAR(4) =     '*|~*'        
          ,@coldelimiter     CHAR(4) =     '|*~|'        
          ,@pa_errmsg        VARCHAR(8000) output      
          )        
AS      
/*      
*********************************************************************************      
 SYSTEM         : Dp      
 MODULE NAME    : [pr_rta_details]      
 DESCRIPTION    : This Procedure Will Contain The Update Queries For Master Tables      
 COPYRIGHT(C)   : Marketplace Technologies       
 VERSION HISTORY: 1.0      
 VERS.  AUTHOR            DATE          REASON      
 -----  -------------     ------------  --------------------------------------------------      
 1.0    TUSHAR            08-OCT-2007   VERSION.      
-----------------------------------------------------------------------------------*/      
BEGIN      
--    
    
    
   
--  DECLARE @c_entm_adr     CURSOR      
--  DECLARE @c_entm_conc    CURSOR      
--  DECLARE @c_entm_ENTP    CURSOR      
--  DECLARE @c_dp_adr     CURSOR      
--  DECLARE @c_dp_conc    CURSOR      
--  DECLARE @c_access_cursor CURSOR    
--      
--  
--        
--  SET    @c_entm_adr =  CURSOR fast_forward FOR        
--  SELECT distinct 
--  from   ISSUER_RTA_MSTR       
--  WHERE  entm_short_name = ISSRTA_BPID   and  ENTM_ENTTM_CD = 'SR'
--        
--  OPEN @c_entm_adr        
--  FETCH NEXT FROM @c_entm_adr INTO @l_id   
--        
--  WHILE @@fetch_status = 0        
--  BEGIN        
--  --        
--        
--    select @l_adr1 =ISSRTA_ADD1 , @l_adr2  = ISSRTA_ADD2,  @l_city = ISSRTA_ADD3,@l_state = ISSRTA_CITYPIN, @l_zip       =ISSRTA_STATE   FROM   entity_mstr      
--       , ISSUER_RTA_MSTR       
--    WHERE  entm_short_name = ISSRTA_BPID  and entm_id = @l_id  
--        and  isnull(ISSRTA_ADD1,'')<>''
--
--    SET @l_values = 'OFF_ADR1' + '|*~|' + ISNULL(@l_adr1,'') + '|*~|' + ISNULL(@l_adr2,'') + '|*~|' + ISNULL(@l_city,'') + '|*~|' + ISNULL(@l_state,'') + '|*~|' + ISNULL(@l_zip,'') + '|*~|' + isnull('','') + '|*~|' + isnull('','') + '|*~|*|~*'     
--   print @l_values
--    EXEC pr_ins_upd_addr @l_id, 'edt', 'MIG', @l_id,'', @l_values, 0 ,'*|~*','|*~|',''        
--          
--      FETCH NEXT FROM @c_entm_adr INTO @l_id   
--  --        
--  END        
--       
--      
--  CLOSE      @c_entm_adr        
--  DEALLOCATE @c_entm_adr        
--        
--        
--  SET    @c_entm_conc =  CURSOR fast_forward FOR        
--  SELECT distinct entm_id      
--  FROM   entity_mstr      
--       , ISSUER_RTA_MSTR       
--  WHERE  entm_short_name = ISSRTA_BPID    
--        
--      
--  OPEN @c_entm_conc        
--  FETCH NEXT FROM @c_entm_conc INTO @l_id  
--      
--  WHILE @@fetch_status = 0        
--  BEGIN        
--  --    
--    select @l_ph1 = ISSRTA_TELE, @l_fax =ISSRTA_FAX,@l_email = ISSRTA_EMAIL  FROM   entity_mstr      
--       , ISSUER_RTA_MSTR       
--    WHERE  entm_short_name = ISSRTA_BPID  and entm_id = @l_id  
--            
--    --SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') + '|*~|*|~*OFF_PH2|*~|' + ISNULL(@l_ph2,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') +  '|*~|*|~*EMAIL|*~|'   + ISNULL(@l_email,'') + '|*~|*|~*'      
--    SET @l_values = 'OFF_PH1|*~|' +  ISNULL(@l_ph1,'') ++'|*~|*|~*email1|*~|' +  ISNULL(@l_email,'') +  '|*~|*|~*FAX|*~|'  + ISNULL(@l_fax,'') + '|*~|*|~*'      
--    print @l_values
--    print @l_id
--    EXEC pr_ins_upd_conc @l_id, 'edt', 'MIG', @l_id, '', @l_values, 0 ,'*|~*','|*~|',''        
--      
--    FETCH NEXT FROM @c_entm_conc INTO @l_id   
--  --        
--  END        
--          
--       
--  CLOSE      @c_entm_conc        
--  DEALLOCATE @c_entm_conc       
--  
--  
--  SET    @c_entm_entp =  CURSOR fast_forward FOR        
--  SELECT distinct entm_id      
--       
--  FROM   entity_mstr      
--       , ISSUER_RTA_MSTR       
--  WHERE  entm_short_name = ISSRTA_BPID    
--        
--      
--  OPEN @c_entm_entp       
--  FETCH NEXT FROM @c_entm_entp INTO @l_id1  
--      
--  WHILE @@fetch_status = 0        
--  BEGIN        
--  --    
--           
--    SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|'   
--                                  + ISNULL(ISSRTA_CP,'') + '|*~|*|~*'   
--    FROM ISSUER_RTA_MSTR, ENTITY_PROPERTY_MSTR, ENTITY_MSTR   WHERE entm_short_name = ISSRTA_BPID  and entm_id = @l_id1 AND  entpm_CD   = 'CONTACT_PERSON'  
--    AND ISNULL(ISSRTA_CP,'') <> ''  
--
--    print @L_ENTP_VALUE
--
--    EXEC pr_ins_upd_entp '1','EDT','MIG',@l_id1,'',@L_ENTP_VALUE,'',0,'*|~*','|*~|',''    
--      
--    FETCH NEXT FROM @c_entm_entp INTO @l_id1   
--  --        
--  END        
--          
--       
--  CLOSE      @c_entm_entp       
--  DEALLOCATE @c_entm_entp      
--      
      
update isin_mstr 
set    isin_adr1 = ISSRTA_ADD1
		,isin_adr2 = ISSRTA_ADD2
		,isin_adr3 = ISSRTA_ADD3
		,isin_adrcity = ISSRTA_CITYPIN
		,isin_adrstate = ISSRTA_STATE
		,isin_adrcountry = ''
		,isin_adrzip     = ''
		,isin_contactperson = ISSRTA_CP
		,isin_email = ISSRTA_EMAIL
		,isin_TELE  = ISSRTA_TELE
		,isin_FAX   = ISSRTA_FAX
from isin_mstr , ISSUER_RTA_MSTR
where isin_cd = ISSRTA_ISIN
        
   
      
    
--      
END

GO
