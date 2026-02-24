-- Object: FUNCTION citrus_usr.gettranstype_DRF
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

  
create function [citrus_usr].[gettranstype_DRF] (@pa_trans_no varchar(100),@pa_dpam_id numeric)          
returns varchar(1000)          
as  
begin          
declare @l varchar(1000)        
set @l =''    
--    
  

  
/*added by tushar on may 22 2014 by request to change by naresh sir */  
------if @l = ''  
------select  top 1  @l  = 'Alleged – Buy instruction mismatch.'   from cdsl_holding_dtls --, transaction_sub_type_mstr     
------where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id    
------and CDSHM_TRATM_CD ='4475' -- and CDSHM_CDAS_SUB_TRAS_TYPE not in ('307','301','303')
------and not exists (select 1 from cdsl_holding_dtls where cdshm_trans_no =@pa_trans_no and  cdshm_dpam_id = @pa_dpam_id    and CDSHM_TRATM_CD ='2277'
------)
------and  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') ='A'  
  
--and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') = TRASTM_CD    
--and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') <> '0'    
--and CDSHM_CDAS_TRAS_TYPE in (6,33,32)    
--and TRASTM_TRATM_ID = 36 


 select  top 1  @l  = 'Alleged - Buy instruction Mismatch. Rejected'   from cdsl_holding_dtls with(nolock) --, transaction_sub_type_mstr                 
where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id                
and  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') ='A'              
and convert(datetime,convert(varchar(11),getdate(),103),103) <> CDSHM_TRAS_DT           
and exists (select 1 from cdsl_holding_dtls with(nolock) where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id            
group by cdshm_trans_no , cdshm_dpam_id   having mAX(CDSHM_CDAS_SUB_TRAS_TYPE)='301' )
   
if @l = ''   
select  top 1  @l  = isnull(TRASTM_DESC,'')   from cdsl_holding_dtls , transaction_sub_type_mstr     
where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id    
and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') = TRASTM_CD    
and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') <> '0'    
and CDSHM_CDAS_TRAS_TYPE in (6,33,32)    
and TRASTM_TRATM_ID = 36    
  
if @l <> ''    
set @l = @l + ' -  ' + 'REJECTED'  


if @l = ''   
select  top 1  @l  = isnull(rej.descp,'')   from demat_request_mstr   
,fn_getsubtransdtls('DEMAT_REJ_CD_NSDL')  rej where  LTRIM(RTRIM(ISNULL(DEMRM_COMPANY_OBJ,''))) = rej.cd    
and DEMRM_TRANSACTION_NO = @pa_trans_no and demrm_dpam_id  = @pa_dpam_id    
and isnull(DEMRM_COMPANY_OBJ   ,'') <> ''
and demrm_Deleted_ind = 1 

if @l <> ''    
set @l = + 'Company Objection: ' + @l 


  --SET DATEFORMAT DMY 
    
if @l =''     
select top 1  @l = citrus_usr.fn_dp57_stuff('maindesc',CDSHM_CDAS_SUB_TRAS_TYPE,'','')           
from cdsl_holding_dtls where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id   
and isnull (CDSHM_TRATM_DESC,'') <> ''        
 order by cdshm_created_dt desc--CDSHM_TRAS_DT desc      
--,CONVERT(DATETIME,LEFT(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~'),2)+'-'+SUBSTRING(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~'),3,2)+'-'+SUBSTRING(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~'),5,4)
--+' '+SUBSTRING(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~'),9,2)+':'+SUBSTRING(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~'),11,2)+':'+SUBSTRING(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~'),13,2)+'.000'
--)  DESC    
 ,cdshm_id desc          
          
return @l           
          
end

GO
