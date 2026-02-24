-- Object: PROCEDURE citrus_usr.pr_bulk_entr_update
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*  
  
pr_bulk_entr_update 0,'DP','HO|*~|MNRA|*~|','','','','',''    
  
-- SELECT ------  
  
pr_bulk_entr_update '1','DP','FRHARKISHA_BR|*~|R132_SBFR|*~|HARKISHANDASSANGHAV_RM_BR','','1','','',''  
  
pr_bulk_entr_update 1,'DP','HO|*~|MNRA|*~|MAULIK|*~|','','','','',''  
  
pr_bulk_entr_update 1,'DP','HO|*~|PUNE|*~|MAULIK|*~|','','','','',''  
  
pr_bulk_entr_update 1,'DP','HO|*~|PUNE|*~||*~||*~|','','','','',''    
  
  
*/  
CREATE PROCEDURE [citrus_usr].[pr_bulk_entr_update]  
 (  
   @PA_SELECT_YN CHAR(1)  
  ,@pa_brkg_dp  varchar(1000)  
  ,@pa_values varchar(8000)  
  ,@pa_acct_cd varchar(max)
  ,@pa_branch_upd_yn CHAR(1)  
  ,@PA_EFF_FROM VARCHAR(11)  
  ,@pa_align VARCHAR(1)  
  ,@pa_group_cd char(1)  
  ,@PA_MSG VARCHAR(8000) OUTPUT  
 )    
  
AS  
BEGIN  
declare  @pa_br VARCHAR(30)  
  ,@pa_sbfr VARCHAR(30)  
  ,@pa_rm VARCHAR(30)  
  ,@pa_fm varchar(30)  
  ,@pa_ho varchar(30)  
  ,@pa_grp varchar(30)  ,@pa_ar varchar(30),@pa_re varchar(30)  ,@pa_ba varchar(30)  ,@pa_onw varchar(30)  
  
SET  @pa_br =''  
SET  @pa_sbfr=''  
SET  @pa_rm= ''  
SET  @pa_fm =''  
SET  @pa_ho =''  
set @pa_ar = ''
set @pa_re =''
set @pa_ba =''
set @pa_onw =''


  


SELECT @pa_ho = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 1) AND ENTM_DELETED_IND = 1  
--print @pa_ho
SELECT @pa_ar = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 2) AND ENTM_DELETED_IND = 1  
--print @pa_ar
SELECT @pa_re = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 3) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 3),'2')='RE'  
--print @pa_re
--

if ltrim(rtrim(isnull(@pa_re,'')))=''
begin 

SELECT @pa_br = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 3) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 3),'2')='BR'
SELECT @pa_ba = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 3) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 3),'2')='BA'  

end

else

begin

SELECT @pa_br = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 4) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 4),'2')='BR'
SELECT @pa_ba = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 4) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 4),'2')='BA'  
end
-----
if ltrim(rtrim(isnull(@pa_re,'')))=''
begin 
SELECT @pa_rm = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 4) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 4),'3')='REM'
SELECT @pa_onw = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 4) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 4),'3')='ONW'  
end

else

begin
SELECT @pa_rm = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 5) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 5),'3')='REM'
SELECT @pa_onw = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 5) AND ENTM_DELETED_IND = 1  and right(citrus_usr.fn_splitval(@pa_values , 5),'3')='ONW'  
end

--SELECT @pa_sbfr = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 3) AND ENTM_DELETED_IND = 1  
  
--SELECT @pa_rm = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 4) AND ENTM_DELETED_IND = 1  
  
--SELECT @pa_fm = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 3) AND ENTM_DELETED_IND = 1  
  

  
  
SELECT @pa_grp = ENTM_ID FROM ENTITY_MSTR WHERE ENTM_SHORT_NAME = citrus_usr.fn_splitval(@pa_values , 4) AND ENTM_DELETED_IND = 1  
  
IF @PA_SELECT_YN = 0  
  
BEGIN  
   
     DECLARE @l_counter NUMERIC  
  ,@l_count   NUMERIC  
  ,@l_crn_no  NUMERIC  
  ,@pa_entr_value VARCHAR(8000)  
  
  SELECT @l_count = citrus_usr.ufn_CountString(@pa_acct_cd , '*|~*')  
  SET @l_crn_no = 0   
  SET @l_counter = 1   
  
   IF @pa_branch_upd_yn = '0' or @pa_brkg_dp = 'DP'   
   BEGIN  
     WHILE @l_counter < = @l_count  
     BEGIN  
      
        if @pa_brkg_dp = 'BROKING'           
        SELECT @l_crn_no = clia_crn_no from client_accounts where clia_acct_no = citrus_usr.FN_SPLITVAL_ROW(@pa_acct_cd,@l_counter) and clia_deleted_ind = 1  
                                  
        if @pa_brkg_dp = 'DP'  
        SELECT @l_crn_no = dpam_crn_no from dp_Acct_mstr where dpam_sba_no = citrus_usr.FN_SPLITVAL_ROW(@pa_acct_cd,@l_counter) and dpam_deleted_ind = 1  
  
--    @pa_rm

--print @pa_onw

print 'fdsfdfd'
print @l_count
  
        SELECT @pa_entr_value  = ISNULL(@pa_entr_value,'') + CONVERT(VARCHAR,EXCSM_COMPM_ID)+'|*~|'+CONVERT(VARCHAR,EXCPM_EXCSM_ID)+'|*~|'+ENTR_ACCT_NO+'|*~|'+ISNULL(ENTR_SBA, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,@PA_EFF_FROM,103))+'|*~|'           
                           
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_ho),'')+'|*~|'  
            +case when (isnull(@pa_re,'')<>'' and isnull(entr.entr_re,'0')='0') then 're' else  ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_re',entr.entr_re),'') end +'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(case when rtrim(ltrim(isnull(@pa_re,'')))  <> '' then rtrim(ltrim(isnull(@pa_re,''))) else entr.entr_re end),'')+'|*~|'  
            +case when (isnull(@pa_ar,'')<>'' and isnull(entr.entr_ar,'0')='0') then 'AR' else  ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'') end +'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(case when @pa_ar  <> '' then @pa_ar else entr.ENTR_ar end),'')+'|*~|'  
            +case when (isnull(entr.entr_br,'0')='0' and ltrim(rtrim(isnull(@pa_ba,'')))='' and ltrim(rtrim(isnull(@pa_br,'')))<>'') then 'BR' else ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'') end +'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(case when @pa_br  <> '' then @pa_br else case when @pa_ba <> '' then null else entr.ENTR_br end end),'')+'|*~|' --ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'  
            +case when (isnull(entr.entr_sb,'0')='0' and ltrim(rtrim(isnull(@pa_ba,'')))<>'' and ltrim(rtrim(isnull(@pa_br,'')))='') then 'BA' else ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'') end +'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(case when @pa_ba  <> '' then @pa_ba else case when @pa_br<>'' then null else entr.entr_sb end end ),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'  
            +case when (isnull(entr.entr_dummy1,'0')='0' and ltrim(rtrim(isnull(@pa_rm,'')))<>'' and ltrim(rtrim(isnull(@pa_onw,'')))='') then 'REM' else ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'') end +'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(case when @pa_Rm  <> '' then @pa_Rm else case when @pa_ONW<>'' then null else entr.ENTR_DUMMY1 end end ),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'  
            +case when (isnull(entr.entr_dummy3,'0')='0' and ltrim(rtrim(isnull(@pa_rm,'')))='' and ltrim(rtrim(isnull(@pa_onw,'')))<>'') then 'ONW' else ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'') end +'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(case when @pa_ONW  <> '' then @pa_ONW else case when @pa_Rm<>'' then null else  entr.ENTR_DUMMY3 end end),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'  
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'  
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|A*|~*'    
          
        FROM ENTITY_RELATIONSHIP ENTR, EXCSM_PROD_MSTR, EXCH_SEG_MSTR  
        WHERE   ENTR_CRN_NO = @L_CRN_NO   
        AND  ENTR_EXCPM_ID = EXCPM_ID  
        and  entr_sba = citrus_usr.FN_SPLITVAL_ROW(@pa_acct_cd,@l_counter)  
        AND   EXCPM_EXCSM_ID = EXCSM_ID  
        AND  ENTR_DELETED_IND = 1  
        AND  EXCPM_DELETED_IND = 1   and getdate() between entr_from_dt and isnull(entr_to_dt ,'dec 31 2100')
  
                  
 



     exec pr_ins_upd_dpentr @l_crn_no,'','HO',@l_crn_no,@pa_entr_value ,0,'*|~* ','|*~|',''  
     set @pa_entr_value =''  
     SET @l_counter = @l_counter  + 1   
  
     SET @l_crn_no = 0  
     END  
  
   END   
   ELSE IF @pa_branch_upd_yn = '1' and @pa_brkg_dp = 'BROKING'  
   BEGIN    
     WHILE @l_counter < = @l_count  
     BEGIN  
        SELECT @l_crn_no = clia_crn_no from client_accounts where clia_acct_no = citrus_usr.FN_SPLITVAL_ROW(@pa_acct_cd,@l_counter) and clia_deleted_ind = 1  
  
     --EXEC  pr_new_cli_by_br_change @l_crn_no ,@pa_align ,@PA_BR , @PA_SBFR ,@PA_RM ,@PA_EFF_FROM  
  
        SET @l_counter = @l_counter  + 1   
  
     SET @l_crn_no = 0  
     END   
  
   END   
  
    END    
  
 ELSE IF @PA_SELECT_YN = 1  
  
  
 BEGIN   
    if @pa_brkg_dp = 'BROKING'  
    
 SELECT DISTINCT ENTR_ACCT_NO , CLIM_SHORT_NAME , CONVERT(VARCHAR(11),ENTR_FROM_DT,103) EFF_FROM_DT  
 FROM ENTITY_RELATIONSHIP , CLIENT_MSTR , client_accounts   
 WHERE ENTR_CRN_NO = CLIM_CRN_NO  
    and   entr_acct_no = clia_acct_no   
    and   clim_crn_no = clia_crn_no   
 AND   ENTR_DELETED_IND = 1  
 AND   CLIM_DELETED_IND = 1  
 AND   isnull(ENTR_AR,0) = case when @PA_br ='' then 0 else @PA_br end  
 AND   (isnull(ENTR_SB,0) = case when @PA_rm ='' then 0 else @PA_rm end and  isnull(ENTR_RM,0) = case when @PA_SBFR ='' then 0 else @PA_SBFR end )  
 and   getdate() between isnull(ENTR_from_DT,'jan 01 1900')  and isnull(ENTR_TO_DT,'jan 01 2900')   
  
    IF @PA_BRKG_DP = 'DP'  

 if @pa_group_cd = 'N'  
 Begin  
   SELECT DISTINCT ENTR_sba , CLIM_SHORT_NAME , CONVERT(VARCHAR(11),ENTR_FROM_DT,103) EFF_FROM_DT  
   FROM ENTITY_RELATIONSHIP , CLIENT_MSTR , dp_acct_mstr  
   WHERE ENTR_CRN_NO = CLIM_CRN_NO  
   and  entr_acct_no = dpam_acct_no    
   and  clim_crn_no = dpam_crn_no      
   AND  ENTR_DELETED_IND = 1  
   AND  CLIM_DELETED_IND = 1     
   AND   isnull(ENTR_HO,0) = case when LTRIM(RTRIM(@PA_HO)) ='' then 0 else LTRIM(RTRIM(@PA_HO)) end  
   --AND   isnull(ENTR_dummy1,0) = case when LTRIM(RTRIM(@PA_fm)) = '' then 0 else LTRIM(RTRIM(@PA_fm)) end  
   --AND   isnull(ENTR_AR,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end --commented by Shilpa  
   AND (isnull(ENTR_RE,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end --written by Shilpa for MOSL  
   OR isnull(ENTR_AR,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_BR,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_SB,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DL,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DL,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_RM,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY1,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY2,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY3,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY4,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY5,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY6,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY7,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY8,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY9,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end  
   OR isnull(ENTR_DUMMY10,0) = case when LTRIM(RTRIM(@PA_br)) ='' then 0 else LTRIM(RTRIM(@PA_br)) end ) 
   
 --AND   (isnull(ENTR_SB,0) = case when @PA_rm ='' then 0 else @PA_rm end   
    --AND  isnull(ENTR_RM,0) = case when @PA_SBFR ='' then 0 else @PA_SBFR end )  
 end   
 else --if @pa_group_cd = 'Y'  
 begin   
  SELECT DISTINCT ENTR_sba , CLIM_SHORT_NAME , CONVERT(VARCHAR(11),ENTR_FROM_DT,103) EFF_FROM_DT,grp_client_code  
   FROM ENTITY_RELATIONSHIP   
, CLIENT_MSTR   
--, dp_acct_mstr   
,group_mstr  
   WHERE   
   ENTR_CRN_NO = CLIM_CRN_NO  
   and  ENTR_SBA = grp_client_code  
            and getdate() between entr_from_dt and isnull(entr_to_dt,'2100-01-01')  
   AND  ENTR_DELETED_IND = 1  
   and  grp_DELETED_IND = 1  
 end  
      
 END        
END

GO
