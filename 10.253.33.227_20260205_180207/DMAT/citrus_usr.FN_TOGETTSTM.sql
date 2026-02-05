-- Object: FUNCTION citrus_usr.FN_TOGETTSTM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------





  

  create  FUNCTION [citrus_usr].[FN_TOGETTSTM](@PA_DESC VARCHAR(800))
RETURNS VARCHAR(800)
AS

BEGIN
DECLARE @L_VAL VARCHAR(800),@l_trantmid numeric
select @l_trantmid=trantm_id from transaction_type_mstr where trantm_code='SD'
SELECT @L_VAL=TRASTM_desc FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_TRATM_ID=@l_trantmid AND TRASTM_cd=@PA_DESC
RETURN @L_VAL
END

GO
