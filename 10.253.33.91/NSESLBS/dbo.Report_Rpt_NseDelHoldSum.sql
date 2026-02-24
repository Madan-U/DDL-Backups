-- Object: PROCEDURE dbo.Report_Rpt_NseDelHoldSum
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE Proc Report_Rpt_NseDelHoldSum (
@StatusId Varchar(15),@StatusName Varchar(25),@HoldDate varchar(11),@BDpID Varchar(8),@BCltDpID Varchar(16))
AS
Set Transaction Isolation level read uncommitted
truncate table DelHold
Insert Into DelHold 
select Sett_No, Sett_type, TCode, Party_Code,scrip_cd , series, certno, Qty, Transno = FolioNo, DrCr, TransDate,Reason=(Case When TrType = 909 Then 'Pledge' Else 'Holding' End),CltDpId,DpID, @BDpId, @BcltDpID 
From Deltrans_Report where BCltDpId like @BCltDpID And BDpId Like @BDpID
And DrCr = 'D' And Filler2 = 1 And Delivered = '0'
And TransDate < @HoldDate + ' 23:59' And TrType <> 906
Union All 
select Sett_No, Sett_type, TCode, Party_Code,scrip_cd , series, certno, Qty, Transno = FolioNo, DrCr, TransDate=@HoldDate,Reason=(Case When TrType = 909 Then 'Pledge' Else 'Holding' End),CltDpId,DpID, @BDpId, @BcltDpID 
From Deltrans_Report where BCltDpId like @BCltDpID And BDpId Like @BDpID
And DrCr = 'D' And Filler2 = 1 and Delivered = 'D' 
And TransDate > @HoldDate + ' 23:59' And TrType <> 906
/*
Union All
select Sett_No, Sett_type, TCode, Party_Code, scrip_cd , series, certno, Qty, Transno = FolioNo, DrCr, TransDate,Reason=(Case When TrType = 909 Then 'Pledge' Else 'Holding' End),CltDpId,DpID, @BDpId, @BcltDpID 
From Deltrans_Report d where BCltDpId Not like @BCltDpID And BDpId Not Like @BDpID
And DrCr = 'D' And Filler2 = 0 and Delivered in ('G','D')
And TransDate < @HoldDate And TrType <> 906
And ( TCode in ( select TCode From Deltrans_Report d1 where 
DrCr = 'D' And Filler2 = 1 And TransDate > @HoldDate
And BCltDpId like @BCltDpID And BDpId Like @BDpID And Scrip_Cd Like d.scrip_cd and D.Party_Code = Party_Code) Or TCode = 0 ) 
*/

if @statusid = 'broker'
begin
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelHold 
where BDpId = @BDpId and BCltDpId = @BCltDpId 
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0 
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type 
End
if @statusid = 'branch'
begin
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelHold D,Client1_Report C1,Client2_Report C2, branches br  
where BDpId = @BDpId and BCltDpId = @BCltDpId 
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
and br.short_name = c1.trader and br.branch_cd = @statusname
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0 
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type 
End
if @statusid = 'subbroker'
begin
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelHold D,Client1_Report C1,Client2_Report C2, subbrokers sb 
where BDpId = @BDpId and BCltDpId = @BCltDpId 
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0 
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type 
End
if @statusid = 'trader'
begin
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelHold D,Client1_Report C1,Client2_Report C2
where BDpId = @BDpId and BCltDpId = @BCltDpId 
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
and c1.trader = @statusname
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0 
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type 
End
if @statusid = 'client'
begin
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelHold D,Client1_Report C1,Client2_Report C2
where BDpId = @BDpId and BCltDpId = @BCltDpId 
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
and c2.party_code = @statusname
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0 
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type 
End
if @statusid = 'family'
begin
select scrip_cd, series,CertNo ,Sett_No, Sett_type,QTy=Sum(Qty) from DelHold D,Client1_Report C1,Client2_Report C2
where BDpId = @BDpId and BCltDpId = @BCltDpId 
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
and c1.family = @statusname
group by scrip_cd, series, certno , Sett_No, Sett_type having Sum(Qty) > 0 
Order By Scrip_Cd,Series,certno,sett_no,Sett_Type 
End

GO
