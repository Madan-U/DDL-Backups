-- Object: PROCEDURE dbo.Acc_acwisereport
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Proc Acc_acwisereport
@Reptype Varchar(7), 
@Grplen Tinyint, 
@Grpcode Varchar(10), 
@Fdate Varchar(11), 
@Tdate Varchar(11), 
@Faccode Varchar(10), 
@Taccode Varchar(10), 
@Costcode Smallint
As
Declare 
@@Grpchars As Int
Select @@Grpchars = (Select Len(Rtrim(@Grpcode)) )
If Len(Rtrim(@Faccode)) = 0
Begin
   Select @Faccode = ( Select Min(Cltcode) From Acmast )
End
If Len(Rtrim(@Taccode)) = 0
Begin
   Select @Taccode = ( Select Max(Cltcode) From Acmast )
End
If Rtrim(@Reptype) = 'Account'
Begin
   If @Grplen = 0 
      Begin
 Select L2.Cltcode, A.Acname, Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
 From Ledger2 L2 Left Outer Join Acmast A On L2.Cltcode = A.Cltcode, Ledger L
 Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59' And Accat = 3
        And L2.Cltcode > = @Faccode And L2.Cltcode < = @Taccode
 Group By L2.Cltcode, A.Acname
 Order By L2.Cltcode, A.Acname
      End
   Else
   If @Grplen = 2
   Begin
 Select Category, Grpcode = Left(Grpcode, @Grplen), Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
 From Ledger2 L2, Ledger L, Costmast C, Category Cc
 Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
 And L2.Costcode = C.Costcode And C.Catcode = Cc.Catcode And L2.Cltcode = Rtrim(@Faccode)
 Group By Category, Left(Grpcode, @Grplen)
 Order By Category, Left(Grpcode, @Grplen)
   End
   Else
   If @Grplen = 10
      Begin
 Select L2.Costcode, Costname, Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
 From Ledger2 L2, Ledger L, Costmast C
 Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
 And L2.Costcode = C.Costcode And C.Grpcode Like Rtrim(@Grpcode)+'%'
        And L2.Cltcode > = @Faccode And L2.Cltcode < = @Taccode
 Group By L2.Costcode, Costname
 Order By L2.Costcode, Costname
      End
   Else   
      Begin
 Select Category, Grpcode = Left(Grpcode, @Grplen), Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
 From Ledger2 L2, Ledger L, Costmast C, Category Cc
 Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
 And L2.Costcode = C.Costcode And C.Catcode = Cc.Catcode And Left(Grpcode, 2) = Rtrim(@Grpcode)
 And L2.Cltcode = Rtrim(@Faccode)
 Group By Category, Left(Grpcode, @Grplen)
 Order By Category, Left(Grpcode, @Grplen)
     End
End
Else
Begin
 Select Vdate = Convert(Varchar, L.Vdt, 103) , Shortdesc, L2.Vtype, L2.Booktype, L2.Vno, L2.Lno, 
 L2.Cltcode, A.Acname, L2.Drcr, L2.Camt, L.Narration, 
 Chqno = Isnull((Select Ddno From Ledger1 L1 Where L1.Vtyp = L2.Vtype And L1.Booktype = L2.Booktype And L1.Vno = L2.Vno And L1.Lno = L2.Lno), '')
 From Ledger2 L2 Left Outer Join Acmast A On L2.Cltcode = A.Cltcode, Ledger L, Vmast V
 Where L2.Cltcode = Rtrim(@Faccode) And  L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate + ' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
 And L2.Costcode = @Costcode And L2.Vtype = V.Vtype
 Order By L2.Cltcode, A.Acname
End
/*
Else
   Begin
 Select Category, Grpcode = Left(Grpcode, @Grplen), Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
 From Ledger2 L2, Ledger L, Costmast C, Category Cc
 Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
 And L2.Costcode = C.Costcode And C.Catcode = Cc.Catcode And Left(Grpcode, 2) = Rtrim(@Grpcode)
 Group By Category, Left(Grpcode, @Grplen)
 Order By Category, Left(Grpcode, @Grplen)
   End
*/

GO
