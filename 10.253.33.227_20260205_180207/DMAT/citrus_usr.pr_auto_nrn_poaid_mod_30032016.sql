-- Object: PROCEDURE citrus_usr.pr_auto_nrn_poaid_mod_30032016
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

 --exec [pr_auto_nrn_poaid] ''175994|*~|448510|*~|*|~*176000|*~| 449293|*~|*|~*176004|*~| 449929|*~|*|~*176007|*~| 450216|*~|*|~*' ,'CDSL','jan 01 1900','jan 31 2100','','',0,'',''    
 create PROCeDURE [citrus_usr].[pr_auto_nrn_poaid_mod_30032016]( @pa_crn_no      VARCHAR(8000)                      
                            , @pa_exch        VARCHAR(10)                      
                            , @pa_from_dt     VARCHAR(50)                      
                            , @pa_to_dt       VARCHAR(50)                      
                            , @pa_tab         CHAR(3)                      
                            , @PA_BATCH_NO    VARCHAR(25)      
                            , @PA_EXCSM_ID     NUMERIC       
                            , @PA_LOGINNAME    VARCHAR(25)      
                            , @pa_ref_cur     VARCHAR(8000) OUTPUT                      
                             )                      
AS                      
begin    
    
DECLARE @crn TABLE (crn          numeric                      
                     ,acct_no      varchar(25)                      
                     ,clim_stam_cd varchar(25)                      
                     ,fm_dt        datetime                      
                     ,to_dt        datetime                      
                     )     
                     declare @l_string varchar(100)            
    
 if @pa_crn_no <> ''    
 begin    
    
    
  declare @l_counter numeric,@l_count numeric     
  set @l_counter = 1    
  select @l_count = citrus_usr.ufn_CountString(@pa_crn_no,'*|~*')    
    
  while @l_counter < = @l_count    
  begin     
  PRINT 'YYY'    
  PRINT CONVERT(DATETIME,@pa_from_dt ,103) PRINT CONVERT(DATETIME,@pa_to_dt,103)                    
    select @l_string = citrus_usr.FN_SPLITVAL_BY(@pa_crn_no,@l_counter,'*|~*')    
    print  citrus_usr.fn_splitval_by(@l_string,1,'|*~|')    
    INSERT INTO @crn                       
          SELECT clim_crn_no,citrus_usr.fn_splitval_by(@l_string,2,'|*~|'), clim_stam_cd, clim_created_dt    
          , clim_lst_upd_dt                      
          FROM   client_mstr WITH (NOLOCK)         ,dp_acct_mstr WITH (NOLOCK)  ,client_list_modified   WITH (NOLOCK)                     
          WHERE  clim_crn_no = CONVERT(numeric, citrus_usr.fn_splitval_by(@l_string,1,'|*~|'))       
          and clic_mod_lst_upd_dt between CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                             
            and DPAM_CRN_NO = CLIM_CRN_NO 
           and clic_mod_action in ('N NAMENDTLS')    and clic_mod_dpam_sba_no = DPAM_SBA_NO and isnull(clic_mod_batch_no  ,'0')='0'   
         --                      
      
   set @l_counter = @l_counter +  1     
       
  end     
    
 end     
 else     
 begin    
     
   INSERT INTO @crn                       
          SELECT clim_crn_no,DPAM_ACCT_NO , clim_stam_cd, clim_created_dt    
          , clim_lst_upd_dt                      
          FROM   client_mstr WITH (NOLOCK)                  ,dp_acct_mstr  WITH (NOLOCK)  ,client_list_modified   WITH (NOLOCK) 
          WHERE  clic_mod_lst_upd_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                             
          and DPAM_CRN_NO = CLIM_CRN_NO 
         and  clic_mod_dpam_sba_no = DPAM_SBA_NO and isnull(clic_mod_batch_no  ,'0')='0' and clic_mod_action in ('N NAMENDTLS')
               
 end     
 /*AUTO NRN*/    
 
 
 declare @l_nrn numeric    
 set @l_nrn  = 1     
 select @l_nrn   = MAX(BITRM_BIT_LOCATION) from BITMAP_REF_MSTR where BITRM_PARENT_CD ='NRN_AUTO'    
     
 select IDENTITY(numeric,1,1) id , * into #autonrn from @crn     
 where exists (select 1 from DP_HOLDER_DTLS where DPHD_DPAM_SBA_NO = acct_no and isnull(NOM_NRN_NO ,'')  in( ''  ,'0') and isnull(DPHD_NOM_FNAME ,'')<>'')     
     
 select @l_nrn + ID newnrn , acct_no into #finalnrn from #autonrn      
     
     
 update DPHD    
 set nom_nrn_no = newnrn    
 from DP_HOLDER_DTLS dphd , #finalnrn where DPHD_DPAM_SBA_NO = acct_no     
 and isnull(NOM_NRN_NO ,'') in( ''  ,'0')  
     
     
 declare @l_max_nrn numeric    
 set @l_max_nrn =1  
 if exists (select 1 from #finalnrn    )   
begin   
 select @l_max_nrn = isnull(max(newnrn),0)+1 from #finalnrn     
   
 update BITMAP_REF_MSTR set BITRM_BIT_LOCATION = @l_max_nrn  where BITRM_PARENT_CD = 'NRN_AUTO'    
end   
 /*AUTO NRN*/    
     
 /*AUTO POAID*/    
 declare @l_poaid numeric    
 set @l_poaid  = 1     
 select @l_poaid   = MAX(BITRM_BIT_LOCATION) from BITMAP_REF_MSTR where BITRM_PARENT_CD ='POAID_AUTO'    
     
 select IDENTITY(numeric,1,1) id , DPAM_ID , DPPD_ID  into #autopoa from @crn ,DP_POA_DTLS ,dp_acct_mstr     
 where DPPD_DPAM_ID = DPAM_ID and DPAM_ACCT_NO = acct_no     
 and isnull(dppd_poa_id ,'') in( ''  ,'0')   
     
 select @l_poaid + ID newpoa  , DPAM_ID , DPPD_ID into #finalpoa from #autopoa      
     
     
 update dppd    
 set dppd_poa_id  = newpoa    
 from dp_poa_dtls  dppd, #finalpoa temppoa where DPPD_DPAM_ID  = dpam_id and dppd.DPPD_ID = temppoa.dppd_id     
 and isnull(dppd_poa_id ,'') in( ''  ,'0')  
     
     
 declare @l_max_poa numeric    
 set @l_max_poa= 1  
 if exists (select 1 from #finalpoa)  
 begin   
 select @l_max_poa = isnull(max(newpoa),0)+1 from #finalpoa     
 update BITMAP_REF_MSTR set BITRM_BIT_LOCATION =  @l_max_poa  where BITRM_PARENT_CD = 'POAID_AUTO'    
end   
 /*AUTO POAID*/    
     
    
end

GO
