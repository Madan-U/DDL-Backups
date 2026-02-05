-- Object: VIEW dbo.VW_CLIENTPOA
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE VIEW [VW_CLIENTPOA]        
AS        
        
--SELECT PARTY_CODE = NISE_PARTY_CODE,         
--CLIENT_DPID = C.CLIENT_CODE, POA_STATUS = (CASE WHEN POA_STATUS = 'D' THEN 'N' ELSE 'Y' END), POA_DATE_FROM        
--FROM TBL_CLIENT_MASTER C WITH (NOLOCK), TBL_CLIENT_POA P WITH (NOLOCK)        
--WHERE C.CLIENT_CODE = P.CLIENT_CODE     
--- ALTER AS DISCUSSED WITH ROHIT/RENIL    
    
SELECT party_code=DPAM_BBO_CODE  ,DPAM_SBA_NO CLIENT_DPID ,    
 POA_STATUS=(case when TypeOfTrans = 3 then 'N' ELSE 'Y' END),  
 (case when right(EffFormDate,4)>'2000' then  
 right (EffFormDate ,4)+ '-' +substring(EffFormDate,3,2)+'-'+ left (EffFormDate ,2)
 else  right (SetupDate ,4)+ '-' +substring(SetupDate,3,2)+'-'+ left (SetupDate ,2) end)  POA_DATE_FROM    
FROM dmat.citrus_usr.dp_acct_mstr d WITH(nolock),dmat.citrus_usr.DPS8_PC5  sd WITH(nolock)    
where DPAM_ACCT_NO <> DPAM_SBA_NO and BOID=DPAM_SBA_NO 
---and right (EffFormDate ,4)+ '-' +substring(EffFormDate,3,2)+'-'+ left (EffFormDate ,2) in ('0201-12-12','1014-12-24')
--order by EffFormDate

GO
