-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc8
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[pr_ins_upd_dps8_pc8]
as
begin 

update s8 
set s8.PurposeCode8=b9.PurposeCode8
,s8.TypeOfTrans=b9.TypeOfTrans
,s8.Title=b9.Title
,s8.Name=b9.Name
,s8.MiddleName=b9.MiddleName
,s8.SearchName=b9.SearchName
,s8.Suffix=b9.Suffix
,s8.FthName=b9.FthName
,s8.Addr1=b9.Addr1
,s8.Addr2=b9.Addr2
,s8.Addr3=b9.Addr3
,s8.City=b9.City
,s8.State=b9.State
,s8.Country=b9.Country
,s8.PinCode=b9.PinCode
,s8.PriPhInd=b9.PriPhInd
,s8.PriPhNum=b9.PriPhNum
,s8.AltPhInd=b9.AltPhInd
,s8.AltPhNum=b9.AltPhNum
,s8.AddPhones=b9.AddPhones
,s8.Fax=b9.Fax
,s8.PANGIR=b9.PANGIR
,s8.ItCircle=b9.ItCircle
,s8.EMailid=b9.EMailid
,s8.DateOfSetup=b9.DateOfSetup
,s8.DateOfBirth=b9.DateOfBirth
,s8.UsrTxt1=b9.UsrTxt1
,s8.UsrTxt2=b9.UsrTxt2
,s8.UsrFld3=b9.UsrFld3
,s8.Email=b9.Email
,s8.UnqIdNum=b9.UnqIdNum
,s8.Filler1=b9.Filler1
,s8.Filler2=b9.Filler2
,s8.Filler3=b9.Filler3
,s8.Filler4=b9.Filler4
,s8.Filler5=b9.Filler5
,s8.Filler6=b9.Filler6
,s8.Filler7=b9.Filler7
,s8.Filler8=b9.Filler8
,s8.Filler9=b9.Filler9
,s8.Filler10=b9.Filler10
,s8.RES_SEC_FLg=b9.RES_SEC_FLg
,s8.NOM_Sr_No=b9.NOM_Sr_No
,s8.rel_WITH_BO=b9.rel_WITH_BO
,s8.perc_OF_SHARES=b9.perc_OF_SHARES
,s8.statecode=b9.statecode
,s8.countrycode=b9.countrycode
,s8.Filler11=b9.Filler11
,s8.Filler12=b9.Filler12
,s8.Filler13=b9.Filler13
,s8.Filler14=b9.Filler14
,s8.Filler15=b9.Filler15
from dps8_pc8 s8 , dpb9_pc8 b9 
where s8.boid= b9.boid 
and s8.NOM_Sr_No = b9.nom_sr_no

insert into dps8_pc8 (	PurposeCode8
,	TypeOfTrans
,	Title
,	Name
,	MiddleName
,	SearchName
,	Suffix
,	FthName
,	Addr1
,	Addr2
,	Addr3
,	City
,	State
,	Country
,	PinCode
,	PriPhInd
,	PriPhNum
,	AltPhInd
,	AltPhNum
,	AddPhones
,	Fax
,	PANGIR
,	ItCircle
,	EMailid
,	DateOfSetup
,	DateOfBirth
,	UsrTxt1
,	UsrTxt2
,	UsrFld3
,	Email
,	UnqIdNum
,	Filler1
,	Filler2
,	Filler3
,	Filler4
,	Filler5
,	Filler6
,	Filler7
,	Filler8
,	Filler9
,	Filler10
,	BOId
,	TransSystemDate
,	RES_SEC_FLg
,	NOM_Sr_No
,	rel_WITH_BO
,	perc_OF_SHARES
,	statecode
,	countrycode
,	Filler11
,	Filler12
,	Filler13
,	Filler14
,	Filler15
)
select 	PurposeCode8
,	TypeOfTrans
,	Title
,	Name
,	MiddleName
,	SearchName
,	Suffix
,	FthName
,	Addr1
,	Addr2
,	Addr3
,	City
,	State
,	Country
,	PinCode
,	PriPhInd
,	PriPhNum
,	AltPhInd
,	AltPhNum
,	AddPhones
,	Fax
,	PANGIR
,	ItCircle
,	EMailid
,	DateOfSetup
,	DateOfBirth
,	UsrTxt1
,	UsrTxt2
,	UsrFld3
,	Email
,	UnqIdNum
,	Filler1
,	Filler2
,	Filler3
,	Filler4
,	Filler5
,	Filler6
,	Filler7
,	Filler8
,	Filler9
,	Filler10
,	BOId
,	TransSystemDate
,	RES_SEC_FLg
,	NOM_Sr_No
,	rel_WITH_BO
,	perc_OF_SHARES
,	statecode
,	countrycode
,	Filler11
,	Filler12
,	Filler13
,	Filler14
,	Filler15
from dpb9_pc8 b9
where not exists (select 1 from dps8_pc8 s8 where s8.boid = b9.boid 
and s8.NOM_Sr_No = b9.nom_sr_no ) 



end

GO
