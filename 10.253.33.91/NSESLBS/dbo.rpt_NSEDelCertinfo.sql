-- Object: PROCEDURE dbo.rpt_NSEDelCertinfo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE rpt_NSEDelCertinfo  
@targetid varchar(2),  
@settno varchar(7),  
@settype varchar(3),  
@scripcd varchar(20),  
@series varchar(3),  
@partycode varchar(20)  
AS  
/*   
Page name : /rootdir/backoffice/delivery/NSEDelCertinfo.asp  
shows details of the clients delivery from certinfo  
written by bhushan ghorpade on 7-sept-2000  
*/  
if @targetid = 1  
/* If the client has received shares*/  
begin  
/* select C.Sett_no,C.Sett_Type,C.Party_Code,C.Scrip_cd,C.Series,TargetParty=D.Party_Code,D.Qty,C.TransDate,C.CertNo,C.HolderName,C.FolioNo, D.TrType, D.Reason, D.CltDpId,D.DpId from DelTrans D,DelTrans C where C.sett_no = @SettNo and C.sett_type = @Setty
  
pe  
 and C.scrip_cd = @scripcd and C.series = @series and C.DrCr = 'C' and C.sett_no = D.Sett_No and C.sett_type = D.sett_type   
 and C.scrip_cd = D.scrip_cd and C.series = D.series  and C.TCode = D.TCode   
 and c.party_code = @partycode and D.DrCr = 'D'*/  
select Sett_no,Sett_Type,Party_Code,Scrip_cd,Series,Qty,TransDate,CertNo,HolderName,FolioNo,TrType,Reason,CltDpId,DpId,DpType,BCltDpId,BDpId,BDpType,Delivered,ISett_no,ISett_Type  
from DelTrans (nolock) where sett_no = @SettNo and sett_type = @Settype  
and scrip_cd = @scripcd and series = @series and DrCr = 'C'   
and party_code = @partycode and filler2 = 1   
end  
if @targetid = 2  
/* If the client has delivered shares*/  
begin  
/*  
select C.Sett_no,C.Sett_Type,C.Party_Code,C.Scrip_cd,C.Series,TargetParty=D.Party_Code,d.Qty,D.TransDate,D.CertNo,D.HolderName,D.FolioNo, D.TrType, D.Reason, D.CltDpId,D.DpId  from DelTrans D,DelTrans C where C.sett_no = @SettNo and C.sett_type = @Settype
  
  
 and C.scrip_cd = @scripcd and C.series = @series and C.DrCr = 'C' and C.sett_no = D.Sett_No and C.sett_type = D.sett_type   
 and C.scrip_cd = D.scrip_cd and C.series = D.series  and C.TCode = D.TCode   
 and D.party_code = @partycode and D.DrCr = 'D'  
*/  
select Sett_no,Sett_Type,Party_Code,Scrip_cd,Series,Qty,TransDate,CertNo,HolderName,FolioNo,TrType,  
Reason=(case When TrType = 909 Then 'DEMAT' Else Reason End),CltDpId,DpId,DpType,BCltDpId,BDpId,BDpType,Delivered,ISett_no,ISett_Type  
from DelTrans (nolock) where sett_no = @SettNo and sett_type = @Settype  
and scrip_cd = @scripcd and series = @series and DrCr = 'D'   
and party_code = @partycode and filler2 = 1   
end

GO
