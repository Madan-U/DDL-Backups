-- Object: PROCEDURE dbo.Acc_costwisereport
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Proc Acc_costwisereport
@Grplen Tinyint, 
@Grpcode Varchar(10), 
@Fdate Varchar(11), 
@Tdate Varchar(11)
As
Declare 
@@Grpchars As Int
Select @@Grpchars = (Select Len(Rtrim(@Grpcode)) )
If @Grplen = 2
   Begin
 Select Category, Grpcode = Left(Grpcode, @Grplen), Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
 From Ledger2 L2, Ledger L, Costmast C, Category Cc
 Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
 And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
 And L2.Costcode = C.Costcode And C.Catcode = Cc.Catcode
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
 And L2.Costcode = C.Costcode And Left(Grpcode, @@Grpchars) = Rtrim(@Grpcode)
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
 Group By Category, Left(Grpcode, @Grplen)
 Order By Category, Left(Grpcode, @Grplen)
   End

GO
