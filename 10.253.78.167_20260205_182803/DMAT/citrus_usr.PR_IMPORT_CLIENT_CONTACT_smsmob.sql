-- Object: PROCEDURE citrus_usr.PR_IMPORT_CLIENT_CONTACT_smsmob
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[PR_IMPORT_CLIENT_CONTACT_smsmob]
as
begin 

			SELECT DPAM_CRN_NO INTO #TEMPCRN FROM DP_ACCT_MSTR WHERE DPAM_DELETED_IND = 1 GROUP BY DPAM_CRN_NO 
			HAVING COUNT(DPAM_CRN_NO ) = 1


			select  VAL, existsflag into #tmp_CONTACT from (
			select distinct ISNULL(LTRIM(RTRIM(PRIPHNUM)),'') VAL,'N' existsflag from DPs8_PC1 where isnull(PRIPHNUM,'') <> ''
			
			) a 




			update #tmp_CONTACT set existsflag = 'Y'
			from #tmp_CONTACT , CONTACT_CHANNELS where ltrim(rtrim(CONC_VALUE))=ltrim(rtrim(VAL))
			--select * from #tmp_CONTACT
			--return
			select identity(numeric,1,1) id, * into #tmp_CONTACT1 from #tmp_CONTACT where existsflag ='N'
			declare @l_bitlocation1 numeric
			select @l_bitlocation1  = bitrm_bit_location + 1 from bitmap_ref_mstr  where bitrm_parent_cd ='ADR_conc_ID'


			update bitmap_ref_mstr set bitrm_bit_location = @l_bitlocation1 + (select count(*) from #tmp_CONTACT1) + 100
			where bitrm_parent_cd ='ADR_conc_ID'

			insert into CONTACT_CHANNELS  
			select @l_bitlocation1  + id , VAL,'MIG',getdate(),'MIG',getdate(),1 from #tmp_CONTACT1

			declare @l_concm_id numeric
			declare @l_concm_cd varchar(1000)

			select @l_concm_id = concm_id , @l_concm_cd = concm_cd  from conc_code_mstr where concm_cd = 'MOBSMS'


			update  entac set entac_adr_conc_id = CONC_id 
			from dp_acct_mstr 
			 , DPs8_PC1 
			 , CONTACT_CHANNELS 
			 , entity_adr_conc entac
			where entac_ent_id = dpam_crn_no 
			and entac_deleted_ind =1 
			and ENTAC_CONCM_CD ='MOBSMS'
			and dpam_sba_no = boid 
			and CONC_VALUE  =ISNULL(LTRIM(RTRIM(PRIPHNUM)),'')
			and ISNULL(LTRIM(RTRIM(PRIPHNUM)),'') <> ''
			

			insert into entity_adr_conc
			select a.dpam_crn_no,'',@l_concm_id ,@l_concm_cd, max(CONC_id),'MIG',getdate(),'MIG',getdate(),1  from dp_acct_mstr a
			 , DPs8_PC1 
			 , CONTACT_CHANNELS  ,#tempcrn b
			where dpam_sba_no = boid 
			and CONC_VALUE  = 			ISNULL(LTRIM(RTRIM(PRIPHNUM)),'')

			and a.dpam_crn_no  = b.dpam_crn_no 
			and not exists(select entac_ent_id , entac_concm_id 
					   from entity_adr_conc 
					   where entac_ent_id = a.dpam_crn_no 
						and entac_deleted_ind =1 
						and ENTAC_CONCM_CD ='MOBSMS')
			and ISNULL(LTRIM(RTRIM(PRIPHNUM)),'')<> ''	
			group by a.dpam_crn_no	

			
		

end

GO
