-- Object: PROCEDURE dbo.BBOCodeNOTMapped
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE PROCEDURE BBOCodeNOTMapped
AS
 
select CLIENT_CODE,NISE_PARTY_CODE,status,ACTIVE_DATE,FIRST_HOLD_NAME,FIRST_HOLD_PAN  from  TBL_CLIENT_MASTER
 where RTRIM(ISNULL(NISE_PARTY_CODE,'') )like'' and STATUS !='CLOSED' and FIRST_HOLD_PAN not like '' and 
ACTIVE_DATE between '2022-07-01 00:00:00.000' and GETDATE()-3 order by ACTIVE_DATE asc

GO
