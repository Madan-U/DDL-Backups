-- Object: PROCEDURE dbo.RPT_DELHOLDMATCH_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DELHOLDMATCH_New         
( @CltDpId Varchar(16),          
  @DpId Varchar(8) )          
AS         
Create Table #Holdreco      
(       
 IsIn varchar(12),      
 Scrip_Name Varchar(50),      
 Sett_no Varchar(7),      
 Sett_type Varchar(2),      
 Scrip_cd varchar(15),      
 Qty int,      
 FreeQty int,      
 PledgeQty int,      
 HoldQty int,      
 HoldFreeQty int,      
 HoldPledgeQty int,      
 ToDayQty int      
)      

select Sett_No,Sett_Type,trtype,Scrip_Cd,Series,Certno,Qty=sum(Qty),transdate,DrCr,
BDpType,BDpId,bcltdpid,Filler2,delivered, Exchg = 'NSE'
into #del from deltrans
Where DrCr = 'D' And Filler2 = 1 And BCltDpId = @CltDpId And BDpId = @DpId  
And ShareType = 'DEMAT' 
group by Sett_No,Sett_Type,trtype,Scrip_Cd,Series,Certno,transdate,DrCr,BDpType,BDpId,bcltdpid,Filler2, delivered

insert into #del 
select Sett_No,Sett_Type,trtype,Scrip_Cd,Series,isin,sum(Qty),TrDate,DrCr='D',
BDpType,BDpId,BCltAccNo,Filler2=1,delivered = '0', Exchg = 'NSE'
from demattransben Where BCltAccNo = @CltDpId And BDpId = @DpId  
group by Sett_No,Sett_Type,trtype,Scrip_Cd,Series,isin,TrDate,BDpType,BDpId,BCltAccNo

insert into #del 
select Sett_No,Sett_Type,trtype,Scrip_Cd,Series,certno,Qty=sum(Qty),transdate,DrCr,
BDpType,BDpId,bcltdpid,Filler2,delivered, Exchg = 'BSE'
from BSEDB.DBO.deltrans
Where DrCr = 'D' And Filler2 = 1 And BCltDpId = @CltDpId And BDpId = @DpId  
And ShareType = 'DEMAT' 
group by Sett_No,Sett_Type,trtype,Scrip_Cd,Series,certno,transdate,DrCr,BDpType,BDpId,bcltdpid,Filler2, delivered

insert into #del 
select Sett_No,Sett_Type,trtype,Scrip_Cd,Series,isin, Qty=sum(Qty),TrDate,DrCr='D',
BDpType,BDpId,BCltAccNo,Filler2=1,delivered = '0', Exchg = 'BSE'
from BSEDB.DBO.demattransben Where BCltAccNo = @CltDpId And BDpId = @DpId  
group by Sett_No,Sett_Type,trtype,Scrip_Cd,Series,isin,TrDate,BDpType,BDpId,BCltAccNo

Update #del Set Scrip_Cd = M.Scrip_Cd, Series = M.Series
From MultiIsIn M
Where M.IsIn = CertNo
And M.Valid = 1 
And Exchg = 'BSE'

If (Select IsNull(Count(*),0) From DeliveryDp Where DpId = @DpId And DpCltNo = @CltDpId And Description Like '%POOL%' And DpType = 'NSDL') > 0           
Begin
Insert into #Holdreco         
Select IsIn=ISNull(CertNo,A.IsIn),Scrip_Name=S2.Scrip_cd, D.Sett_no , D.Sett_Type, Scrip_Cd=S2.Scrip_cd ,          
Qty=Sum((Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End)),          
FreeQty=Sum(Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End) ,          
PledgeQty=0,HoldQty=Isnull(CurrBal,0),          
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),          
/*ToDayQty=Sum(Case When Convert(Varchar,TransDate,106) = Convert(Varchar,GetDate(),106) And Delivered = 'G' Then Qty Else 0 End) */          
ToDayQty=Sum(Case When Convert(DateTime,Convert(Varchar,TransDate,106) + ' 23:59:59') >= GetDate() And Delivered = 'G' Then Qty Else 0 End)           
From Scrip2 S2 (nolock), #del D (nolock) Left Outer Join Rpt_DelCDSLBalance A   (nolock)        
On ( A.IsIn = CertNo AND BCltDpId = a.CltDpId And BDpId = A.DpId And A.Party_Code= D.Sett_No+D.Sett_Type)           
Where BCltDpId = @CltDpId And BDpId = @DpId         
And CertNo Like 'IN%' AND S2.Scrip_cd = D.SCRIP_CD        
AND S2.Series = D.Series AND D.FILLER2 = 1     
Group by D.Sett_no,D.Sett_Type,ISNull(CertNo,A.IsIn),S2.Scrip_CD,FreeBal,CurrBal,PledgeBal        
Having Sum(Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End) <> 0           
Or Isnull(CurrBal,0) <> 0 Or IsNull(FreeBal,0) <> 0 Or IsNull(PledgeBal,0) <> 0         
Union           
Select IsIn=A.IsIn, Scrip_Name=S2.Scrip_cd, Sett_no= Left(Party_Code,7),Sett_type= Substring(Party_code,8,9), Scrip_cd=S2.Scrip_Cd ,      
Qty=0,FreeQty=0,PledgeQty=0,HoldQty=Isnull(CurrBal,0),          
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),ToDayQty=0           
From Scrip2 S2 (nolock), Rpt_DelCDSLBalance A (nolock) Where CltDpId = @CltDpId          
And DpId = @DpId And S2.Scrip_cd = A.Scrip_Cd     
AND S2.Series = A.Series And           
A.IsIn not in ( Select Distinct CertNo From #del D where BCltDpId = a.CltDpId And           
BDpId = A.DpId And A.IsIn = CertNo         
AND Delivered <> 'D' And CertNo Like 'IN%' And A.Party_Code= D.Sett_No+D.Sett_Type )           
--Order By 2        
End          
Else          
Begin         
Insert into #Holdreco       
Select IsIn=ISNull(CertNo,A.IsIn),Scrip_Name=D.Scrip_Cd, Sett_no='NA', Sett_type='NA', Scrip_cd=D.Scrip_Cd,          
Qty=Sum((Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End)),          
FreeQty=Sum((Case When TrType <> 909 Then (Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End) Else 0 End)) ,          
PledgeQty=Sum((Case When TrType = 909 Then Qty Else 0 End)),HoldQty=Isnull(CurrBal,0),          
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),          
/*ToDayQty=Sum(Case When Convert(Varchar,TransDate,106) = Convert(Varchar,GetDate(),106) And Delivered = 'G' Then Qty Else 0 End) */          
ToDayQty=Sum(Case When  transdate >= GetDate() And Delivered IN ('G','D') Then Qty Else 0 End)           
From #del D (nolock)  Left Outer Join RPT_DelCdslBalance A    (nolock)         
On ( A.IsIn = CertNo AND BCltDpId = a.CltDpId And BDpId = A.DpId)           
Where BCltDpId = @CltDpId And BDpId = @DpId And Drcr = 'D'           
And Filler2 = 1 And CertNo Like 'IN%' And TrType <> 906              
And ( Delivered = ( Case When  transdate >= GetDate() Then 'G' Else '0' End)          
    Or Delivered = ( Case When  transdate >= GetDate() Then 'D' Else '0' End) )          
Group by ISNull(CertNo,A.IsIn),D.Scrip_CD,FreeBal,CurrBal,PledgeBal           
Having ( Sum((Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End)) <> 0           
Or Sum((Case When TrType <> 909 Then (Case When Delivered = '0' And TransDate <= GetDate() Then Qty Else 0 End) Else 0 End)) <> 0           
Or Sum((Case When TrType = 909 Then Qty Else 0 End)) <> 0           
Or Isnull(CurrBal,0) <> 0 Or IsNull(FreeBal,0) <> 0 Or IsNull(PledgeBal,0) <> 0           
Or Sum(Case When  transdate >= GetDate() And Delivered IN ('G','D') Then Qty Else 0 End) <> 0 )          
Union All          
Select IsIn=A.IsIn, Scrip_Name=IsNull(S2.Scrip_Cd,'Scrip'), Sett_no='NA', Sett_type='NA', Scrip_cd=IsNull(S2.Scrip_Cd,'Scrip'),Qty=0,FreeQty=0,PledgeQty=0,HoldQty=Isnull(CurrBal,0),          
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),ToDayQty=0           
From RPT_DelCdslBalance A (nolock)  Left Outer Join Scrip2 S2  (nolock)          
On (S2.Scrip_cd = A.Scrip_Cd And S2.Series = A.Series )           
Where CltDpId = @CltDpId          
And DpId = @DpId And           
A.IsIn not in ( Select Distinct CertNo From #del D  (nolock) where BCltDpId = a.CltDpId And           
BDpId = A.DpId And A.IsIn = CertNo           
And Drcr = 'D' And Filler2 = 1 And CertNo Like 'IN%' And TrType <> 906 
And Delivered <> 'D')           
Group by A.IsIn,IsNull(S2.Scrip_Cd,'Scrip'),FreeBal,CurrBal,PledgeBal           
Having ( Isnull(CurrBal,0) <> 0 Or IsNull(FreeBal,0) <> 0 Or IsNull(PledgeBal,0) <> 0 )          
--Order By 2           
End    

select * from #holdreco order by Scrip_Name

GO
