-- Object: PROCEDURE dbo.ITRADE_TO_NOR
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC ITRADE_TO_NOR      
(      
 @PARTY_CODE VARCHAR(20)      
)      
AS      
DECLARE @C VARCHAR(20)      
BEGIN      
SELECT @C= COUNT(1) FROM(      
select SP_Party_Code from SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UNION ALL      
select SP_Party_Code from [AngelBSECM].BSEDB_AB.dbo.SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UNION ALL      
select SP_Party_Code from [AngelFO].NSEFO.dbo.SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UNION ALL      
select SP_Party_Code from [AngelFO].NSECURFO.dbo.SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UNION ALL      
select SP_Party_Code from [AngelCommodity].MCDX.dbo.SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UNION ALL      
select SP_Party_Code from [AngelCommodity].NCDX.dbo.SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UNION ALL      
select SP_Party_Code from [AngelCommodity].BSECURFO.dbo.SCHEME_MAPPING where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
)A      
      
IF @C > 0      
BEGIN      
UPDATE A SET SP_Date_To = GETDATE()-1  from SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UPDATE A SET SP_Date_To = GETDATE()-1  from [AngelBSECM].BSEDB_AB.dbo.SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UPDATE A SET SP_Date_To = GETDATE()-1  from [AngelFO].NSEFO.dbo.SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UPDATE A SET SP_Date_To = GETDATE()-1  from [AngelFO].NSECURFO.dbo.SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UPDATE A SET SP_Date_To = GETDATE()-1  from [AngelCommodity].MCDX.dbo.SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UPDATE A SET SP_Date_To = GETDATE()-1  from [AngelCommodity].NCDX.dbo.SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
UPDATE A SET SP_Date_To = GETDATE()-1  from [AngelCommodity].BSECURFO.dbo.SCHEME_MAPPING A where SP_Party_Code = @PARTY_CODE AND SP_Date_To > GETDATE() AND SP_Computation_Level = 'O'      
END      
END

GO
