-- Object: PROCEDURE dbo.Client_BROK_Description
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE PROC [dbo].[Client_BROK_Description] (@party_code varchar(10))
 as 
 --EXEC Client_BROK_Description 'RP61'
 SELECT upper(SP_Party_Code) Party_Code,DESCRIPTION	,Value_description,	SEGMENT,Scheme_Type,	MAX_BROK,	REMARKS,SRNO FROM (
 SELECT DISTINCT SP_Party_Code,DESCRIPTION,Value_description,SEGMENT,Scheme_Type, MAX_BROK,REMARKS,SRNO 
 FROM MAPPING_DESCRIPTION M,Scheme_Mapping S
 WHERE M.BO_ID=S.SP_Scheme_Id AND SP_Date_To >GETDATE() 
 AND SP_Party_Code =@PARTY_CODE 
 UNION
 SELECT DISTINCT SP_Party_Code,DESCRIPTION,Value_description,SEGMENT, Scheme_type,MAX_BROK,REMARKS,SRNO 
 FROM MAPPING_DESCRIPTION M,AngelBSECM.BSEDB_AB.DBO.Scheme_Mapping S
 WHERE M.BO_ID=S.SP_Scheme_Id AND SP_Date_To >GETDATE() 
 AND SP_Party_Code =@PARTY_CODE 
 UNION
  SELECT DISTINCT SP_Party_Code,DESCRIPTION,Value_description,SEGMENT, Scheme_type,MAX_BROK,REMARKS,SRNO 
 FROM MAPPING_DESCRIPTION M,ANGELFO.NSEFO.DBO.Scheme_Mapping S
 WHERE M.BO_ID=S.SP_Scheme_Id AND SP_Date_To >GETDATE() 
 AND SP_Party_Code =@PARTY_CODE 
 UNION
  SELECT DISTINCT SP_Party_Code,DESCRIPTION,Value_description,SEGMENT,Scheme_type, MAX_BROK,REMARKS,SRNO 
 FROM MAPPING_DESCRIPTION M,ANGELFO.NSECURFO.DBO.Scheme_Mapping S
 WHERE M.BO_ID=S.SP_Scheme_Id AND SP_Date_To >GETDATE() 
 AND SP_Party_Code =@PARTY_CODE 
 UNION
  SELECT DISTINCT SP_Party_Code,DESCRIPTION,Value_description,SEGMENT,Scheme_type, MAX_BROK,REMARKS,SRNO 
 FROM MAPPING_DESCRIPTION M,ANGELCOMMODITY.MCDX.DBO.Scheme_Mapping S
 WHERE M.BO_ID=S.SP_Scheme_Id AND SP_Date_To >GETDATE() 
 AND SP_Party_Code =@PARTY_CODE 


) A ORDER BY SP_Party_Code ,SRNO

GO
