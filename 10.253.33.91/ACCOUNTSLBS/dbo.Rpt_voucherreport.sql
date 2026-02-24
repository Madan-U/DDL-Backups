-- Object: PROCEDURE dbo.Rpt_voucherreport
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Procedure Rpt_voucherreport
@Fromdt Varchar(15), 
@Todt Varchar(15), 
@Typ Int, 
@Vno Varchar(15)
As
If @Vno = '%'
Begin
If @Typ In ('2', '3', '5', '6', '7', '15', '16', '17', '19', '20', '21') 
Begin
Select Distinct L.Cltcode, Ltrim(Rtrim(L.Acname)) As Acname , L.Vno, L.Vtyp, 
Left(Convert(Varchar, L.Vdt, 109), 11) As Vdt , L1.Ddno, 
Cramt = Case When L.Drcr = 'C' Then Vamt Else 0 End, 
Dramt = Case When L.Drcr = 'D' Then Vamt Else 0 End, 
Left(Convert(Varchar, L.Edt, 109), 11) As Edt, L.Lno
From Ledger L, Ledger1 L1
Where L.Vdt > = @Fromdt 
And L.Vdt < = @Todt+' 23:59:59' 
And L.Vtyp = @Typ 
And L1.Vtyp = L.Vtyp 
And L.Vno = L1.Vno
Order By L.Vtyp, L.Vno
End
If @Typ Not In ('2', '3', '5', '6', '7', '15', '16', '17', '19', '20', '21') 
Begin
Select Distinct L.Cltcode, Ltrim(Rtrim(L.Acname)) As Acname , L.Vno, L.Vtyp, 
Left(Convert(Varchar, L.Vdt, 109), 11) As Vdt , Ddno = 0, 
Cramt = Case When L.Drcr = 'C' Then Vamt Else 0 End, 
Dramt = Case When L.Drcr = 'D' Then Vamt Else 0 End, 
Left(Convert(Varchar, L.Edt, 109), 11) As Edt, L.Lno
From Ledger L
Where L.Vdt > = @Fromdt 
And L.Vdt < = @Todt+' 23:59:59' 
And L.Vtyp = @Typ 
Order By L.Vtyp, L.Vno
End
End
If @Vno <> '%'
Begin
If @Typ In ('2', '3', '5', '6', '7', '15', '16', '17', '19', '20', '21') 
Begin
Select Distinct L.Cltcode, Ltrim(Rtrim(L.Acname)) As Acname , L.Vno, L.Vtyp, 
Left(Convert(Varchar, L.Vdt, 109), 11) As Vdt , L1.Ddno, 
Cramt = Case When L.Drcr = 'C' Then Vamt Else 0 End, 
Dramt = Case When L.Drcr = 'D' Then Vamt Else 0 End, 
Left(Convert(Varchar, L.Edt, 109), 11) As Edt, L.Lno
From Ledger L, Ledger1 L1
Where L.Vdt > = @Fromdt 
And L.Vdt < = @Todt+' 23:59:59' 
And L.Vtyp = @Typ 
And L.Vno = @Vno 
And L1.Vtyp = L.Vtyp 
And L.Vno = L1.Vno
Order By L.Vtyp, L.Vno
End
If @Typ Not In ('2', '3', '5', '6', '7', '15', '16', '17', '19', '20', '21') 
Begin
Select Distinct L.Cltcode, Ltrim(Rtrim(L.Acname)) As Acname , L.Vno, L.Vtyp, 
Left(Convert(Varchar, L.Vdt, 109), 11) As Vdt , Ddno = 0, 
Cramt = Case When L.Drcr = 'C' Then Vamt Else 0 End, 
Dramt = Case When L.Drcr = 'D' Then Vamt Else 0 End, 
Left(Convert(Varchar, L.Edt, 109), 11) As Edt, L.Lno
From Ledger L
Where L.Vdt > = @Fromdt 
And L.Vdt < = @Todt+' 23:59:59' 
And L.Vtyp = @Typ 
And L.Vno = @Vno 
Order By L.Vtyp, L.Vno
End
End

GO
