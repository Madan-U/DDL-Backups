-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc18
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create  proc [citrus_usr].[pr_ins_upd_dps8_pc18]
as
begin 

update s8 
set s8.PurposeCode18=b9.PurposeCode18
,s8.TypeOfTrans=b9.TypeOfTrans
,s8.NaSeqNum=b9.NaSeqNum
,s8.BOName=b9.BOName
,s8.Remarks=b9.Remarks
--,s8.BOId=b9.BOId
--,s8.TransSystemDate=b9.TransSystemDate
,s8.Namechange=b9.Namechange
,s8.MOBILE_NO_ISD=b9.MOBILE_NO_ISD
,s8.MOBILE_NUMBER=b9.MOBILE_NUMBER
,s8.EMAILID=b9.EMAILID
,s8.uid=b9.uid
,s8.UID_FLAG=b9.UID_FLAG
,s8.FILLER1=b9.FILLER1
,s8.FILLER2=b9.FILLER2
,s8.FILLER3=b9.FILLER3
,s8.FILLER4=b9.FILLER4
,s8.FILLER5=b9.FILLER5
,s8.MIDDLE_NAME=b9.MIDDLE_NAME
,s8.LAST_NAME=b9.LAST_NAME
from dps8_pc18 s8 , dpb9_pc18 b9 
where s8.boid = b9.boid 
and s8.NaSeqNum = b9.NaSeqNum 


insert into dps8_pc18 (	PurposeCode18
,	TypeOfTrans
,	NaSeqNum
,	BOName
,	Remarks
,	BOId
,	TransSystemDate
,	Namechange
,	MOBILE_NO_ISD
,	MOBILE_NUMBER
,	EMAILID
,	uid
,	UID_FLAG
,	FILLER1
,	FILLER2
,	FILLER3
,	FILLER4
,	FILLER5
,	MIDDLE_NAME
,	LAST_NAME
)
select 	PurposeCode18
,	TypeOfTrans
,	NaSeqNum
,	BOName
,	Remarks
,	BOId
,	TransSystemDate
,	Namechange
,	MOBILE_NO_ISD
,	MOBILE_NUMBER
,	EMAILID
,	uid
,	UID_FLAG
,	FILLER1
,	FILLER2
,	FILLER3
,	FILLER4
,	FILLER5
,	MIDDLE_NAME
,	LAST_NAME
from dpb9_pc18 b9 
where not exists (select 1 from dps8_pc18 s8 where s8.boid = b9.boid 
and s8.NaSeqNum = b9.NaSeqNum ) 
end

GO
