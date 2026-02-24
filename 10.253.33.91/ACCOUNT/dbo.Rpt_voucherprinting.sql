-- Object: PROCEDURE dbo.Rpt_voucherprinting
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE Proc [dbo].[Rpt_voucherprinting]
@Vtyp    Varchar(2), 
@Booktype    Varchar(2), 
@Fromdate   Varchar(11), 
@Todate   Varchar(11), 
@Vnofrom   Varchar(12), 
@Vnoto   Varchar(12)
As
Declare
 @@Selectqury   As Varchar(8000), 
 @@Fromtables   As Varchar(2000), 
 @@Wherepart    As Varchar(8000), 
 @@Sortby       As Varchar(200)
   If @Vnofrom <> '' And @Vnoto <> '' 
    Begin 
      -- Select @@Wherepart = " Where L.Vtyp = '" + @Vtyp + "'  And L.Booktype = '" + @Booktype + "'
     Select @@Wherepart = " Where L.Vtyp = '" + @Vtyp + "'  
      And L.Vno > = '" + @Vnofrom + "'  And L.Vno < = '" + @Vnoto + "'  
       And  L.Vdt > = '" + @Fromdate + " 00:00:00' And L.Vdt < = '" + @Todate +" 23:59:59' "
      
    End
   Else
    Begin
      -- Select @@Wherepart = " Where L.Vtyp = '" + @Vtyp + "'  And L.Booktype = '" + @Booktype + "'
     Select @@Wherepart = " Where L.Vtyp = '" + @Vtyp + "' 
       And  L.Vdt > = '" + @Fromdate + " 00:00:00' And L.Vdt < = '" + @Todate +" 23:59:59' "
    End       
   If @Vtyp = '2'  Or @Vtyp = '3' Or @Vtyp = '5'  Or @Vtyp = '16'  Or @Vtyp = '17'  Or @Vtyp =  '20'  Or @Vtyp = '19' Or  @Vtyp = '1' Or  @Vtyp = '4' Or  @Vtyp = '22' Or  @Vtyp = '23'  
   Begin
    Select @@Wherepart = @@Wherepart + "  And   Cltcode <> '" + @Booktype + "'" 
   End
   Else
   Begin
    Select @@Wherepart = @@Wherepart + "  And L.Booktype = '" + @Booktype + "'"
   End 
   Select @@Selectqury = " Select Distinct L.Vno, Isnull(Dd, '') Dd  , Isnull(Ddno, '') Ddno, Vamt = Isnull(L.Vamt, 0), L.Drcr, 
   Cltcode,  Acname , 
   Isnull(L.Vamt, 0) Vamt,  L.Drcr,  L.Vtyp, L.Vno, L.Lno , L.Booktype, Convert(Varchar, L.Vdt, 103) Vdt, Convert(Varchar, L.Edt, 103) Edt, 
     Bank = Isnull(Bnkname, ''), Branch = Isnull(Brnname, '') , Isnull(Dd, '') Dd  , Isnull(Ddno, '') Ddno, Dddt  =  Convert(Varchar, Dddt, 103)  , 
     L.Narration, Cltcode2 = Cltcode, Acname2 = Acname "
   Select @@Fromtables = " From Ledger L Left Outer Join Ledger1 L1 On  L.Vtyp = L1.Vtyp And L.Booktype = L1.Booktype And L.Vno = L1.Vno And L.Lno = L1.Lno "
--   Select @@Sortby = " Order By L.Vdt, L.Vtyp, L.Booktype, L.Vno, L.Drcr Desc, L.Lno Desc "
    
 Print  (@@Selectqury + @@Fromtables + @@Wherepart + @@Sortby )
Exec (@@Selectqury + @@Fromtables + @@Wherepart + @@Sortby )

GO
