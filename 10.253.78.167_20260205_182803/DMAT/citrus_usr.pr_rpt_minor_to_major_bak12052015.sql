-- Object: PROCEDURE citrus_usr.pr_rpt_minor_to_major_bak12052015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_rpt_minor_to_major 4,'02/03/2008','31/03/2008',1,'JMF HO_HO|*~|',''   
	                   -- 4	02/03/2008	31/03/2008	1	JMF HO_HO|*~|	

  --pr_rpt_minor_to_major 4,' jan 2009','20 nov 2009',1,'JMF HO_HO|*~|',''   
  
--       
  
  
      
/*CREATE PROCEDURE [citrus_usr].[pr_rpt_minor_to_major]                  
(                  
   @pa_excsmid  int                      
  ,@pa_frmdt varchar(11)                      
  ,@pa_todt varchar(11)                      
  ,@pa_login_pr_entm_id numeric                      
  ,@pa_login_entm_cd_chain  varchar(8000)                      
  ,@pa_output varchar(8000) output                      
)                  
AS                  
BEGIN                  
--                  
   DECLARE @l_dpm_id  int                  
          ,@@l_child_entm_id numeric                
                
   SELECT @@l_child_entm_id = citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                
                     
   SELECT @l_dpm_id = dpm_id  FROM dp_mstr WHERE dpm_excsm_id = @pa_excsmid                    
                
   SELECT distinct account.dpam_sba_name    ACCTNAME                    
         ,account.dpam_sba_no      ACCNO                           
         ,convert(varchar,clim_dob,103) DOB      
   ,contc.conc_value EMAILID                
   FROM  client_mstr     clim                
         ,dp_acct_mstr   dpam                   
         ,exch_seg_mstr  excsm                  
         ,citrus_usr.fn_acct_list(@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id)  account         
         ,entity_adr_conc   entac        
         ,contact_channels  contc        
         ,conc_code_mstr    conccode            
   WHERE clim.clim_crn_no = dpam.dpam_crn_no           
   AND   entac.entac_concm_cd = 'email1'        
   AND   entac.entac_adr_conc_id = contc.conc_id         
   AND   clim.clim_crn_no = entac.entac_ent_id         
   AND   account.dpam_crn_no = clim.clim_crn_no                   
   AND   entac.entac_concm_id = conccode.concm_id         
   AND   excsm.excsm_id = dpam.dpam_excsm_id                  
   AND   excsm.excsm_id = @pa_excsmid                  
   --AND   convert(numeric,account.dpam_sba_no) between convert(numeric,@pa_frmacct) AND  convert(numeric,@pa_toacct)                  
   AND   (datediff(month,clim.clim_dob,convert(datetime,@pa_frmdt,103))>= 215  and datediff(month,clim.clim_dob,convert(datetime,@pa_frmdt,103))<=228)
   AND   (datediff(month,clim.clim_dob,convert(datetime,@pa_todt,103))>= 215   and datediff(month,clim.clim_dob,convert(datetime,@pa_todt,103))<= 228)
   AND   entac.entac_deleted_ind = 1         
   AND   contc.conc_deleted_ind = 1         
   AND   clim.clim_deleted_ind = 1         
   AND   conccode.concm_deleted_ind = 1                 
   ORDER BY account.dpam_sba_name                   
--                  
END     

pr_rpt_minor_to_major 'NOMINEE', 3, '1 jan 2009','20 nov 2010',1,'HO|*~|',''     

*/
create PROC [citrus_usr].[pr_rpt_minor_to_major_bak12052015]
(@pa_type varchar(25),
@pa_excsmid int,
@pa_fromdate datetime,
@pa_todate datetime,
@pa_login_pr_entm_id numeric ,                     
@pa_login_entm_cd_chain  varchar(8000),    
@pa_output varchar(8000) output )
as
begin
--


  IF @pa_type = 'CLIENT'
  BEGIN
  --
     select clim_name1 
										,clim_short_name 
										,dpam_sba_no
										,convert(varchar,clim_dob,103) [dob]
										,DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,clim_dob,103)))) MAJOR_DATE	
                                        ,clim_short_name As FullName
				From   Client_mstr 
				,dp_Acct_mstr
				where  dpam_crn_no = clim_crn_no
				and    dateadd(month,216,convert(datetime,clim_dob,103)) between @pa_fromdate and @pa_todate
				and    datediff(day,convert(datetime,clim_dob,103),convert(datetime,@pa_fromdate,103)) < 6570
    and    datediff(day,convert(datetime,clim_dob,103),convert(datetime,@pa_todate,103)) > 6570
  --
  END
  ELSE IF @pa_type = 'NOMINEE'
  BEGIN
  --
    select clim_name1
				      ,clim_short_name  
				      ,Dpam_sba_no      
				      ,dphd_nom_fname   
				      ,dphd_nom_mname   
				      ,dphd_nom_lname   
				      ,dphd_nom_fthname 
				      ,convert(varchar,dphd_nom_dob,103) [dob] 
					  ,DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,dphd_nom_dob,103)))) MAJOR_DATE	
                      ,(dphd_nom_fname + '' + dphd_nom_mname + '' + dphd_nom_lname) As FullName
    From   Client_mstr 
          ,dp_Acct_mstr 
          ,dp_holder_dtls
    where  dpam_crn_no  = clim_crn_no
    and    dphd_dpam_id = dpam_id
    and    dateadd(month,216,convert(datetime,dphd_nom_dob,103)) between @pa_fromdate and @pa_todate
				and    datediff(day,convert(datetime,dphd_nom_dob,103),convert(datetime,@pa_fromdate,103)) < 6570
    and    datediff(day,convert(datetime,dphd_nom_dob,103),convert(datetime,@pa_todate,103)) > 6570
    
  --
  END
  ELSE IF @pa_type = 'NOMINEE_MINOR'
		BEGIN
		--
				select clim_name1
										,clim_short_name  
										,Dpam_sba_no      
										,dphd_nom_fname   
										,dphd_nom_mname   
										,dphd_nom_lname   
										,dphd_nom_fthname 
										,convert(varchar,dphd_nom_dob,103) [dob] 
										,DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,dphd_nom_dob,103)))) MAJOR_DATE 	
                                        ,(dphd_nom_fname + '' + dphd_nom_mname + '' + dphd_nom_lname) As FullName
				From   Client_mstr 
										,dp_Acct_mstr 
										,dp_holder_dtls
				where  dpam_crn_no  = clim_crn_no
				and    dphd_dpam_id = dpam_id
				and    datediff(day,convert(datetime,dphd_nom_dob,103),convert(datetime,getdate(),103)) < 6570
				

		--
  END
  
  
--
end

GO
