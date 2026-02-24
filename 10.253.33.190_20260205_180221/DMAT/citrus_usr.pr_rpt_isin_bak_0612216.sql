-- Object: PROCEDURE citrus_usr.pr_rpt_isin_bak_0612216
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create Proc [citrus_usr].[pr_rpt_isin_bak_0612216]  
(  
@pa_deptype int, -- 1 for NSDL/2 for cdsl  
@pa_isin varchar(12),  
@pa_registrar varchar(20)  
)  
AS  
  
if @pa_registrar <> ''  
begin  
	 if @pa_deptype = 1
	 begin
		 select isin_cd,isin_name,isin_status=CASE WHEN isin_status='01' THEN 'ACTIVE' WHEN  isin_status='02' THEN 'SUSPENDED FOR ALL' WHEN  isin_status='03' THEN 'SUSPENDED FOR DEBIT' WHEN  isin_status='04' THEN 'TO BE CLOSED' WHEN isin_status='05' THEN 'CLOSED'
		 ELSE isin_status END,internal_isin_type = case when isin_filler = 'B' then 'BARRED ISIN' when isin_filler = 'P' then 'LONG PENDING ISIN' else '' end  
		 ,Reg_cd=entm_short_name,Reg_name=entm_name1,Reg_adr=ltrim(rtrim(replace(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),'|*~|',', ')))  
		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') 
		 ,Reg_fax=isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'')
		 ,face_value = isnull(isin_face_val,0)
		 ,last_closing_price =isnull(CLOPM_NSDL_RT,0)  
		 from isin_mstr left outer join CLOSING_LAST_NSDL on isin_cd = CLOPM_ISIN_CD
		 ,entity_mstr   
		 where (isin_bit = 1 or isin_bit = 0) and entm_enttm_cd = 'SR' 
		 and  ltrim(rtrim(isin_reg_cd)) = ltrim(rtrim(entm_short_name))  
		 and entm_short_name = @pa_registrar  
		 and isin_cd like @pa_isin + '%'  
		 order by isin_name,isin_cd  
	end
	else
	begin
		 select isin_cd,isin_name,isin_status=CASE WHEN isin_status='01' THEN 'ACTIVE' WHEN  isin_status='02' THEN 'SUSPENDED FOR ALL' WHEN  isin_status='03' THEN 'SUSPENDED FOR DEBIT' WHEN  isin_status='04' THEN 'TO BE CLOSED' WHEN isin_status='05' THEN 'CLOSED'
		 ELSE isin_status END,internal_isin_type = case when isin_filler = 'B' then 'BARRED ISIN' when isin_filler = 'P' then 'LONG PENDING ISIN' else '' end  
		 ,Reg_cd=replace(ltrim(rtrim(entm_short_name)),'RTA_',''),Reg_name=entm_name1,Reg_adr=ltrim(rtrim(replace(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),'|*~|',', ')))  
		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') + ', ' + isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH2'),'') 
		 ,Reg_fax=isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'')
		 ,face_value = isnull(isin_face_val,0)
		 ,last_closing_price =isnull(CLOPM_CDSL_RT,0)   
		 from isin_mstr left outer join CLOSING_LAST_CDSL on isin_cd = CLOPM_ISIN_CD
		 ,entity_mstr   
		 where (isin_bit = @pa_deptype or isin_bit = 0) and entm_enttm_cd = 'RTA'
		 and  ltrim(rtrim(isin_reg_cd)) = replace(ltrim(rtrim(entm_short_name)),'RTA_','') 
		 and entm_short_name = @pa_registrar  
		 and isin_cd like @pa_isin + '%'  
		 order by isin_name,isin_cd  
	end

end  
else  
begin  
	 if @pa_deptype = 1
	 begin
		 select isin_cd,isin_name,isin_status=CASE WHEN isin_status='01' THEN 'ACTIVE' WHEN  isin_status='02' THEN 'SUSPENDED FOR ALL' WHEN  isin_status='03' THEN 'SUSPENDED FOR DEBIT' WHEN  isin_status='04' THEN 'TO BE CLOSED' WHEN isin_status='05' THEN 'CLOSED'
		 ELSE isin_status END,internal_isin_type = case when isin_filler = 'B' then 'BARRED ISIN' when isin_filler = 'P' then 'LONG PENDING ISIN' else '' end  
		 ,Reg_cd=entm_short_name,Reg_name=entm_name1,Reg_adr=ltrim(rtrim(replace(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),'|*~|',', ')))  
		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') 
		 ,Reg_fax= isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'') 
		 ,face_value = isnull(isin_face_val,0)
		 ,last_closing_price =isnull(CLOPM_NSDL_RT,0)  
		 from isin_mstr left outer join CLOSING_LAST_NSDL on isin_cd = CLOPM_ISIN_CD
		 ,entity_mstr   
		 where (isin_bit = 1 or isin_bit = 0) and entm_enttm_cd = 'SR'
		 and ltrim(rtrim(isin_reg_cd)) = ltrim(rtrim(entm_short_name))  
		 and isin_cd like @pa_isin + '%'  
		 order by isin_name,isin_cd  
	end
	else
	begin
		 select isin_cd,isin_name,isin_status=CASE WHEN isin_status='01' THEN 'ACTIVE' WHEN  isin_status='02' THEN 'SUSPENDED FOR ALL' WHEN  isin_status='03' THEN 'SUSPENDED FOR DEBIT' WHEN  isin_status='04' THEN 'TO BE CLOSED' WHEN isin_status='05' THEN 'CLOSED'
		 ELSE isin_status END,internal_isin_type = case when isin_filler = 'B' then 'BARRED ISIN' when isin_filler = 'P' then 'LONG PENDING ISIN' else '' end  
		 ,Reg_cd=replace(ltrim(rtrim(entm_short_name)),'RTA_',''),Reg_name=entm_name1,Reg_adr=ltrim(rtrim(replace(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),'|*~|',', ')))  
		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') + ', ' + isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH2'),'') 
		 ,Reg_fax= isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'')  
		 ,face_value = isnull(isin_face_val,0)
		 ,last_closing_price =isnull(CLOPM_CDSL_RT,0)   
		 from isin_mstr left outer join CLOSING_LAST_CDSL on isin_cd = CLOPM_ISIN_CD
		 ,entity_mstr   
		 where (isin_bit = 2 or isin_bit = 0) and entm_enttm_cd = 'RTA'
		 and ltrim(rtrim(isin_reg_cd)) = replace(ltrim(rtrim(entm_short_name)),'RTA_','') 
		 and isin_cd like @pa_isin + '%'  
		 order by isin_name,isin_cd 
	end




end

GO
