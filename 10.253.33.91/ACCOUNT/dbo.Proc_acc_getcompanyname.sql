-- Object: PROCEDURE dbo.Proc_acc_getcompanyname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

Create Procedure Proc_acc_getcompanyname
 @Accounddbname Varchar (50)
As
Select * From
 Pradnya.Dbo.Multicompany
Where
 Accountdb = @Accounddbname And
 Primaryserver = 1
Order By
 Companyname

GO
