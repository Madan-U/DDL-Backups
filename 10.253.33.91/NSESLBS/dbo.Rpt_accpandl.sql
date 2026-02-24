-- Object: PROCEDURE dbo.Rpt_accpandl
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_accpandl    Script Date: 01/15/2005 1:26:21 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_accpandl    Script Date: 12/16/2003 2:31:41 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.rpt_accpandl    Script Date: 06/26/2002 6:15:44 Pm ******/  
/* Ch By Mousami On 15 Apr 2002   
     Added Branch Login Effect */  
  
  
CREATE Procedure  Rpt_accpandl  
  
@fromdt Varchar(11),  
@todt Varchar(11),  
@statusid Varchar(15),  
@statusname Varchar(25)  
  
  
As  
  
If @statusid='broker'  
Begin  
 Select G1.grpname,g1.grpcode,   
 Vamt=isnull(( Select Sum(case When Drcr ='c' Then Vamt*-1 Else Vamt End )from Account.dbo.ledger L ,Account.dbo.AcMast A ,account.dbo.grpmast G   
       Where L.cltcode = A.cltcode And G.grpcode =g1.grpcode And L.vdt >= @fromdt + ' 00:00:00'  
       And L.vdt <=@todt + ' 23:59:59' And Substring(a.grpcode,1,1) = Substring(g.grpcode,1,1)),0)   
 From Account.dbo.grpmast G1   
 Where G1.grpcode='n0000000000' Or  G1.grpcode='x0000000000'   
 Order By G1.grpcode  
End  
Else  
Begin  
 Select G1.grpname,g1.grpcode,   
 Vamt=isnull(( Select Sum(case When L.drcr ='c' Then Vamt*-1 Else Vamt End )from  
  Account.dbo.ledger L ,Account.dbo.AcMast A ,account.dbo.grpmast G ,  Account.dbo.ledger2_Report L2 ,  Account.dbo.costmast C , Account.dbo.category C1  
   Where L.cltcode = A.cltcode And G.grpcode =g1.grpcode And L.vdt >= @fromdt + ' 00:00:00'  
     And L.vdt <=@todt  + ' 23:59:59'   
     And L.vno=l2.vno And L.vtyp=l2.vtype And L.lno=l2.lno And L.drcr=l2.drcr  
 And C.costcode=l2.costcode  
 And C.catcode=c1.catcode  
 And L.booktype=l2.booktype  
 And C1.category='branch'  
    And C.costname=@statusname  
  And Substring(a.grpcode,1,1) = Substring(g.grpcode,1,1)),0)   
  From Account.dbo.grpmast G1   
  Where G1.grpcode='n0000000000' Or  G1.grpcode='x0000000000'   
  Order By G1.grpcode  
End

GO
