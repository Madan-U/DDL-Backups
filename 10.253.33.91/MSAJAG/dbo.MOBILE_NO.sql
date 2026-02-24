-- Object: PROCEDURE dbo.MOBILE_NO
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC MOBILE_NO 
(
@CL_CODE VARCHAR (10)
)AS
BEGIN 

SELECT 
[cl_code]=@CL_CODE,
[mobile_pager]= MOBILE_PAGER
FROM Client_Details WHERE cl_code IN (@CL_CODE)
ORDER BY cl_code
END

GO
