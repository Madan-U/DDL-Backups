-- Object: PROCEDURE dbo.BRANCH_SSRS_RPT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE BRANCH_SSRS_RPT
(
@BRANCH_CODE VARCHAR(20)
)
AS BEGIN



SELECT A.CL_cODE,long_name,branch_cd,sub_broker,REGION,EXCHANGE,Segment,Active_Date,InActive_From,
(CASE WHEN InActive_From >GETDATE() THEN 'ACTIVE'ELSE 'INACTIVE'END)AS STATUS
,Deactive_Remarks,Deactive_value FROM CLIENT_DETAILS A,CLIENT_BROK_DETAILS B
WHERE A.cl_code=B.Cl_Code
AND branch_cd=@BRANCH_CODE
ORDER BY CL_cODE
END

GO
