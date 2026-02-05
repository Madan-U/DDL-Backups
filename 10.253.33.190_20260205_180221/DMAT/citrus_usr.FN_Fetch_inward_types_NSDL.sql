-- Object: FUNCTION citrus_usr.FN_Fetch_inward_types_NSDL
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

cREATE FUNCTION [citrus_usr].[FN_Fetch_inward_types_NSDL]() RETURNS  TABLE     
as
RETURN(
SELECT * FROM citrus_usr.fn_getsubtransdtls('SLIP_TYPE_NSDL')  
UNION ALL
select cd='908',descp='PLEDGE'
UNION ALL
select cd='911',descp='UNPLEDGE'
UNION ALL
select cd='910',descp='INVOKE'
)

GO
