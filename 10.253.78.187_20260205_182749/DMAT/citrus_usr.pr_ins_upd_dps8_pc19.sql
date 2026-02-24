-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc19
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

 
create   proc [citrus_usr].[pr_ins_upd_dps8_pc19]
as
begin 

update s8 
set s8.PurposeCode19=b9.PurposeCode19
,s8.TypeOfTrans=b9.TypeOfTrans
,s8.ImageFileName=b9.ImageFileName
,s8.SigSetupDate=b9.SigSetupDate
from dps8_pc19 s8 , dpb9_pc19 b9 
where  s8.boid = b9.BOID

 
INSERT INTO DPS8_PC19 (	PurposeCode19
,	TypeOfTrans
,	ImageFileName
,	SigSetupDate
,	BOId
,	TransSystemDate
)
SELECT 	PurposeCode19
,	TypeOfTrans
,	ImageFileName
,	SigSetupDate
,	BOId
,	TransSystemDate
 
 FROM DPB9_PC19 B9 
 WHERE NOT EXISTS (SELECT 1 FROM DPS8_PC19 S8 WHERE 
  S8.BOID = B9.BOID 
)

end

GO
