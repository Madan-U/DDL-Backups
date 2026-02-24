-- Object: PROCEDURE dbo.Acc_costaccodewisedtl
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Proc Acc_costaccodewisedtl
@Costcode Smallint, 
@Accode   Varchar(10), 
@Fdate Varchar(11), 
@Tdate Varchar(11)
As
Select Vdate = Convert(Varchar, L.Vdt, 103) , Shortdesc, L2.Vtype, L2.Booktype, L2.Vno, L2.Lno, 
L2.Cltcode, A.Acname, L2.Drcr, L2.Camt, L.Narration, 
Chqno = Isnull((Select Ddno From Ledger1 L1 Where L1.Vtyp = L2.Vtype And L1.Booktype = L2.Booktype And L1.Vno = L2.Vno And L1.Lno = L2.Lno), '')
From Ledger2 L2 Left Outer Join Acmast A On L2.Cltcode = A.Cltcode, Ledger L, Vmast V
Where L2.Cltcode = Rtrim(@Accode) And  L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno
And L.Vdt > = @Fdate + ' 00:00:00' And L.Vdt < = @Tdate + ' 23:59:59'
And L2.Costcode = @Costcode And L2.Vtype = V.Vtype
Order By L2.Cltcode, A.Acname

GO
