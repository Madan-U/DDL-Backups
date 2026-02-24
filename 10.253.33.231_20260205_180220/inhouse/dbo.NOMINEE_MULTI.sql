-- Object: VIEW dbo.NOMINEE_MULTI
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------


  
--Altered this view under SRE-37008
    
CREATE VIEW [dbo].[NOMINEE_MULTI]    
AS    
    
Select  PurposeCode6,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,Addr1,Addr2,Addr3,City,State,    
Country,PinCode,PriPhInd,PriPhNum,AltPhInd,AltPhNum,AddPhones,Fax,PANGIR,ItCircle,EMailid,    
DateOfSetup=(case when case when DateOfBirth <> ''     
 then convert(datetime,left(ltrim(rtrim(DateOfBirth)) ,2)+'/'+substring(ltrim(rtrim(DateOfBirth)),3,2)+'/'    
 +right(ltrim(rtrim(DateOfBirth)),4),103)  else '' end  >=    'apr 01 2023'     
 then case when  DateOfBirth <>'' then DateOfBirth else ''     
 end else  case when DateOfSetup<>'' then DateOfSetup else '' end    end),    
DateOfBirth=(case when case when DateOfBirth <> ''     
then convert(datetime,left(ltrim(rtrim( DateOfBirth)) ,2)    
+'/'+substring(ltrim(rtrim( DateOfBirth)),3,2)+'/'+right(ltrim(rtrim( DateOfBirth)),4),103)      
else '' end  <    'apr 01 2023' then case    
when  DateOfBirth <> '' then  DateOfBirth else '' end       
else case when   DateOfSetup<> ''     
then  DateOfSetup else '' end  end ) ,UsrTxt1,UsrTxt2,UsrFld3,Email,UnqIdNum,Filler1,Filler2,Filler3,    
Filler4,Filler5,Filler6,Filler7,Filler8,Filler9,Filler10,BOId,TransSystemDate,RES_SEC_FLg,NOM_Sr_No,    
rel_WITH_BO,perc_OF_SHARES,statecode,countrycode,Filler11,Filler12,Filler13,Filler14,Filler15 from (    
SELECT * FROM  AGMUBODPL3.DMAT.CITRUS_USR.DPS8_PC6 WITH(NOLOCK) WHERE BOID <='1203320099999999'    
UNION ALL    
SELECT * FROM AngelDP5.DMAT.CITRUS_USR.DPS8_PC6 WITH(NOLOCK) WHERE BOID >'1203320099999999' AND BOID <='1203320199999999'    
UNION ALL    
SELECT   * FROM Angeldp202.DMAT.CITRUS_USR.DPS8_PC6 WITH(NOLOCK)  WHERE  BOID >'1203320199999999'  AND BOID <='1203320299999999'   
UNION ALL    
SELECT * FROM ABVSDP203.DMAT.CITRUS_USR.DPS8_PC6 WITH(NOLOCK)  WHERE  BOID >'1203320299999999' AND BOID <='1203320399999999'
UNION ALL    
SELECT * FROM ABVSDP204.DMAT.CITRUS_USR.DPS8_PC6 WITH(NOLOCK)  WHERE  BOID >'1203320399999999') A

GO
