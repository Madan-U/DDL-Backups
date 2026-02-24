-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc5
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[pr_ins_upd_dps8_pc5]
as
begin 

update s8 
	set s8.	PurposeCode5	=	b9.	PurposeCode5
,	s8.	TypeOfTrans	=	b9.	TypeOfTrans
,	s8.	MasterPOAId	=	b9.	MasterPOAId
,	s8.	POARegNum	=	b9.	POARegNum
,	s8.	SetupDate	=	b9.	SetupDate
,	s8.	GPABPAFlg	=	b9.	GPABPAFlg
,	s8.	EffFormDate	=	b9.	EffFormDate
,	s8.	EffToDate	=	b9.	EffToDate
,	s8.	Remarks	=	b9.	Remarks
,	s8.	HolderNum	=	b9.	HolderNum
,	s8.	POAStatus	=	b9.	POAStatus
,	s8.	TransSystemDate	=	b9.	TransSystemDate
from dps8_pc5 s8 , dpb9_pc5 b9 
where s8.boid = b9.boid 
and s8.MasterPOAId = b9.MasterPOAId
and s8.SetupDate	=	b9.SetupDate
and s8.POARegNum	=	b9.POARegNum
and s8.HolderNum	=	b9.HolderNum
and s8.GPABPAFlg	=	b9.GPABPAFlg

insert into dps8_pc5 (	PurposeCode5
,	TypeOfTrans
,	MasterPOAId
,	POARegNum
,	SetupDate
,	GPABPAFlg
,	EffFormDate
,	EffToDate
,	Remarks
,	HolderNum
,	POAStatus
,	BOId
,	TransSystemDate
)
select 	PurposeCode5
,	TypeOfTrans
,	MasterPOAId
,	POARegNum
,	SetupDate
,	GPABPAFlg
,	EffFormDate
,	EffToDate
,	Remarks
,	HolderNum
,	POAStatus
,	BOId
,	TransSystemDate
 from dpb9_pc5  b9 where not exists (select 1 from dps8_pc5 s8 where s8.boid = b9.boid 
and s8.MasterPOAId = b9.MasterPOAId
and s8.SetupDate	=	b9.SetupDate
and s8.POARegNum	=	b9.POARegNum
and s8.HolderNum	=	b9.HolderNum
and s8.GPABPAFlg	=	b9.GPABPAFlg)

end

GO
