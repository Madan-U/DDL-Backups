-- Object: VIEW dbo.Client_OtherAddress
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

Create View Client_OtherAddress
as
 select co_dpintrefno,co_cmcd,co_purposecd,co_name,co_middlename,co_searchname,co_title,co_suffix,co_fhname,co_add1,co_add2,co_add3,co_city,co_state,co_country,co_pin,co_phind1,co_tele1,co_phind2,co_tele2,co_tele3,co_fax,co_panno,co_itcircle,co_email,co_usertext1,co_usertext2,co_userfield1,co_userfield2,co_userfield3 from dmat.citrus_usr.Client_OtherAddress

GO
