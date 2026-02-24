-- Object: PROCEDURE dbo.SCHEME_MAP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
--EXCHANGE SEGMENT  
--MCD FUTURE  
--NSEFO FUTURE  
--MCX FUTURE  
--NSX FUTURE  
  
  
  
CREATE PROC [dbo].[SCHEME_MAP]  
  
AS  
  

  
  
SELECT S.* INTO #SCHEME_MAPPING_CI  FROM SCHEME_MAPPING_CI S,CLIENT_BROK_DETAILS D WHERE  VALID =0  
AND SP_PARTY_CODE=CL_CODE AND REPLACE(REPLACE(REPLACE(S.EXCHANGE,'NSEFO','NSE'),'NCDX','NCX'),'BSEFO','BSE')=D.EXCHANGE AND S.SEGMENT+'S' =D.SEGMENT
AND FUT_BROK NOT IN (SELECT DISTINCT TABLE_NO FROM BROKTABLE  WITH(NOLOCK) WHERE TABLE_NAME LIKE '%VBB%' OR TABLE_NAME LIKE '%PLUS%')   
  
--SELECT DISTINCT EXCHANGE,SEGMENT FROM SCHEME_MAPPING_CI WHERE SP_PARTY_CODE ='A97311'  
/** ADDED FOR REMOVAL OF DUPLICATION OF ENTRY **/  
UPDATE C SET VALID=1 FROM  
#SCHEME_MAPPING_CI  C ,angelfo.NSEFO.DBO.SCHEME_MAPPING F  
WHERE C.SP_Party_Code =F.SP_PARTY_CODE  
AND C.SP_Scrip=F.SP_SCRIP   
AND EXCHANGE ='NSEFO' AND SEGMENT='FUTURE' AND VALID =0  
  
UPDATE C SET VALID=1 FROM  
#SCHEME_MAPPING_CI  C ,angelfo.NSECURFO.DBO.SCHEME_MAPPING F  
WHERE C.SP_Party_Code =F.SP_PARTY_CODE  
AND C.SP_Scrip=F.SP_SCRIP   
AND EXCHANGE ='NSX' AND SEGMENT='FUTURE' AND VALID =0  
  
  
UPDATE C SET VALID=1 FROM  
#SCHEME_MAPPING_CI  C ,ANGELCOMMODITY.MCDX.DBO.SCHEME_MAPPING F  
WHERE C.SP_Party_Code =F.SP_PARTY_CODE  
AND C.SP_Scrip=F.SP_SCRIP   
AND EXCHANGE ='MCX' AND SEGMENT='FUTURE' AND VALID =0  
  
  
UPDATE C SET VALID=1 FROM  
#SCHEME_MAPPING_CI  C ,ANGELCOMMODITY.NCDX.DBO.SCHEME_MAPPING F  
WHERE C.SP_Party_Code =F.SP_PARTY_CODE  
AND C.SP_Scrip=F.SP_SCRIP   
AND EXCHANGE ='NCDX' AND SEGMENT='FUTURE' AND VALID =0  

UPDATE C SET VALID=1 FROM  
#SCHEME_MAPPING_CI  C ,ANGELCOMMODITY.BSEFO.DBO.SCHEME_MAPPING F  
WHERE C.SP_Party_Code =F.SP_PARTY_CODE  
AND C.SP_Scrip=F.SP_SCRIP   
AND EXCHANGE ='BSEFO' AND SEGMENT='FUTURE' AND VALID =0  


  
/***COMPLETED***/   
      
SET XACT_ABORT ON    
INSERT INTO angelfo.NSEFO.DBO.SCHEME_MAPPING  
(SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn)  
SELECT DISTINCT SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn  
FROM #SCHEME_MAPPING_CI  
WHERE EXCHANGE ='NSEFO' AND SEGMENT='FUTURE' AND VALID =0  
  
   
  
 --UPDATE SCHEME_MAPPING_CI  SET VALID =1 WHERE EXCHANGE ='NSEFO' AND SEGMENT='FUTURE' AND VALID =0  
  
       
SET XACT_ABORT ON    
  
INSERT INTO ANGELFO.NSECURFO.DBO.SCHEME_MAPPING  
(SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn)  
SELECT DISTINCT SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn  
FROM #SCHEME_MAPPING_CI  
WHERE EXCHANGE ='NSX' AND SEGMENT='FUTURE' AND VALID =0  
  
   
  
--UPDATE SCHEME_MAPPING_CI  SET VALID =1 WHERE EXCHANGE ='NSX' AND SEGMENT='FUTURE' AND VALID =0  
  
       
SET XACT_ABORT ON    
  
INSERT INTO ANGELCOMMODITY.MCDX.DBO.SCHEME_MAPPING  
(SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn)  
  
SELECT DISTINCT SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn  
FROM #SCHEME_MAPPING_CI  
WHERE EXCHANGE ='MCX' AND SEGMENT='FUTURE' AND VALID =0  
  
   
  
--UPDATE SCHEME_MAPPING_CI  SET VALID =1 WHERE EXCHANGE ='MCX' AND SEGMENT='FUTURE' AND VALID =0  
  
   
      
SET XACT_ABORT ON    
INSERT INTO ANGELCOMMODITY.NCDX.DBO.SCHEME_MAPPING  
(SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn)  
  
SELECT DISTINCT SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn  
FROM #SCHEME_MAPPING_CI  
WHERE EXCHANGE ='NCX' AND SEGMENT='FUTURE' AND VALID =0  
  
   
  
--UPDATE SCHEME_MAPPING_CI  SET VALID =1 WHERE EXCHANGE ='NCDX' AND SEGMENT='FUTURE' AND VALID =0  
  
  
  
      
SET XACT_ABORT ON    
  
INSERT INTO ANGELCOMMODITY.MCDXCDS.DBO.SCHEME_MAPPING  
(SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn)  
  
SELECT DISTINCT SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_TurnOverOn,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn  
FROM #SCHEME_MAPPING_CI  
WHERE EXCHANGE ='MCD' AND SEGMENT='FUTURE' AND VALID =0  
  
   
  
--UPDATE SCHEME_MAPPING_CI  SET VALID =1 WHERE EXCHANGE ='MCD' AND SEGMENT='FUTURE' AND VALID =0  
  
        
SET XACT_ABORT ON  

INSERT INTO ANGELCOMMODITY.BSEFO.DBO.SCHEME_MAPPING  
(SP_Party_Code,SP_Computation_Level,SP_Product_Type,SP_Product_Code,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,
SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,SP_Value_To,SP_Brok_ComputeOn,SP_Brok_ComputeType,
SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,
SP_ModifiedOn,SP_TurnOverOn,Sp_Scrip)  
  
SELECT SP_Party_Code,SP_Computation_Level,SP_Inst_Type,SP_Scrip,SP_Scheme_Id,SP_Trd_Type,SP_Scheme_Type,SP_Multiplier,  
SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,  
SP_Value_To,SP_Brok_ComputeOn,SP_Brok_ComputeType,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,  
SP_Date_From,SP_Date_To,SP_CreatedBy,SP_CreatedOn,SP_ModifiedBy,SP_ModifiedOn,SP_TurnOverOn,''  
FROM #SCHEME_MAPPING_CI  
WHERE EXCHANGE ='BSEFO' AND SEGMENT='FUTURE' AND VALID =0  

   
  
--UPDATE SCHEME_MAPPING_CI  SET VALID =1 WHERE EXCHANGE ='BSEFO' AND SEGMENT='FUTURE' AND VALID =0  
  
UPDATE F   SET VALID =1   
FROM #SCHEME_MAPPING_CI S ,SCHEME_MAPPING_CI F WHERE S.SP_Party_Code =F.SP_Party_Code   
AND S.EXCHANGE =F.EXCHANGE AND S.SEGMENT =F.SEGMENT    
AND F.VALID =0  
  
   
  

  
 EXEC MSAJAG.DBO.SCHEME_MAP_NEW ---FOR ALL SEGMENT

GO
