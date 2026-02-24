-- Object: PROCEDURE dbo.Acc_valansum
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Proc Acc_valansum  
@Branchcd As Varchar(10),   
@Opendate As Varchar(11),   
@Closdate As Varchar(11),   
@Vtyp As Varchar(2),   
@Booktype Varchar(2),   
@Vno  Varchar(12),   
@Reportoption Char(1),   
@Baloption Char(1),   
@Sortby Varchar(10)  
As  
  
Declare   
@@Opbaldt As Varchar(11),   
@@Wherepart As Varchar(200),   
@@Frompart  As Varchar(300),   
@@Selectpart As Varchar(1000),   
@@Clbalpart  As Varchar(1000),   
@@Addwhere   As Varchar(100),   
@@Orderbypart As Varchar(100)  
  
Select @@Opbaldt = (Select Left(Convert(Varchar, Isnull(Max(Vdt), 0), 109), 11) From Ledger L   
                    Where Vtyp = 18 And Vdt <= @Opendate)  
  
If @Reportoption = 'P'  
   Begin  
      Select @@Addwhere = " And A.Accat In ('4', '104')"  
   End  
Else If @Reportoption = 'O'  
   Begin  
      Select @@Addwhere = " And A.Accat Not In ('4', '104')"  
   End  
Else  
   Begin  
      Select @@Addwhere = " "  
   End  
  
If Rtrim(@Branchcd) = '%'   
   Begin  
 Select @@Selectpart = "Select L.Cltcode, A.Acname, Dramt = Isnull((Case When Upper(Drcr) = 'D' Then Vamt Else 0 End ), 0), Cramt = Isnull((Case When Upper(Drcr) = 'C' Then Vamt Else 0 End ), 0), Left(Convert(Varchar, Vdt, 103), 10) Vdt, "  
 Select @@Clbalpart = " Clbal = 0"  
 Select @@Frompart = " From Ledger L Left Outer Join Acmast A On L.Cltcode = A.Cltcode "  
 Select @@Wherepart = " Where L.Vtyp = " + @Vtyp + " And L.Booktype = '" + @Booktype + "' And L.Vno = '" + @Vno + "'"  
        If Upper(Rtrim(@Sortby)) = 'Accode'  
       Select @@Orderbypart = " Order By L.Cltcode "  
        Else If Upper(Rtrim(@Sortby)) = 'Acname'  
        Select @@Orderbypart = " Order By A.Acname "  
             Else If Upper(Rtrim(@Sortby)) = 'Drcr'  
        Select @@Orderbypart = " Order By L.Drcr "  
   End  
Else  
   Begin  
 Select @@Selectpart = " Select L2.Cltcode, A.Acname, Dramt = Isnull((Case When Upper(Drcr) = 'D' Then Camt Else 0 End ), 0), Cramt = Isnull((Case When Upper(Drcr) = 'C' Then Camt Else 0 End ), 0), "  
 Select @@Clbalpart = " Clbal =  0"  
 Select @@Frompart = " From Ledger2 L2 Left Outer Join Acmast A On L2.Cltcode = A.Cltcode, Costmast C "  
 Select @@Wherepart = " Where L2.Vtype = " + @Vtyp + " And L2.Booktype = '" + @Booktype + "' And L2.Vno = '" + @Vno + "'"  
 Select @@Addwhere = @@Addwhere + " And L2.Costcode = C.Costcode And C.Costname = '" + Rtrim(@Branchcd) + "' "  
        If Upper(Rtrim(@Sortby)) = 'Accode'  
       Select @@Orderbypart = " Order By L2.Cltcode "  
        Else If Upper(Rtrim(@Sortby)) = 'Acname'  
        Select @@Orderbypart = " Order By A.Acname "  
             Else If Upper(Rtrim(@Sortby)) = 'Drcr'  
        Select @@Orderbypart = " Order By L2.Drcr "  
   End  
  
Print @@Selectpart + @@Clbalpart + @@Frompart + @@Wherepart + @@Addwhere + @@Orderbypart  
  
Exec (@@Selectpart + @@Clbalpart + @@Frompart + @@Wherepart + @@Addwhere + @@Orderbypart )

GO
