-- Object: PROCEDURE dbo.Acc_costaccodewisesum
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Proc Acc_costaccodewisesum
@Costcode Smallint, 
@Fdate Varchar(11), 
@Tdate Varchar(11)
As
Select L2.Costcode, Costname, L2.Cltcode, A.Acname, Bal = Sum(Case When Upper(L2.Drcr) = 'D' Then Camt Else -camt End)
From Ledger2 L2, Ledger L, Costmast C, Acmast A
Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
And L.Vdt > = @Fdate +' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
And L2.Costcode = C.Costcode And L2.Costcode = @Costcode And L2.Cltcode = A.Cltcode
Group By L2.Costcode, Costname, L2.Cltcode, A.Acname
Order By L2.Costcode, Costname, L2.Cltcode, A.Acname

GO
