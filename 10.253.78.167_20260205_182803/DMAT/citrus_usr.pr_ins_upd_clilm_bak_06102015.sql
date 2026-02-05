-- Object: PROCEDURE citrus_usr.pr_ins_upd_clilm_bak_06102015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create PROC [citrus_usr].[pr_ins_upd_clilm_bak_06102015](@PA_ACTION VARCHAR(100)  
,@PA_CLIC_MOD_DPAM_SBA_NO VARCHAR(16)  
,@PA_CLIC_MOD_PAN_NO VARCHAR(50)  
,@PA_CLIC_MOD_ACTION VARCHAR(250)  
,@PA_LOGIN_NAME VARCHAR(100)  
,@PA_ERROR VARCHAR(1000) OUT )  
AS  
BEGIN  

declare @@dpmid int

IF @PA_ACTION ='INS'  
begin  
INSERT INTO CLIENT_LIST_MODIFIED  
SELECT @PA_CLIC_MOD_DPAM_SBA_NO,@PA_CLIC_MOD_PAN_NO,@PA_CLIC_MOD_ACTION,GETDATE(),GETDATE(),@PA_LOGIN_NAME ,GETDATE(),@PA_LOGIN_NAME , GETDATE(),0,0  
end  
IF @PA_ACTION ='APP'  
begin  

select @PA_CLIC_MOD_PAN_NO = entp_value from entity_properties 
where ENTP_ENTPM_CD='PAN_GIR_NO' 
and ENTP_ENT_ID=@PA_CLIC_MOD_DPAM_SBA_NO

--select @PA_CLIC_MOD_DPAM_SBA_NO = dpam_sba_no 
--from dp_acct_mstr,CLIENT_LIST_MODIFIED 
--where dpam_crn_no= @PA_CLIC_MOD_DPAM_SBA_NO  
--and clic_mod_dpam_sba_no = DPAM_SBA_NO 
--AND CLIC_MOD_DELETED_IND=0

--UPDATE CLIENT_LIST_MODIFIED SET CLIC_MOD_DELETED_IND=1,CLIC_MOD_LST_UPD_BY=@PA_LOGIN_NAME ,  
--CLIC_MOD_LST_UPD_DT=GETDATE() WHERE (CLIC_MOD_DPAM_SBA_NO = @PA_CLIC_MOD_DPAM_SBA_NO  
--OR CLIC_MOD_PAN_NO = @PA_CLIC_MOD_PAN_NO)   AND CLIC_MOD_DELETED_IND=0

select @PA_CLIC_MOD_DPAM_SBA_NO = dpam_crn_no--dpam_sba_no 
from dp_acct_mstr, CLIENT_LIST_MODIFIED
where dpam_crn_no= @PA_CLIC_MOD_DPAM_SBA_NO  
and DPAM_SBA_NO = clic_mod_dpam_sba_no

UPDATE Cl SET Cl.CLIC_MOD_DELETED_IND=1,Cl.CLIC_MOD_LST_UPD_BY=@PA_LOGIN_NAME ,  
Cl.CLIC_MOD_LST_UPD_DT=GETDATE() from CLIENT_LIST_MODIFIED Cl, Dp_acct_mstr
 WHERE CLIC_MOD_DELETED_IND=0 and DPAM_SBA_NO = clic_mod_dpam_sba_no
and dpam_crn_no=@PA_CLIC_MOD_DPAM_SBA_NO

end 
IF @PA_ACTION = 'VALIDATE_SMSFLAG'  
BEGIN 
	 SELECT  isnull(a.conc_value, '')        value                
                --, convert(int,concm.concm_rmks)                  
           FROM  (SELECT entac.entac_concm_id      concm_id                      
                       , conc.conc_value           conc_value                      
                  FROM   contact_channels          conc  WITH (NOLOCK)                      
                       , entity_adr_conc           entac WITH (NOLOCK)                      
                 WHERE(entac.entac_adr_conc_id = conc.conc_id)
                  AND    entac.entac_ent_id      = @PA_CLIC_MOD_DPAM_SBA_NO                     
                  AND    conc.conc_deleted_ind   = 1                      
                  AND    entac.entac_deleted_ind = 1                      
                 ) a                      
                  RIGHT OUTER JOIN                      
                  conc_code_mstr                     concm  WITH (NOLOCK)                      
                  ON concm.concm_id=a.concm_id                      
                 WHERE(concm.concm_deleted_ind = 1)
           AND    1 & concm.concm_cli_yn         = 1                      
           AND    2 & CONCM.CONCM_CLI_YN         = 2                      
        and concm_cd = 'SMSMOB'
--	union
--	  SELECT  isnull(a.conc_value, '')        value                
--                --, convert(int,concm.concm_rmks)                  
--           FROM  (SELECT entac.entac_concm_id      concm_id                      
--                       , conc.conc_value           conc_value                      
--                  FROM   contact_channels_mak          conc  WITH (NOLOCK)                      
--                       , entity_adr_conc           entac WITH (NOLOCK)                      
--                 WHERE(entac.entac_adr_conc_id = conc.conc_id)
--                  AND    entac.entac_ent_id      = @PA_CLIC_MOD_DPAM_SBA_NO                     
--                  AND    conc.conc_deleted_ind   = 1                      
--                  AND    entac.entac_deleted_ind = 1                      
--                 ) a                      
--                  RIGHT OUTER JOIN                      
--                  conc_code_mstr                     concm  WITH (NOLOCK)                      
--                  ON concm.concm_id=a.concm_id                      
--                 WHERE(concm.concm_deleted_ind = 1)
--           AND    1 & concm.concm_cli_yn         = 1                      
--           AND    2 & CONCM.CONCM_CLI_YN         = 2                      
--        and concm_cd = 'SMSMOB'       
END
IF @PA_ACTION = 'VALIDATE_CLIENTID'
BEGIN
	select @@dpmid = dpm_id from dp_mstr with(nolock) where DPM_DPID = @PA_CLIC_MOD_ACTION and dpm_deleted_ind =1
	SELECT DPAM_SBA_NO FROM DP_ACCT_MSTR WHERE DPAM_SBA_NO = @PA_CLIC_MOD_DPAM_SBA_NO 
	AND DPAM_DPM_ID = @@dpmid 
	AND DPAM_STAM_CD IN ('ACTIVE','02','03')
	AND DPAM_DELETED_IND = 1
END

IF @PA_ACTION = 'VALIDATE_DPCLIENTID'
BEGIN
	select @@dpmid = dpm_id from dp_mstr with(nolock) where DPM_DPID = @PA_CLIC_MOD_ACTION and dpm_deleted_ind =1
	SELECT DPAM_SBA_NO FROM DP_ACCT_MSTR WHERE DPAM_SBA_NO = @PA_CLIC_MOD_DPAM_SBA_NO 
	AND DPAM_DPM_ID = @@dpmid 
	--AND DPAM_STAM_CD IN ('ACTIVE','02','03')
	AND DPAM_DELETED_IND = 1
END
END

GO
