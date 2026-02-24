-- Object: PROCEDURE dbo.Acc_bankslipreprint
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/*cahnged By Amit To Display The Acname And Accode */ 
Create Proc Acc_bankslipreprint
@Cltcode  Varchar(10), 
@Booktype Varchar(2), 
@Startslip Int, 
@Endslip Int
As
/*
Select  Slipno, Ddno, Slipdate, Acname, Bnkname, Brnname, Relamt, Cltcode, L1.Vno, L1.Lno
From Ledger L , Ledger1 L1 
Where L.Vtyp = L1.Vtyp And L.Vno = L1.Vno And L.Booktype = L1.Booktype  And L.Vtyp In ( '2', '19')
And L.Booktype = @Booktype And Slipno > = @Startslip And Slipno < = @Endslip And L.Cltcode = @Cltcode
Order By Slipno, Slipdate, L1.Vno, L1.Lno
*/
Select  Slipno, Ddno, Slipdate, Acname, Bnkname, Brnname, Relamt, Cltcode, L1.Vno, L1.Lno
From Ledger L , Ledger1 L1 
Where L.Vtyp = L1.Vtyp And L.Vno = L1.Vno And L.Booktype = L1.Booktype  And L.Vtyp In ( '2', '19')
And L.Booktype = @Booktype And Slipno > = @Startslip And Slipno < = @Endslip And L.Cltcode <> @Cltcode
And L.Vno In  (Select Vno From Ledger L2 Where  Cltcode = @Cltcode And L.Vtyp = L2.Vtyp And L.Booktype = L2.Booktype )
Order By Slipno, Slipdate, L1.Vno, L1.Lno

GO
