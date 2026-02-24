-- Object: VIEW dbo.Bank_master
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE view [dbo].[Bank_master]  
as  
Select bk_id = BANK_ID, bk_micr = MICR_CODE, bk_branch = IFSC_CODE, bk_name = DP_BANK_NAME,   
bk_add1 = DP_BANK_ADDR1, bk_add2 = DP_BANK_ADDR2, bk_add3 = DP_BANK_ADDR3, bk_city = DP_BANK_CITY,  
bk_state = DP_BANK_STATE, bk_country = DP_BANK_CNTRY, bk_pin = DP_BANK_ZIP, bk_tele1 = DP_BANK_PHONE_1, bk_tele2 = DP_BANK_PHONE_2,  
bk_fax = DP_BANK_FAX, bk_email = DP_BANK_EMAIL, bk_conname = DP_BANK_CONNAME, bk_condesg = DP_BANK_CONDESG  
from Synergy_Bank_master with (nolock)

GO
