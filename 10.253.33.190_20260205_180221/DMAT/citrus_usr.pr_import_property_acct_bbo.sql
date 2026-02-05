-- Object: PROCEDURE citrus_usr.pr_import_property_acct_bbo
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--BEGIN tran      
--exec [pr_import_property_acct_bbo] 'bbo_code'      
--select max(accp_id) from account_properties --21989      
--select max(accp_id) from accp_mak --21998      
--select * from entity_properties where ENTP_ENTPM_CD='DIS_req' -- 2016
--select 1276+9316--10592      
--commit      
  --rollback
--select cltdpno                from tmp_bbo_jun0212       
--where NOT EXISTS (select accp_value       
--                  from dp_Acct_mstr, account_properties       
--                  WHERE dpam_sba_no = cltdpno       
--                  and accp_clisba_id = dpam_id       
--                  AND accp_accpm_prop_Cd = 'bbo_code' and ltrim(rtrim(accp_value)) <> ''     
--                  )     
--select * from account_properties where accp_acct_no='1201090000000019'    --T06539
--1201090000008888	R07322    
--select * from account_properties where accp_id < 21998      
--select distinct accpm_prop_cd,accpm_prop_id from account_property_mstr  order by 1 desc   
-- select * from sysobjects order by 10 desc    
      
CREATE PROCEDURE [citrus_usr].[pr_import_property_acct_bbo](@pa_cd VARCHAR(100))      
AS      
BEGIN      
       
declare @c_client_summary1  cursor      
,@c_ben_acct_no1  varchar(20)      
,@L_ACCP_VALUE VARCHAR(8000)      
,@L_dpam_id numeric       
,@L_crn_no numeric       
      
set @c_client_summary1  = CURSOR fast_forward FOR                    

select distinct client_code from tmp_050116



open @c_client_summary1      
      
fetch next from @c_client_summary1 into @c_ben_acct_no1       
      
      
      
WHILE @@fetch_status = 0                                                                                                              
BEGIN --#cursor                                                                                                              
--      
      
SET @L_ACCP_VALUE       = ''      
      
SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,'76') + '|*~|' 
+ case when ltrim(rtrim(dis_flag ))='N' then 'NO' else 'YES' + '|*~|*|~*'   end      
FROM  tmp_050116  
where  client_code  = @c_ben_acct_no1       
     
      
SET @L_dpam_id = 0       
      
SELECT @L_dpam_id = dpam_id , @L_crn_no = dpam_crn_no FROM dp_acct_mstr WHERE dpam_sba_no =  @c_ben_acct_no1       
      --create index ix_1 on tmp_bbo_aug12151(dpam_sba_no)
        
print @L_ACCP_value
EXEC pr_ins_upd_entp '1','EDT','MIG',@L_crn_no,'',@L_ACCP_VALUE,'',0,'*|~*','|*~|',''        
--EXEC pr_ins_upd_accp @l_crn_no ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,'' ,0,'*|~*','|*~|',''      
      
      
fetch next from @c_client_summary1 into @c_ben_acct_no1       
      
      
--      
end      
      
close @c_client_summary1        
deallocate  @c_client_summary1        
      
END

GO
