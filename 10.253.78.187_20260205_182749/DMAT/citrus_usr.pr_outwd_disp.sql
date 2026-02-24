-- Object: PROCEDURE citrus_usr.pr_outwd_disp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--insert into bitmap_ref_mstr select max(bitrm_id) + 1 , 'dispatch_doc_id' ,'dispatch_doc_id' ,1, '','','HO',getdate(),'ho',getdate(),1 from bitmap_ref_mstr where bitrm_parent_cd = 'dispatch_doc_id'     
--3|*~|70|*~|DHL|*~|15/10/2008|*~|IN000018|*~|5|*~|*|~* EDT DEMAT RF     
--begin tran  
--pr_outwd_disp '3|*~|70|*~|DHL|*~|15/10/2008|*~|IN000018|*~|5|*~|*|~*','INS','DEMAT','RF',''    
--select * from dmat_dispatch   
--select * from bitmap_ref_mstr   
--rollback  
 CREATE procedure [citrus_usr].[pr_outwd_disp]        
(@pa_id varchar(8000)     
,@pa_action  varchar(20)     
,@pa_dem_rem varchar(10)    
,@pa_disp_to  varchar(20)      
,@pa_out varchar(8000) out)        
as        
begin        
--        
 DECLARE @@rm_id                 VARCHAR(8000)                            
          , @@cur_id             VARCHAR(8000)                            
          , @@foundat            INT                            
          , @@delimeterlength    INT                           
          , @@delimeter          CHAR(1)           
          , @l_demrm_id          numeric           
          , @l_disp_dt           varchar(11)          
          , @l_disp_docid        varchar(100)        
          , @l_disp_docname      varchar(250)        
          , @l_id numeric        
           , @l_id1 varchar(25)        
          , @L_ERROR numeric        
          , @T_ERRORSTR varchar(8000)     
    ,@L_RTA_CD VARCHAR(15)    
    , @l_disp_cons_no varchar(25)  
  ,@l_old_isin varchar(50)

  set @l_old_isin= ''  
        
  
  
  if @pa_action = 'INS'    
  begin    
   select @l_disp_docid = ISNULL(max(bitrm_bit_location),0) + 1  from bitmap_ref_mstr where bitrm_parent_cd = 'dispatch_doc_id' and bitrm_deleted_ind= 1    
   update bitmap_ref_mstr set bitrm_bit_location = @l_disp_docid  from bitmap_ref_mstr where bitrm_parent_cd = 'dispatch_doc_id' and bitrm_deleted_ind= 1    
  end     
      
  print @l_disp_docid  
    
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
          SET @l_disp_cons_no  =  citrus_usr.fn_splitval(@@cur_id,2)       
          SET @l_disp_docname = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,3))                              
          SET @l_disp_dt = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,4))     
          SET @L_rta_cd = CONVERT(VARCHAR(25), ltrim(rtrim(citrus_usr.fn_splitval(@@cur_id,5))))               
          SET @l_id1 = CONVERT(VARCHAR(25), ltrim(rtrim(citrus_usr.fn_splitval(@@cur_id,6))))  

                  
if @pa_action <> 'INS' and @pa_dem_rem = 'demat'    
select @l_disp_docid =  DISP_DOC_ID from Dmat_Dispatch where DISP_DEMRM_ID = @l_demrm_id     
if @pa_action <> 'INS' and @pa_dem_rem = 'remat'    
select @l_disp_docid =  DISPR_DOC_ID from Dmat_Dispatch_remat where DISPR_remrm_ID = @l_demrm_id     
          if @pa_dem_rem  ='demat'    
          select @l_id = isnull(max(isnull(DISP_ID,0)),0)+1 from Dmat_Dispatch       
     
          if @pa_dem_rem  ='remat'    
          select @l_id = isnull(max(isnull(DISPR_ID,0)),0)+1 from Dmat_Dispatch_remat    
              


if @l_old_isin <> '' and @pa_action = 'INS'
begin 
  if @l_old_isin <> CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,5))
  begin 
     select @l_disp_docid = ISNULL(max(bitrm_bit_location),0) + 1  from bitmap_ref_mstr where bitrm_parent_cd = 'dispatch_doc_id' and bitrm_deleted_ind= 1  
     update bitmap_ref_mstr set bitrm_bit_location = @l_disp_docid  from bitmap_ref_mstr where bitrm_parent_cd = 'dispatch_doc_id' and bitrm_deleted_ind= 1  

  end 

end 

SET @l_old_isin = CONVERT(VARCHAR(25), citrus_usr.fn_splitval(@@cur_id,5))             

          begin transaction        
  if @pa_action = 'INS'      
  begin      
       print 'ddd'
print @pa_dem_rem
       if  @pa_dem_rem  ='demat'    
 print @l_disp_dt

          insert into Dmat_Dispatch        
      (DISP_ID,DISP_DEMRM_ID,DISP_TYPE,DISP_TO,DISP_DT,DISP_DOC_ID,DISP_NAME, DISP_CONF_RECD,disp_rta_cd,disp_cons_no)        
            values         
            (@l_id,@l_demrm_id,case when @pa_disp_to = 'R' then 'N' when @pa_disp_to = 'RF' then 'F' else null end ,left(@pa_disp_to,1),convert(datetime,@l_disp_dt,103),@l_disp_docid,@l_disp_docname,null,@L_rta_cd,@l_disp_cons_no)        
      if  @pa_dem_rem  ='remat'    
          insert into Dmat_Dispatch_remat        
      (DISPR_ID,DISPR_remrm_ID,DISPR_TYPE,DISPR_TO,DISPR_DT,DISPR_DOC_ID,DISPR_NAME, DISPR_CONF_RECD,dispr_rta_cd,dispr_cons_no)        
            values         
            (@l_id,@l_demrm_id,case when @pa_disp_to = 'R' then 'N' when @pa_disp_to = 'RF' then 'F' else null end ,left(@pa_disp_to,1),convert(datetime,@l_disp_dt,103),@l_disp_docid,@l_disp_docname,null,@L_rta_cd,@l_disp_cons_no)        
    
  end      
  if @pa_action = 'EDT'                       
  begin      
    print @pa_dem_rem
    if  @pa_dem_rem  ='demat'  
print @l_disp_dt
print @l_disp_docid
print @l_disp_docname
print @l_disp_cons_no
print @l_id1
print @l_demrm_id
    update Dmat_Dispatch       
    set  DISP_DT = convert(datetime,@l_disp_dt,103),DISP_DOC_ID=@l_disp_docid,DISP_NAME=@l_disp_docname , disp_cons_no =  @l_disp_cons_no    
    where DISP_ID = @l_id1      
    and   DISP_DEMRM_ID = @l_demrm_id       
    
    if  @pa_dem_rem  ='remat'    
    update Dmat_Dispatch_remat      
    set  DISPR_DT = convert(datetime,@l_disp_dt,103),DISPR_DOC_ID=@l_disp_docid,DISPR_NAME=@l_disp_docname  , dispr_cons_no =  @l_disp_cons_no    
    where DISPR_ID = @l_id1      
    and   DISPR_remrm_ID = @l_demrm_id       
    
  end      
if @pa_action = 'DEL'                       
  begin      
    if  @pa_dem_rem  ='demat'    
    delete from Dmat_Dispatch       
    where DISP_ID = @l_id1    
    and   DISP_DEMRM_ID = @l_demrm_id     
    
    if  @pa_dem_rem  ='remat'    
    delete from Dmat_Dispatch_remat       
    where DISPR_ID = @l_id1     
    and   DISPR_remrm_ID = @l_demrm_id     
   -- and   DISP_DEMRM_ID = @l_demrm_id       
  end      
        
             SET @L_ERROR = @@ERROR          
   --          
   IF @L_ERROR > 0          
   BEGIN          
     --          
     SET @T_ERRORSTR=CONVERT(VARCHAR,@L_ERROR)+'*|~*'        
        
     ROLLBACK TRANSACTION        
     --          
   END          
   ELSE        
   BEGIN        
   --        
              commit transaction        
            --        
            end        
                        
                                
        --                          
        END                          
      --        
     END           
  --        
  end          
          
  set @pa_out = @T_ERRORSTR        
--        
end

GO
