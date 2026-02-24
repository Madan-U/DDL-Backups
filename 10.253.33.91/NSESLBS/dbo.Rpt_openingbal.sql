-- Object: PROCEDURE dbo.Rpt_openingbal
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure  Rpt_openingbal    
@Vdt Varchar(12),     
@Partycode Varchar(10)    
As    
Select Vdt , Vtyp, Vno, Lno, Drcr,     
Vamt, Balamt, Vdesc,     
Nar = Isnull((Case When (Select L3.Narr From Account.Dbo.Ledger3 L3  Where L.Vtyp = L3.Vtyp And L.Vno = L3.Vno And L.Lno = L3.Naratno) Is  Not Null    
           Then (Select L3.Narr From Account.Dbo.Ledger3 L3  Where L.Vtyp = L3.Vtyp And L.Vno = L3.Vno  And L.Lno = L3.Naratno)     
           Else (Select L3.Narr From Account.Dbo.Ledger3 L3  Where L.Vtyp = L3.Vtyp And L.Vno = L3.Vno And L3.Naratno = 0 )     
           End), ''),     
Edt, Edtdiff = Datediff(D, L.Edt , Getdate() )     
From Account.Dbo. Ledger L, Account.Dbo.Vmast V    
Where  Vdt  Like  Ltrim(@Vdt) + '%'  And   Vtyp = '18'    
And Cltcode = @Partycode And L.Vtyp = V.Vtype     
Order By Vdt, Drcr, Vtyp

GO
