-- Object: PROCEDURE citrus_usr.pr_get_isin
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_get_isin](@pa_cd varchar(150),@pa_desc varchar(150),@pa_bit varchar(150))
As 
Select top 1 ISIN_CD ,ISIN_NAME,isnull(CONVERT(varchar,ISIN_CONV_DT,103),'') ISIN_CONV_DT,isnull(ISIN_REG_CD,'') ISIN_REG_CD,isnull(ISIN_STATUS,'') ISIN_STATUS,isnull(ISIN_BIT,0) ISIN_BIT,isnull(isin_adr1,'') isin_adr1,
isnull(isin_adr2,'')isin_adr2,isnull(isin_adr3,'')isin_adr3,isnull(isin_adrcity,'') isin_adrcity,isnull(isin_adrstate,'') isin_adrstate,isnull(isin_adrcountry,'') isin_adrcountry,
isnull(isin_adrzip,'')isin_adrzip,isnull(isin_contactperson,'')isin_contactperson,isnull(isin_email,'') isin_email,isnull(isin_TELE,'')isin_TELE,isnull(isin_FAX,'')isin_FAX
from isin_mstr where ISIN_CD = @pa_cd 
and isin_status = 01  
and isin_bit in (0,@pa_bit)

GO
