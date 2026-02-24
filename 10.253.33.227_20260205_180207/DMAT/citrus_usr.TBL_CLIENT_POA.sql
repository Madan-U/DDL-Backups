-- Object: VIEW citrus_usr.TBL_CLIENT_POA
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------






CREATE VIEW [citrus_usr].[TBL_CLIENT_POA]
AS
SELECT DISTINCT BOID CLIENT_CODE	
,convert(varchar(2),HolderNum )  HOLDER_INDI	
,convert(varchar(16),MasterPOAId ) MASTER_POA	
,GPABPAFlg POA_TYPE	
--,EffFormDate POA_DATE_FROM	
, right (EffFormDate ,4)+ '-' +substring(EffFormDate,3,2)+'-'+ left (EffFormDate ,2) POA_DATE_FROM
, (case when TypeOfTrans='3' then 'D' ELSE (convert(varchar(1),poastatus))  END) POA_STATUS
FROM DPS8_PC5 WHERE  RIGHT(EffFormDate,4)>1900

GO
