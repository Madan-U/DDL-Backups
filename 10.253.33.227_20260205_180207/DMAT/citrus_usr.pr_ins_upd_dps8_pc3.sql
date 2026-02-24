-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc3
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


create proc [citrus_usr].[pr_ins_upd_dps8_pc3]
as
begin 
update s8 set 
s8.PurposeCode3=b9.PurposeCode3
,s8.TypeOfTrans=b9.TypeOfTrans
,s8.Title=b9.Title
,s8.Name=b9.Name
,s8.MiddleName=b9.MiddleName
,s8.SearchName=b9.SearchName
,s8.Suffix=b9.Suffix
,s8.FthName=b9.FthName
,s8.PANExCd=b9.PANExCd
,s8.PANGIR=b9.PANGIR
,s8.PANVerCd=b9.PANVerCd
,s8.ITCircle=b9.ITCircle
,s8.Addr1=b9.Addr1
,s8.Addr2=b9.Addr2
,s8.Addr3=b9.Addr3
,s8.City=b9.City
,s8.State=b9.State
,s8.Country=b9.Country
,s8.PinCode=b9.PinCode
,s8.DateofSetup=b9.DateofSetup
,s8.DateofBirth=b9.DateofBirth
,s8.Email=b9.Email
,s8.UniqueId=b9.UniqueId
,s8.Filler1=b9.Filler1
,s8.Filler2=b9.Filler2
,s8.Filler3=b9.Filler3
,s8.Filler4=b9.Filler4
,s8.Filler5=b9.Filler5
,s8.Filler6=b9.Filler6
,s8.Filler7=b9.Filler7
,s8.Filler8=b9.Filler8
,s8.Filler9=b9.Filler9
,s8.TransSystemDate=b9.TransSystemDate
,s8.Filler11=b9.Filler11
,s8.Filler12=b9.Filler12
,s8.Filler13=b9.Filler13
,s8.Filler14=b9.Filler14
,s8.Filler15=b9.Filler15
,s8.pri_isd=b9.pri_isd
,s8.pri_ph_no=b9.pri_ph_no
,s8.statecode=b9.statecode
,s8.countrycode=b9.countrycode
from dps8_pc3 s8 , dpb9_pc3 b9
where s8.boid = b9.boid 


insert into dps8_pc3 (	PurposeCode3
,	TypeOfTrans
,	Title
,	Name
,	MiddleName
,	SearchName
,	Suffix
,	FthName
,	PANExCd
,	PANGIR
,	PANVerCd
,	ITCircle
,	Addr1
,	Addr2
,	Addr3
,	City
,	State
,	Country
,	PinCode
,	DateofSetup
,	DateofBirth
,	Email
,	UniqueId
,	Filler1
,	Filler2
,	Filler3
,	Filler4
,	Filler5
,	Filler6
,	Filler7
,	Filler8
,	Filler9
,	BOId
,	TransSystemDate
,	Filler11
,	Filler12
,	Filler13
,	Filler14
,	Filler15
,	pri_isd
,	pri_ph_no
,	statecode
,	countrycode
)
select 	PurposeCode3
,	TypeOfTrans
,	Title
,	Name
,	MiddleName
,	SearchName
,	Suffix
,	FthName
,	PANExCd
,	PANGIR
,	PANVerCd
,	ITCircle
,	Addr1
,	Addr2
,	Addr3
,	City
,	State
,	Country
,	PinCode
,	DateofSetup
,	DateofBirth
,	Email
,	UniqueId
,	Filler1
,	Filler2
,	Filler3
,	Filler4
,	Filler5
,	Filler6
,	Filler7
,	Filler8
,	Filler9
,	BOId
,	TransSystemDate
,	Filler11
,	Filler12
,	Filler13
,	Filler14
,	Filler15
,	pri_isd
,	pri_ph_no
,	statecode
,	countrycode

from dpb9_pc3 b9 where 	 not exists(SELECT BOID FROM DPS8_PC3 s8 WHERE s8.BOID = b9.boid)   

end

GO
