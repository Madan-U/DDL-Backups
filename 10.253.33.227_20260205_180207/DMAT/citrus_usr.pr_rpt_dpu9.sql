-- Object: PROCEDURE citrus_usr.pr_rpt_dpu9
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_rpt_dpu9 'Jan 19 2024' , 'Jan 26 2024' , 'ho'

CREATE   proc pr_rpt_dpu9
(@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)          
AS          
BEGIN  

SELECT 
DPU9_SELLERBO [SELLER BOID]
,DPU9_SELLERPAN [SELLER PAN]
,DPU9_SELLERNAME [SELLER NAME]
,DPU9_BUYERBO [BUYER BOID]
,DPU9_BUYERPAN[BUYER PAN]
,DPU9_STATUS_ACTIVEDELINKED [STATUS] 
,substring (DPU9_SETUP_DATE,1,2) + '/' + substring (DPU9_SETUP_DATE,3,2) + '/' +  substring (DPU9_SETUP_DATE,5,4)  [SETUP DATE]
,substring (DPU9_LINK_ACTIVATED_DATE,1,2) + '/' + substring (DPU9_LINK_ACTIVATED_DATE,3,2) + '/' +  substring (DPU9_LINK_ACTIVATED_DATE,5,4)   [LINK ACTIVATION DATE]
--,DPU9_OTP_DATETIME [OTP DATETIME]
--,DPU9_OPERATOR_ID
,DPU9_SELLERPAN_EXEMPTION_FLAG [SELLER PAN EXEMPTION FLAG]
,DPU9_BUYERPAN_EXEMPTION_FLAG [BUYER PAN EXEMPTION FLAG]
,DPU9_TRANSACTIONSOURCE_CDAS_EASIEST [SOURCE]
  from dpu9_mstr 
  where  
  convert (datetime ,substring (DPU9_SETUP_DATE,1,2) + '/' + substring (DPU9_SETUP_DATE,3,2) + '/' +  substring (DPU9_SETUP_DATE,5,4),103)
  between @pa_from_dt and @pa_to_dt
  end

GO
