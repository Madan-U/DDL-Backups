-- Object: PROCEDURE dbo.Rpt_netpandl01
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_netpandl01    Script Date: 01/15/2005 1:42:26 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_netpandl01    Script Date: 12/16/2003 2:31:55 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_netpandl01    Script Date: 06/26/2002 6:15:44 Pm ******/  
/* Query To Get Net Income And Expenses For The Given Period */  
/* Written On 13-06-2002 By Vns */  
/* Flag Can Have Values 'n' - For Income */  
/*                      'x' - For Expenses */  
  
CREATE Proc Rpt_netpandl01  
@fromdt Varchar(11),  
@todt Varchar(11),  
@statusid Varchar(15),  
@statusname Varchar(25)  
  
As  
  
Select Type='g', Grp=substring(a.grpcode,1,3), Grpname=grpname, Bal=isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0), Left(a.grpcode,1)  
From Account.dbo.ledger L, Account.dbo.acmast A, Account.dbo.grpmast G  
Where L.cltcode = A.cltcode And Substring(a.grpcode,1,1) In ('n','x')  
And Vdt >= @fromdt + ' 00:00:00' And Vdt <= @todt + ' 23:59:59'  
And G.grpcode = Substring(a.grpcode,1,3)+ '00000000'  
Group By Substring(a.grpcode,1,3), Grpname, Left(a.grpcode,1)  
Having Abs(isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0)) > 0  
  
Union All  
  
Select Type = 'd', Grp=l.cltcode, Grpname=l.acname, Bal=isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0), Left(a.grpcode,1)  
From Account.dbo.ledger L, Account.dbo.acmast A  
Where Vdt >= @fromdt + ' 00:00:00' And Vdt <= @todt + ' 23:59:59'  
And L.cltcode = A.cltcode And A.grpcode In ('n0000000000', 'x0000000000')  
Group By L.cltcode, L.acname, Left(a.grpcode,1)  
Having Abs(isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0)) > 0  
Order By Grp, Grpname

GO
