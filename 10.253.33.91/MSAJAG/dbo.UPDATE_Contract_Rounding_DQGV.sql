-- Object: PROCEDURE dbo.UPDATE_Contract_Rounding_DQGV
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

      
CREATE proc  UPDATE_Contract_Rounding_DQGV      
      
as      
begin      
--select *       
update a set CR_Date_To = getdate()-1      
from Contract_Rounding a,CLIENT_DETAILS B      
where CR_Party_Code = party_code      
and sub_broker ='DQGV'      
AND CR_Date_To > GETDATE()      
      
--select *       
update a set CR_Date_To = getdate()-1      
from [AngelBSECM].bsedb_ab.dbo.Contract_Rounding a,CLIENT_DETAILS B      
where CR_Party_Code = party_code      
and sub_broker ='DQGV'      
AND CR_Date_To > GETDATE()      
      
--select *       
update a set CR_Date_To = getdate()-1      
from [AngelFO].nsefo.dbo.Contract_Rounding a,CLIENT_DETAILS B      
where CR_Party_Code = party_code      
and sub_broker ='DQGV'      
AND CR_Date_To > GETDATE()      
      
      
--select *       
update a set CR_Date_To = getdate()-1      
from [AngelFO].nsecurfo.dbo.Contract_Rounding a,CLIENT_DETAILS B      
where CR_Party_Code = party_code      
and sub_broker ='DQGV'      
AND CR_Date_To > GETDATE()      
      
      
--select *       
update a set CR_Date_To = getdate()-1      
from [AngelCommodity].mcdx.dbo.Contract_Rounding a,CLIENT_DETAILS B      
where CR_Party_Code = party_code      
and sub_broker ='DQGV'      
AND CR_Date_To > GETDATE()      
      
      
--select *       
update a set CR_Date_To = getdate()-1      
from [AngelCommodity].ncdx.dbo.Contract_Rounding a,CLIENT_DETAILS B      
where CR_Party_Code = party_code      
and sub_broker ='DQGV'      
AND CR_Date_To > GETDATE()      
end

GO
