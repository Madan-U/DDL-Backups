-- Object: FUNCTION citrus_usr.TO_DEC
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--SELECT  ILFS.citrus_usr.TO_DEC('11111111111111111111111111111111',2) 
CREATE function [citrus_usr].[TO_DEC](@P_STR        VARCHAR(8000)  
                      ,@P_FROM_BASE  NUMERIC = 16  
                      )  
RETURNS NUMERIC  
AS  
/*******************************************************************************  
 SYSTEM         : CLASS  
 MODULE NAME    : TO_DEC  
 DESCRIPTION    :  
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.  
 VERSION HISTORY:  
 VERS.  AUTHOR             DATE         REASON  
 -----  -------------      ----------   ------------------------------------------------  
 1.0    SUKHVINDER/TUSHAR  07-JAN-2007  INITIAL VERSION.  
**********************************************************************************/  
BEGIN  
--  
  DECLARE @@L_NUM  BIGINT 
         ,@@L_HEX  VARCHAR(16)  
         ,@@I      INT  
  --  
  SET @@L_NUM  = 0  
  SET @@L_HEX  = '0123456789ABCDEF'  
  SET @@i  = 1  
  --  
  IF (@P_STR = '') OR (@P_FROM_BASE = null)  
  BEGIN  
  --  
    RETURN NULL  
  --  
  END  
  ELSE  
  BEGIN  
  --  
    WHILE @@I <= CONVERT(INT, LEN(@P_STR))  
    BEGIN  
    --  
      SET @@L_NUM = (@@L_NUM * (@P_FROM_BASE)) + PATINDEX('%' + SUBSTRING(@P_STR ,  CONVERT(INT, @@I), 1)  +  '%',  @@L_HEX)-1  
      SET @@I = @@I + 1  
    --  
    END  
  --  
  END  
  --  
  RETURN @@L_NUM  
--  
END

GO
