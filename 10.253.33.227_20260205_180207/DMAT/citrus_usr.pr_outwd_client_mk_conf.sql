-- Object: PROCEDURE citrus_usr.pr_outwd_client_mk_conf
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from dmat_dispatch  
/*  
create table dmat_dispatch_remat  
(DISPR_ID NUMERIC  
,DISPR_REMRM_ID NUMERIC  
,DISPR_TYPE VARCHAR(25)  
,DISPR_TO VARCHAR(25)  
,DISPR_DT DATETIME  
,DISPR_DOC_ID NUMERIC  
,DISPR_NAME VARCHAR(250)  
,DISPR_CONF_RECD CHAR(5))  
*/  
  
CREATE procedure [citrus_usr].[pr_outwd_client_mk_conf](@pa_id varchar(8000),@pa_action varchar(20),@pa_disptype varchar(20))    
as    
begin     
--    
    
DECLARE @outwdclient TABLE (demrm_id          numeric                      
       ,mark_ind          char(2)    
       )    
    
 DECLARE @@rm_id              VARCHAR(8000)                        
          , @@cur_id             VARCHAR(8000)                        
          , @@foundat            INT                        
          , @@delimeterlength    INT                       
          , @@delimeter          CHAR(1)       
          , @l_demrm_id          numeric       
          , @l_mark_ind          char(2)    
          , @l_ind               char(10)   
    
 SET @l_ind = ''  
    IF ISNULL(@pa_id, '') <> ''                      
    BEGIN--n_n                      
    --                      
      SET @@rm_id  =  @pa_id                      
      --                      
      --                      
      WHILE @@rm_id <> ''                        
      BEGIN--w_id                        
      --                        
        SET @@foundat = 0                        
        SET @@foundat =  PATINDEX('%*|~*%',@@rm_id)                        
        --                      
        IF @@foundat > 0                        
        BEGIN                        
        --                        
          SET @@cur_id  = SUBSTRING(@@rm_id, 0,@@foundat)                        
          SET @@rm_id   = SUBSTRING(@@rm_id, @@foundat+4,LEN(@@rm_id)- @@foundat+4)                        
        --                        
        END                        
        ELSE                        
        BEGIN                        
        --                        
          SET @@cur_id      = @@rm_id                        
          SET @@rm_id = ''                        
        --                        
        END                      
        --                      
        IF @@cur_id <> ''                      
        BEGIN                      
        --                      
          SET @l_demrm_id  = CONVERT(NUMERIC, citrus_usr.fn_splitval(@@cur_id,1))                      
          SET @l_mark_ind = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,2))     
          SET @l_ind = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,3))                          
          --                       
          INSERT INTO @outwdclient                        
          SELECT @l_demrm_id , @l_mark_ind             
                            
                            
        --                      
        END                      
      --                        
      END       
  --    
  end      
    
  
  if @pa_action ='demat'  
  begin  
   update d    
   set   DISP_CONF_RECD = mark_ind    
   from  Dmat_Dispatch d    
   ,     @outwdclient    
   where demrm_id = DISP_demrm_id    
   and DISP_TO = case when @l_ind = '' then 'C' else 'R' end    
   and isnull(disp_type,'') = @pa_disptype
  end  
  else if @pa_Action ='remat'  
  begin  
   update d    
   set   DISPR_CONF_RECD = mark_ind    
   from  Dmat_Dispatch_remat d    
   ,     @outwdclient    
   where demrm_id = DISPR_remrm_id    
   and DISPR_TO = case when @l_ind = '' then 'C' else 'R' end    
   and isnull(dispr_type,'') = @pa_disptype
  end   
    
--    
end

GO
