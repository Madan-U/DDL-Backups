-- Object: PROCEDURE citrus_usr.LATESH_pr_auto_nrn_nrnauto
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin tran
 --exec [LATESH_pr_auto_nrn_nrnauto] '' ,'CDSL','jan 01 1900','jan 31 2100','','',0,'',''  
 -- rollback
 --update dp_holder_dtls set nom_nrn_no=0 where DPHD_CREATED_DT>='2015-07-10 06:22:43.267'
 --select * from dp_holder_dtls where DPHD_CREATED_DT>='2015-07-10 06:22:43.267'
CREATE PROCeDURE [citrus_usr].[LATESH_pr_auto_nrn_nrnauto]( @pa_crn_no      VARCHAR(8000)                    
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
          SELECT clim_crn_no,DPAM_SBA_NO, clim_stam_cd, clim_created_dt  
          , clim_lst_upd_dt                    
          FROM   client_mstr WITH (NOLOCK)         ,dp_acct_mstr WITH (NOLOCK)                   
          WHERE  clim_crn_no = CONVERT(numeric, citrus_usr.fn_splitval_by(@l_string,1,'|*~|'))     
          and CLIM_LST_UPD_DT between CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'                           
            and DPAM_CRN_NO = CLIM_CRN_NO and dpam_batch_no is null   
         --                    
    
   set @l_counter = @l_counter +  1   
     
  end   
  
 end   
 else   
 begin  
   
   INSERT INTO @crn                     
          SELECT clim_crn_no,DPAM_SBA_NO , clim_stam_cd, clim_created_dt  
          , clim_lst_upd_dt                    
          FROM   client_mstr WITH (NOLOCK)                  ,dp_acct_mstr  WITH (NOLOCK)   
          WHERE  DPAM_CRN_NO = CLIM_CRN_NO 
          AND EXISTS (select * from dp_holder_dtls where DPHD_CREATED_DT>='2015-07-10 06:22:43.267' AND DPHD_DPAM_ID = DPAM_ID ) 
             
 end   
 /*AUTO NRN*/  
 declare @l_nrn numeric  
 set @l_nrn  = 1   
 select @l_nrn   = 603872--MAX(BITRM_BIT_LOCATION) from BITMAP_REF_MSTR where BITRM_PARENT_CD ='NRN_AUTO'  
   
 select IDENTITY(numeric,1,1) id , * into #autonrn from @crn   
 where exists (select 1 from DP_HOLDER_DTLS where DPHD_DPAM_SBA_NO = acct_no and isnull(NOM_NRN_NO ,'')  in( ''  ,'0') and isnull(DPHD_NOM_FNAME ,'')<>'')   
   
 select @l_nrn + ID newnrn , acct_no into #finalnrn from #autonrn    
   
   
 update DPHD  
 set nom_nrn_no = newnrn  
 from DP_HOLDER_DTLS dphd , #finalnrn where (DPHD_DPAM_SBA_NO = acct_no    OR  DPHD_DPAM_SBA_NO = acct_no   )
 and isnull(NOM_NRN_NO ,'') in( ''  ,'0')
   
   
 --declare @l_max_nrn numeric  
 --select @l_max_nrn = isnull(max(newnrn),0)+1 from #finalnrn   
 --update BITMAP_REF_MSTR set BITRM_BIT_LOCATION = @l_max_nrn  where BITRM_PARENT_CD = 'NRN_AUTO'  
   
end

GO
