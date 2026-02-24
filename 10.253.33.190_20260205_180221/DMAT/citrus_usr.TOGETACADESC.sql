-- Object: FUNCTION citrus_usr.TOGETACADESC
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[TOGETACADESC]  
(  
@TRANS_NO VARCHAR(100)  ,
@ISIN VARCHAR(12)
)  
 RETURNS VARCHAR(8000)  
AS  
BEGIN   
declare @l_desc varchar(8000)  
SELECT @l_desc = ACA_DESC FROM ACC_CORP_ACTION_EX WHERE  convert(varchar,DM_ORD_NO)=@TRANS_NO  
and (BASE_ISIN = @ISIN or db_ISIN = @ISIN or cr_ISIN = @ISIN)
RETURN @l_desc  
END

GO
