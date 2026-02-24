-- Object: PROCEDURE citrus_usr.pr_valid_kyc_client
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran

--exec pr_valid_kyc_client

--select * from API_CLIENT_MASTER_SYNERGY_DP where KIT_NO ='K62308' 

--select * from kyc.dbo.CDSLAPI_REJECTION where KIT_NO ='K62308' 

--select * from 

--rollback

CREATE proc [citrus_usr].[pr_valid_kyc_client]

as

begin 

--select top 10 * from  kyc.dbo.CDSLAPI_REJECTION

insert into kyc.dbo.CDSLAPI_REJECTION

select KIT_NO,'1',null,null,null,null,'SYNERGY', CONVERT(VARCHAR, GETDATE(),120),null

from API_CLIENT_MASTER_SYNERGY_DP where DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr )

and  purpose_code ='1'  and KIT_NO not in (select KIT_NO from  kyc.dbo.CDSLAPI_REJECTION where STATUS ='A')



if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where DIVI_MICR_CODE ='' and  purpose_code ='1' )

begin 



update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'

where  DIVI_MICR_CODE ='' and  purpose_code ='1' 



update a set purpose_code ='99'

,[col_name] ='MICR Code'

,[reject_reason]='MICR Code'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where  DIVI_MICR_CODE =''

and DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) and  purpose_code ='1'   ) 





end 



if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where PAN_GIR <>'' and FIRST_NAME=''  and   purpose_code ='6'  )

begin 



update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'

where  PAN_GIR <>'' and FIRST_NAME=''  and   purpose_code ='6'  



update a set purpose_code ='99'

,[col_name] ='Nominee'

,[reject_reason]='NOMINEE DETAILS VERFICATION IN CASE NOMINNEE IS AVAIALBLE LIKE DOB'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where  PAN_GIR <>'' and FIRST_NAME=''  and   purpose_code ='6'  

and DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) ) 





end 





if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where PAN_GIR =''  and   purpose_code ='1'  )

begin 



update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'

where PAN_GIR ='' and   purpose_code ='1'  



update a set purpose_code ='99'

,[col_name] ='PAN VERIFICATION'

,[reject_reason]='PAN VERIFICATION'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where PAN_GIR ='' and   purpose_code ='1'  

and DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) ) 





end 



if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where purpose_code ='1' group by DP_INTERNAL_REF having COUNT(1)>1)

begin 


update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'
where    purpose_code ='1'  
and DP_INTERNAL_REF in  (select DP_INTERNAL_REF from API_CLIENT_MASTER_SYNERGY_DP where purpose_code ='1' group by DP_INTERNAL_REF having COUNT(1)>1)    
and UpdatedFlag =''


update a set purpose_code ='99'

,[col_name] ='Application No Duplication'

,[reject_reason]='Application No Duplication'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where   DP_INTERNAL_REF in  (select DP_INTERNAL_REF from API_CLIENT_MASTER_SYNERGY_DP where purpose_code ='1' group by DP_INTERNAL_REF having COUNT(1)>1)  and   purpose_code ='1'  
)
and [status]<>'R'





end 



if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where purpose_code ='1' and DP_INTERNAL_REF ='' )

begin 


update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'
where    purpose_code ='1'  
and DP_INTERNAL_REF ='' 
and UpdatedFlag =''


update a set purpose_code ='99'

,[col_name] ='Application No Can not be blank'

,[reject_reason]='Application No Can not be blank'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where   DP_INTERNAL_REF ='' and   purpose_code ='1'  
)
and [status]<>'R'







end 


if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where DATE_OF_BIRTH =''  and   purpose_code ='1'  )

begin 



update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'

where DATE_OF_BIRTH ='' and   purpose_code ='1'  



update a set purpose_code ='99'

,[col_name] ='First Holder Dob'

,[reject_reason]='First Holder Dob'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where DATE_OF_BIRTH ='' and   purpose_code ='1'  

and DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) ) 





end 





if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP where PIN =''  and   purpose_code ='1'  )

begin 



update API_CLIENT_MASTER_SYNERGY_DP set UpdatedFlag ='R'

where PIN ='' and   purpose_code ='1'  



update a set purpose_code ='99'

,[col_name] ='PINCODE'

,[reject_reason]='PINCODE'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where PIN ='' and   purpose_code ='1'  

and DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) ) 





end 




if exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP a where  case when len(Bo_Customer_Type)=1 then '0' + convert(varchar,Bo_Customer_Type ) else convert(varchar,Bo_Customer_Type ) end 
+case when len(BO_CATEGORY)=1 then '0' + convert(varchar,BO_CATEGORY ) else convert(varchar,BO_CATEGORY ) end
+ case when len(BO_SUB_STATUS)=1 then '0' + convert(varchar,BO_SUB_STATUS ) else convert(varchar,BO_SUB_STATUS ) end ='012169' and  exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP b where a.kit_no = b.kit_no and b.PURPOSE_CODE='06'))

begin 



update  A set UpdatedFlag ='R'
FROM API_CLIENT_MASTER_SYNERGY_DP A
where  case when len(Bo_Customer_Type)=1 then '0' + convert(varchar,Bo_Customer_Type ) else convert(varchar,Bo_Customer_Type ) end 
+case when len(BO_CATEGORY)=1 then '0' + convert(varchar,BO_CATEGORY ) else convert(varchar,BO_CATEGORY ) end
+ case when len(BO_SUB_STATUS)=1 then '0' + convert(varchar,BO_SUB_STATUS ) else convert(varchar,BO_SUB_STATUS ) end ='012169' and  exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP b where a.kit_no = b.kit_no and b.PURPOSE_CODE='06')



update a set purpose_code ='99'

,[col_name] ='NONOMINATION'

,[reject_reason]='CLIENT SHOULD BE WITHOUT NOMINATION'

,[status] ='R' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where  case when len(Bo_Customer_Type)=1 then '0' + convert(varchar,Bo_Customer_Type ) else convert(varchar,Bo_Customer_Type ) end 
+case when len(BO_CATEGORY)=1 then '0' + convert(varchar,BO_CATEGORY ) else convert(varchar,BO_CATEGORY ) end
+ case when len(BO_SUB_STATUS)=1 then '0' + convert(varchar,BO_SUB_STATUS ) else convert(varchar,BO_SUB_STATUS ) end ='012169' and  exists (select 1 from API_CLIENT_MASTER_SYNERGY_DP b where a.kit_no = b.kit_no and b.PURPOSE_CODE='06')
and DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) ) 





end 








update a set purpose_code ='1'

,[col_name] =null

,[reject_reason]=null

,[status] ='A' from kyc.dbo.CDSLAPI_REJECTION a 

where kit_no in (select kit_no  from API_CLIENT_MASTER_SYNERGY_DP where  DP_INTERNAL_REF not in (select dpam_acct_no from dp_acct_mstr ) and  purpose_code ='1'   ) 

and isnull([status] ,'')=''







end

GO
