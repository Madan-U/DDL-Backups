-- Object: PROCEDURE dbo.Rpt_accallpartyledvoucherdisp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/* Report : Allpartyledger       
    Filename :  Voucherdisp.Asp      
*/      
/* Displays Details Of A Voucher For A Party For A Date */      
--exec Rpt_accallpartyledvoucherdisp '3', '200400001901', 'May  5 2004', '41', '', '10100063'    
Create Procedure Rpt_accallpartyledvoucherdisp      
@Vtyp Smallint ,      
@Vno Varchar (12),      
@Vdt Varchar(12) ,      
@Booktype Varchar(2),      
@Branch Varchar(10),      
@Cltcode Varchar(10)      
      
As      
If @Branch = 'Full' Or @Branch = '' Or @Branch = '%'      
Begin      
 Select  Vamt , L.Vtyp , L.Vno , L.Vdt , L.Drcr , Cltcode, Acname,  L.Lno , Drcrflag = (Case When Upper(L.Drcr) = 'D' Then 'Dr' Else 'Cr' End) ,       
 Nar = Narration, Bank = Isnull(Bnkname, ''), Branch = Isnull(Brnname, '') , Isnull(Dd, '') Dd  , Isnull(Ddno, '') Ddno,       
 Dddt  =  Convert(Varchar, Dddt, 103)        
 From Account.Dbo.Ledger L Left Outer Join Account.Dbo.Ledger1 L1 On L1.Vtyp = L.Vtyp And L1.Booktype = L.Booktype And L1.Vno = L.Vno   
--and L.Lno = L1.Lno      
 Where L.Vtyp = @Vtyp      
 And L.Vno = @Vno        
 And L.Vdt Like  Ltrim(Vdt) + '%'      
 And L.Booktype = @Booktype --and L.Cltcode = @Cltcode      
 Order By L.Drcr Desc , L.Lno       
End      
Else      
Begin      
 Select  Vamt = L2.Camt , L.Vtyp , L2.Vno , Vdt , L2.Drcr , L2.Cltcode, A.Acname, L2.Lno ,       
 Drcrflag = (Case When Upper(L2.Drcr) = 'D' Then 'Dr' Else 'Cr' End),       
 Nar = Narration, Bank = Isnull(Bnkname, ''), Branch = Isnull(Brnname, '') , Isnull(Dd, '') Dd  , Isnull(Ddno, '') Ddno,       
 Dddt  =  Convert(Varchar, Dddt, 103)        
 From Account.Dbo.Ledger L Left Outer Join Account.Dbo.Ledger1 L1 On L1.Vtyp = L.Vtyp And L1.Booktype = L.Booktype And L1.Vno = L.Vno,   
--and L.Lno = L1.Lno,      
 Account.Dbo.Ledger2 L2 Left Outer Join Account.Dbo.Acmast A On L2.Cltcode = A.Cltcode      
 Where L.Vtyp = @Vtyp      
 And L.Vno = @Vno        
 And L.Vdt Like  Ltrim(Vdt) + '%'      
 And L.Booktype = @Booktype --and L.Cltcode = @Cltcode      
 And L.Vtyp = L2.Vtype And L.Booktype = L2.Booktype And L.Vno = L2.Vno And L.Lno = L2.Lno      
        And Costcode = (Select Costcode From Account.Dbo.Costmast Where Costname = Rtrim(@Branch))      
 Order By L2.Drcr Desc , L2.Lno       
End

GO
