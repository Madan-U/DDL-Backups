-- Object: PROCEDURE citrus_usr.pr_poa_nsdl_new
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_poa_nsdl_new]( @pa_crn_no      VARCHAR(8000)                  
                            , @pa_exch        VARCHAR(10)                  
                            , @pa_from_dt     VARCHAR(11)                  
                            , @pa_to_dt       VARCHAR(11)                  
                            , @pa_tab         CHAR(3)                  
                            , @PA_BATCH_NO    VARCHAR(25)  
                            , @PA_EXCSM_ID     NUMERIC   
                            , @PA_LOGINNAME    VARCHAR(25)  
                            , @pa_ref_cur     VARCHAR(8000) OUTPUT                  
                             )                  
AS                  
begin
--
  select DISTINCT dp_string  = '' , ISNULL(citrus_usr.fn_ucc_doc(dpam_id,'SIGN_BO','NSDL'),'')  docpath
 , case when isnull(dppd.dppd_fname,'') <> '' AND DPPD_HLD = '1ST HOLDER' then '11'  end   fhd_sign
 , case when  isnull(dppd.dppd_fname,'') <> '' AND DPPD_HLD = '2ND HOLDER' then '12' end     shd_sign
 , case when isnull(dppd.dppd_fname,'') <> '' AND DPPD_HLD = '3RD HOLDER' then '13'  end      thd_sign
 ,dpam_sba_no sba_no                                          
  from client_mstr clim , dp_acct_mstr
  left outer join
  dp_poa_dtls dppd on  dpam_id = dppd_dpam_id and dppd_deleted_ind=1
  where clim_crn_no = dpam_crn_no  
  and  dpam_batch_no = @PA_BATCH_NO
  order by sba_no                                          
--
end

GO
