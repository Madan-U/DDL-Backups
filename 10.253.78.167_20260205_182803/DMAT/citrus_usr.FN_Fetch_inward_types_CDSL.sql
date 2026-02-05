-- Object: FUNCTION citrus_usr.FN_Fetch_inward_types_CDSL
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[FN_Fetch_inward_types_CDSL]() RETURNS  TABLE     
as
RETURN(
SELECT * FROM citrus_usr.fn_getsubtransdtls('slip_TYPE_CDSL') 
UNION
select cd='REMAT',descp='REMAT'
UNION ALL
select cd='DEMAT',descp='DEMAT'
UNION ALL
select cd='PLEDGE',descp='PLEDGE'

UNION ALL
select cd='UNPLEDGE',descp='UNPLEDGE'
UNION ALL
select cd='CONFISCATE',descp='CONFISCATE'
)

GO
