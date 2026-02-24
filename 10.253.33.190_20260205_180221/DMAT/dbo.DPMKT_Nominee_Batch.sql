-- Object: PROCEDURE dbo.DPMKT_Nominee_Batch
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [dbo].[DPMKT_Nominee_Batch]
AS
--select * from mkt_bulk_nominee where  DateOfBirth   like '%a%' or DateOfBirth   like '%e%' 
--or DateOfBirth   like '%o%' or DateOfBirth   like '%.%' or  DateOfBirth   like '%/%'

select * into #DP200 from mkt_bulk_nominee where boid like '12033200%'
select * into #DP201 from mkt_bulk_nominee where boid like '12033201%'
select * into #DP202 from mkt_bulk_nominee where boid like '12033202%'

delete from citrus_usr.dps8_pc6_tp

insert into citrus_usr.dps8_pc6_tp
Select Distinct  PurposeCode6='06',TypeOfTrans='',Title='',Name=Name,MiddleName='',SearchName=left(SearchName,20),Suffix='',FthName='',Addr1,Addr2,Addr3,City,State,Country,
PinCode,PriPhInd='',PriPhNum='',AltPhInd='',AltPhNum='',AddPhones='',Fax='',PANGIR='',ItCircle='',EMailid='', right(convert(VARCHAR,GETDATE(),112),2) + 
       substring(convert(VARCHAR,GETDATE(),112),5,2) + 
       left(convert(VARCHAR,GETDATE(),112),4) AS 
DateOfSetup ,
DateOfBirth=DateOfBirth,UsrTxt1='',UsrTxt2='',UsrFld3='',
Email='',UnqIdNum='',Filler1='',Filler2='',Filler3='',Filler4='',Filler5='',Filler6='',Filler7='',Filler8='',Filler9='',Filler10='',BOId=BOId,
TransSystemDate='',RES_SEC_FLg,NOM_Sr_No=NOM_Sr_No,rel_WITH_BO=rel_WITH_BO,
perc_OF_SHARES=perc_OF_SHARES,statecode=(case when statecode ='NEW DELHI' Then 'IN-DL'
							when statecode ='ANDAMAN & NICOBAR'Then 'IN-AN'
							When Statecode ='UTTARANCHAL' Then 'IN-UT'
							Else  csm_state_code_iso End)
							,countrycode='IN',Filler11='',Filler12='',Filler13='',Filler14='',Filler15=''
from [#DP201]
 Left outer join
 citrus_usr.cdsl_state_mstr c on  csm_state_name=statecode

 delete from  [10.253.33.189].[DMAT].[citrus_usr].[dps8_pc6_tp]

insert into  [10.253.33.189].[DMAT].[citrus_usr].[dps8_pc6_tp]
Select Distinct  PurposeCode6='06',TypeOfTrans='',Title='',Name=Name,MiddleName='',SearchName=left(SearchName,20),Suffix='',FthName='',Addr1,Addr2,Addr3,City,State,Country,
PinCode,PriPhInd='',PriPhNum='',AltPhInd='',AltPhNum='',AddPhones='',Fax='',PANGIR='',ItCircle='',EMailid='', right(convert(VARCHAR,GETDATE(),112),2) + 
       substring(convert(VARCHAR,GETDATE(),112),5,2) + 
       left(convert(VARCHAR,GETDATE(),112),4) AS 
DateOfSetup ,
DateOfBirth=DateOfBirth,UsrTxt1='',UsrTxt2='',UsrFld3='',
Email='',UnqIdNum='',Filler1='',Filler2='',Filler3='',Filler4='',Filler5='',Filler6='',Filler7='',Filler8='',Filler9='',Filler10='',BOId=BOId,
TransSystemDate='',RES_SEC_FLg,NOM_Sr_No=NOM_Sr_No,rel_WITH_BO=rel_WITH_BO,
perc_OF_SHARES=perc_OF_SHARES,statecode=(case when statecode ='NEW DELHI' Then 'IN-DL'
							when statecode ='ANDAMAN & NICOBAR'Then 'IN-AN'
							When Statecode ='UTTARANCHAL' Then 'IN-UT'
							Else  csm_state_code_iso End)
							,countrycode='IN',Filler11='',Filler12='',Filler13='',Filler14='',Filler15=''
from [#DP200]
 Left outer join
 citrus_usr.cdsl_state_mstr c on  csm_state_name=statecode
  
 delete from  [10.253.33.227].[DMAT].citrus_usr.dps8_pc6_tp
insert into  [10.253.33.227].[DMAT].[citrus_usr].[dps8_pc6_tp]
Select Distinct  PurposeCode6='06',TypeOfTrans='',Title='',Name=Name,MiddleName='',SearchName=left(SearchName,20),Suffix='',FthName='',Addr1,Addr2,Addr3,City,State,Country,
PinCode,PriPhInd='',PriPhNum='',AltPhInd='',AltPhNum='',AddPhones='',Fax='',PANGIR='',ItCircle='',EMailid='', right(convert(VARCHAR,GETDATE(),112),2) + 
       substring(convert(VARCHAR,GETDATE(),112),5,2) + 
       left(convert(VARCHAR,GETDATE(),112),4) AS 
DateOfSetup ,
DateOfBirth=DateOfBirth,UsrTxt1='',UsrTxt2='',UsrFld3='',
Email='',UnqIdNum='',Filler1='',Filler2='',Filler3='',Filler4='',Filler5='',Filler6='',Filler7='',Filler8='',Filler9='',Filler10='',BOId=BOId,
TransSystemDate='',RES_SEC_FLg,NOM_Sr_No=NOM_Sr_No,rel_WITH_BO=rel_WITH_BO,
perc_OF_SHARES=perc_OF_SHARES,statecode=(case when statecode ='NEW DELHI' Then 'IN-DL'
							when statecode ='ANDAMAN & NICOBAR'Then 'IN-AN'
							When Statecode ='UTTARANCHAL' Then 'IN-UT'
							Else  csm_state_code_iso End)
							,countrycode='IN',Filler11='',Filler12='',Filler13='',Filler14='',Filler15=''
from [#DP202]
 Left outer join
 citrus_usr.cdsl_state_mstr c on  csm_state_name=statecode

 drop table #DP200
 drop table #DP201
 drop table #DP202

 
delete from dmat.citrus_usr.client_list_modified  where clic_mod_action in ('NOMINEE1','Sub Status','SUB STATUS') and clic_mod_dpam_sba_no in (select boid from citrus_usr.dps8_pc6_tp )

delete from [10.253.33.189].[DMAT].citrus_usr.client_list_modified  where clic_mod_action in ('NOMINEE1','Sub Status','SUB STATUS') and clic_mod_dpam_sba_no in (select boid from [10.253.33.189].[DMAT].citrus_usr.dps8_pc6_tp )

delete from [10.253.33.227].[DMAT].citrus_usr.client_list_modified  where clic_mod_action in ('NOMINEE1','Sub Status','SUB STATUS') and clic_mod_dpam_sba_no in (select boid from [10.253.33.227].[DMAT].citrus_usr.dps8_pc6_tp )

GO
