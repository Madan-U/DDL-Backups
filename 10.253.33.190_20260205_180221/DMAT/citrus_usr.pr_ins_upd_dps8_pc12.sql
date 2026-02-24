-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc12
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

 
create  proc [citrus_usr].[pr_ins_upd_dps8_pc12]
as
begin 

update s8 
set s8.PurposeCode12=b9.PurposeCode12
,s8.TypeOfTrans=b9.TypeOfTrans
,s8.Addr1=b9.Addr1
,s8.Addr2=b9.Addr2
,s8.Addr3=b9.Addr3
,s8.City=b9.City
,s8.State=b9.State
,s8.Country=b9.Country
,s8.PinCode=b9.PinCode
,s8.PriPhNum=b9.PriPhNum
,s8.Fax=b9.Fax
,s8.EMailId=b9.EMailId
,s8.statecode=b9.statecode
,s8.countrycode=b9.countrycode
from dps8_pc12 s8 , dpb9_pc12 b9 
where s8.boid = b9.boid 

insert into dps8_pc12 (	PurposeCode12
,	TypeOfTrans
,	Addr1
,	Addr2
,	Addr3
,	City
,	State
,	Country
,	PinCode
,	PriPhNum
,	Fax
,	EMailId
,	BOId
,	TransSystemDate
,	statecode
,	countrycode
)
select 	PurposeCode12
,	TypeOfTrans
,	Addr1
,	Addr2
,	Addr3
,	City
,	State
,	Country
,	PinCode
,	PriPhNum
,	Fax
,	EMailId
,	BOId
,	TransSystemDate
,	statecode
,	countrycode
from dpb9_pc12 b9 where not exists (select 1 from dps8_pc12 s8 where s8.boid = b9.boid ) 

end

GO
