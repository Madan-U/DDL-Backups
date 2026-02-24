-- Object: VIEW citrus_usr.Nominee
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE  view Nominee          
as          
--select a.* from          
--(select  * from dps8_pc6 WHERE isnull(NOM_Sr_No,'0') in ('0','1') )a          
-- inner join           
-- (select boid,max(dateofsetup) as sddate from dps8_pc6 group by boid  )b           
--on a.boid=b.boid and sddate =dateofsetup  
  
select a.* from          
(select PurposeCode6,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,Addr1,Addr2,Addr3,City,State,Country,  
PinCode,PriPhInd,PriPhNum,AltPhInd,AltPhNum,AddPhones,Fax,PANGIR,ItCircle,EMailid,  
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
then  DateOfSetup else '' end  end ),UsrTxt1,UsrTxt2,UsrFld3,Email,UnqIdNum,Filler1,Filler2,Filler3,Filler4,Filler5,  
Filler6,Filler7,Filler8,Filler9,Filler10,BOId,TransSystemDate,RES_SEC_FLg,NOM_Sr_No,rel_WITH_BO,  
perc_OF_SHARES,statecode,countrycode,Filler11,Filler12,Filler13,Filler14,Filler15   
from dps8_pc6 WHERE isnull(NOM_Sr_No,'0') in ('0','1')  )a          
-- inner join           
-- (select boid,(case when case when DateOfBirth <> ''   
--then convert(datetime,left(ltrim(rtrim( DateOfBirth)) ,2)  
--+'/'+substring(ltrim(rtrim( DateOfBirth)),3,2)+'/'+right(ltrim(rtrim( DateOfBirth)),4),103)    
--else '' end  <    'apr 01 2023' then case  
--when  DateOfBirth <> '' then  DateOfBirth else '' end     
--else case when   DateOfSetup<> ''   
--then  DateOfSetup else '' end  end ) as sddate from dps8_pc6    )b           
--on a.boid=b.boid and sddate =dateofsetup

GO
