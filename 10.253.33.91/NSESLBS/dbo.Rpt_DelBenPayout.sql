-- Object: PROCEDURE dbo.Rpt_DelBenPayout
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DelBenPayout (
@BDpType Varchar(4), @BdpId Varchar(8), @BCltDpId Varchar(16), 
@FromParty Varchar(10), @ToParty Varchar(10),
@FromScrip Varchar(10), @ToScrip Varchar(10))
as     
    
Set Transaction Isolation Level Read Uncommitted    
select * into #aniled from Account.Dbo.Ledger     
Where CltCode >= @FromParty And CltCode <= @ToParty 

select * into #anipara from Account.Dbo.Parameter     
    
Select A.CltCode,Amount=Sum(A.Credit)-Sum(A.Debit), PayFlag=0 
Into #DelAccBalance
From (    
select CltCode,Debit=(Case When L.DrCr = 'D' Then Sum(Vamt) Else 0 end),    
Credit=(Case When L.DrCr = 'C' Then Sum(Vamt) Else 0 end) from #aniled L, #anipara    
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'    
And Edt >= SdtCur And CurYear = 1     
Group by CltCode,L.DrCr ) A     
Group by A.CltCode    
    
Update #DelAccBalance Set Amount = 0, PayFlag=1 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 1 )    
Update #DelAccBalance Set Amount = -1, PayFlag=2 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 2 )  

select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name=IsNull(Introducer,''),TrType,
D.DpType,CltDpId,D.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=IsNull(Amount,0),
ISett_No,Isett_Type,Sett_no='',Sett_Type='' 
from MultiCltId M, DelTrans D Left Outer Join #DelAccBalance A 
On ( A.CltCode = D.Party_Code ) where TrType In (904,905)
and D.Party_code = M.Party_code and M.DpId = D.DpId 
And M.CltDpNo = D.CltDpId And M.DpType = D.DpType
And Delivered = '0' And D.Party_Code <> 'BROKER'
And BDpType = @BDpType And BDpId = @BDpId
and BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip
Group by D.Scrip_cd,D.Series,D.Party_Code,IsNull(Introducer,''),TrType,CltDpId,D.DpId, 
CertNo, bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,D.DpType 
order by D.DpType,D.Party_Code,D.Scrip_Cd,ISett_No,ISett_Type

GO
