-- Object: FUNCTION citrus_usr.gettranstype_FORTEST
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

  
CREATE function [citrus_usr].[gettranstype_FORTEST] (@pa_trans_no varchar(100),@pa_dpam_id numeric)          
returns varchar(1000)          
as  
begin          
declare @l varchar(1000)        
set @l =''    
--    
  

  
/*added by tushar on may 22 2014 by request to change by naresh sir */  
if @l = ''  
select  top 1  @l  = 'Alleged – Buy instruction mismatch.'   from cdsl_holding_dtls --, transaction_sub_type_mstr     
where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id    
and CDSHM_TRATM_CD ='4475' 
and  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,26,'~') ='A'  
group by cdshm_trans_no , cdshm_dpam_id 
having mAX(CDSHM_CDAS_SUB_TRAS_TYPE)='301'
--and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') = TRASTM_CD    
--and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') <> '0'    
--and CDSHM_CDAS_TRAS_TYPE in (6,33,32)    
--and TRASTM_TRATM_ID = 36 
   
if @l = ''   
select  top 1  @l  = isnull(TRASTM_DESC,'')   from cdsl_holding_dtls , transaction_sub_type_mstr     
where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id    
and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') = TRASTM_CD    
and citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') <> '0'    
and CDSHM_CDAS_TRAS_TYPE in (6,33,32)    
and TRASTM_TRATM_ID = 36    
  
if @l <> ''    
set @l = @l + ' -  ' + 'REJECTED'  

  
    
if @l =''     
select top 1  @l = citrus_usr.fn_dp57_stuff('maindesc',CDSHM_CDAS_SUB_TRAS_TYPE,'','')           
from cdsl_holding_dtls where cdshm_trans_no = @pa_trans_no and cdshm_dpam_id = @pa_dpam_id           
order by cdshm_created_dt desc--CDSHM_TRAS_DT desc      
--,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,42,'~') desc      
,cdshm_id desc          
          
return @l           
          
end

GO
