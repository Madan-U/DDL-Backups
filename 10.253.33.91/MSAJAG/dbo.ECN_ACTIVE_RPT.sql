-- Object: PROCEDURE dbo.ECN_ACTIVE_RPT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE ECN_ACTIVE_RPT
(
@FROMDATE VARCHAR(20),
@TODATE VARCHAR(20)
)
AS 
BEGIN 
SELECT A.cl_code,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,Print_Options,repatriat_bank_ac_no,Director_name
 FROM CLIENT_DETAILS A,CLIENT_BROK_DETAILS B
WHERE A.cl_code=B.Cl_Code
AND repatriat_bank_ac_no<>''AND Director_name<>''
AND Print_Options='0'
AND Active_Date>=@FROMDATE AND Active_Date<=@TODATE
AND InActive_From>GETDATE()
ORDER BY Active_Date
END

GO
