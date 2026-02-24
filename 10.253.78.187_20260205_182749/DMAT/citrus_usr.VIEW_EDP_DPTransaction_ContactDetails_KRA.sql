-- Object: PROCEDURE citrus_usr.VIEW_EDP_DPTransaction_ContactDetails_KRA
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[VIEW_EDP_DPTransaction_ContactDetails_KRA] --'20130701','20130731'  
(  
@FromDate datetime,  
@ToDate datetime  
)  
AS  
  
select    pc1.boid [CLIENTID]             
,ltrim(rtrim(pc1.Name)) +' ' + ltrim(rtrim(isnull(pc1.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc1.SearchName,''))) [FirstHolderName]            
,pc1.PANGIR [FirstHolderPanNo]                
,pc1.DateOfBirth [FirstHolderDOB]            
,ltrim(rtrim(isnull(pc2.Name ,''))) +' ' + ltrim(rtrim(isnull(pc2.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc2.SearchName,''))) [SecondHolderName]      
,isnull(pc2.PANGIR ,'') [SecondHolderPanno]        
,isnull(pc2.DateOfBirth,'') [SecondHolderDOB]     
,ltrim(rtrim(isnull(pc3.Name,''))) +' ' + ltrim(rtrim(isnull(pc3.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc3.SearchName,''))) [ThirdHolderName]          
,isnull(pc3.PANGIR,'') [ThirdHolderPanno]              
,isnull(pc3.DateOfBirth,'') [ThirdHolderDOB]          
,isnull(replace(replace(isnull(citrus_usr.[fn_find_relations_nm](dpam_crn_no,'BR') ,citrus_usr.[fn_find_relations_nm](dpam_crn_no,'BA') ) ,'_br',''),'_ba',''),'') [Branchname]            
,isnull(replace(replace(isnull(citrus_usr.[fn_find_relations_Acctlvl_bill](dpam_id,'BR') ,citrus_usr.[fn_find_relations_Acctlvl_bill](dpam_id,'BA') ),'_ba',''),'_br',''),'') [BranchCode]          
,isnull(replace(replace(isnull(citrus_usr.[fn_find_relations_nm](dpam_crn_no,'rem') ,citrus_usr.[fn_find_relations_nm](dpam_crn_no,'onw') ) ,'_onw',''),'_rem',''),'') [subbroker]      
,isnull(replace(replace(isnull(citrus_usr.[fn_find_relations_Acctlvl_bill](dpam_id,'rem') ,citrus_usr.[fn_find_relations_Acctlvl_bill](dpam_id,'onw') ),'_onw',''),'_rem',''),'') [subbrokercd]              
,pc1.AcctCreatDt [AccountOpenDt]           
,isnull(pc1.ClosDt,'') [AccountCloseDt]  
,isnull(pc4.FreezeActDt ,'') [Freezedt]  
,case when pc1.PriPhInd  ='M' then pc1.PriPhNum else '' end mobile  
,isnull(pc1.EMailId,'')EMail  
,isnull(pc16.MobileNum ,'')smsmobile  
,isnull(pc16.EmailId ,'') smsemail  
from dp_acct_mstr with(nolock), dps8_pc1 pc1  with (nolock) left outer join   
dps8_pc2 pc2  with (nolock) on pc1.boid = pc2.boid left outer join   
dps8_pc3 pc3  with (nolock) on pc1.boid = pc3.boid  left outer join   
dps8_pc4   pc4 with (nolock) on pc1.boid = pc4.boid left outer join   
dps8_pc16   pc16 with (nolock) on pc1.boid = pc16.BOId   
where pc1.boid = dpam_sba_no  
and convert(numeric,pc1.AcctCreatDt)< 20120101  
and exists (select 1 from cdsl_holding_dtls with(nolock)   
where cdshm_ben_acct_no = dpam_sba_no AND (cdshm_tras_dt between @FromDate and @ToDate ))  
-- 'jul 01 2013' and 'jul 31 2013')

GO
