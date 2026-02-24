-- Object: PROCEDURE dbo.Acc_valansumpartytotal
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Proc Acc_valansumpartytotal  
@Branchcd As Varchar(10),   
@Opendate As Varchar(11),   
@Closdate As Varchar(11),   
@Vtyp Smallint,   
@Booktype Varchar(2),   
@Vno  Varchar(12),   
@Reportoption Char(1),   
@Baloption Char(1),   
@Sortby Varchar(10)  
As  
If Rtrim(@Branchcd) = '%'   
   Begin  
 Select Dramt = Isnull(Sum((Case When Upper(Drcr) = 'D' Then Vamt Else 0 End )), 0),   
 Cramt = Isnull(Sum((Case When Upper(Drcr) = 'C' Then Vamt Else 0 End )), 0)   
 From Ledger L Left Outer Join Acmast A On L.Cltcode = A.Cltcode   
 Where ( A.Accat = '4'  Or A.Accat = '104' )  
 And L.Vtyp = @Vtyp And L.Booktype = @Booktype And L.Vno = @Vno   
   End  
Else  
   Begin  
 Select Dramt = Isnull(Sum((Case When Upper(Drcr) = 'D' Then Camt Else 0 End )), 0),   
 Cramt = Isnull(Sum((Case When Upper(Drcr) = 'C' Then Camt Else 0 End )), 0)   
 From Ledger2 L2 Left Outer Join Acmast A On L2.Cltcode = A.Cltcode, Costmast C   
 Where A.Accat = '4'   
 And L2.Vtype = @Vtyp And L2.Booktype = @Booktype And L2.Vno = @Vno   
 And L2.Costcode = C.Costcode And C.Costname = Rtrim(@Branchcd)  
   End

GO
