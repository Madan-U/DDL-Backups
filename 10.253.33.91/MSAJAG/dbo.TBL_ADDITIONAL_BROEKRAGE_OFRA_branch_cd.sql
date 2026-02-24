-- Object: PROCEDURE dbo.TBL_ADDITIONAL_BROEKRAGE_OFRA_branch_cd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc TBL_ADDITIONAL_BROEKRAGE_OFRA_branch_cd      
as       
begin      
UPDATE A SET TODATE = GETDATE()-1      
FROM TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
      
UPDATE A SET TODATE = GETDATE()-1      
FROM [AngelBSECM].bsedb_ab.dbo.TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
      
      
UPDATE A SET TODATE = GETDATE()-1      
FROM [AngelFO].nsefo.dbo.TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
      
UPDATE A SET TODATE = GETDATE()-1      
FROM [AngelFO].nsecurfo.dbo.TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
      
UPDATE A SET TODATE = GETDATE()-1      
FROM [AngelCommodity].mcdx.dbo.TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
      
UPDATE A SET TODATE = GETDATE()-1      
FROM [AngelCommodity].ncdx.dbo.TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
      
UPDATE A SET TODATE = GETDATE()-1      
FROM [AngelCommodity].BSECURFO.dbo.TBL_ADDITIONAL_BROEKRAGE A,Client_Details B      
WHERE B.branch_cd ='OFRA'      
AND TODATE > GETDATE()      
AND A.PARTY_CODE=B.party_code      
end

GO
