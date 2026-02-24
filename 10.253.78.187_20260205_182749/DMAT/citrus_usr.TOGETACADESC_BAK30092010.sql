-- Object: FUNCTION citrus_usr.TOGETACADESC_BAK30092010
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[TOGETACADESC_BAK30092010]  
(  
@TRANS_NO VARCHAR(100)  
)  
 RETURNS VARCHAR(8000)  
AS  
BEGIN   
declare @l_desc varchar(8000)  
SELECT @l_desc = ACA_DESC FROM ACC_CORP_ACTION_EX WHERE  convert(varchar,DM_ORD_NO)=@TRANS_NO  
RETURN @l_desc  
END

GO
