-- Object: PROCEDURE dbo.Rpt_netbalancesbs
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--sp_helptext Rpt_netbalancesbs    

/****** Object:  Stored Procedure Dbo.rpt_netbalancesbs    Script Date: 01/15/2005 1:42:25 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_netbalancesbs    Script Date: 12/16/2003 2:31:55 Pm ******/  
--rpt_netBalancesBS 'Apr 1 2005','May 31 2005','A0314020000','broker','broker'
/****** Object:  Stored Procedure Dbo.rpt_netbalancesbs    Script Date: 06/26/2002 6:15:44 Pm ******/  
/* Query To Get Net Income And Expenses For The Given Period */  
/* Written On 13-06-2002 By Vns */  
/* Flag Can Have Values 'a' - For Income */  
/*                      'l' - For Expenses */  
--rpt_netBalancesBS_2 'Apr  1 2005','May 31 2005','A0307000000','broker','broker'  
CREATE Proc Rpt_netbalancesbs
@fromdt Varchar(11),  
@todt Varchar(11),  
@grpcode Varchar(11),  
@statusid Varchar(15),  
@statusname Varchar(25)  

As  
--Print len(rtrim(@grpcode))
If Len(@GrpCode) < 11
	Begin
		Select Type='G', Grp=substring(a.grpcode,1,len(rtrim(@grpcode))), Grpname=grpname, Bal= Isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0)  
		From Account.dbo.ledger L, Account.dbo.acmast A, Account.dbo.grpmast G  
		Where L.cltcode = A.cltcode And Substring(a.grpcode,1,len(rtrim(@grpcode))) = Rtrim(@grpcode)   
		And Vdt >= @fromdt + ' 00:00:00' And Vdt <= @todt + ' 23:59:59'  
		And G.grpcode = Substring(a.grpcode, 1, len(rtrim(@grpcode)))        --+ )   rtrim(@grpcode) + Right('0000000000', 11-(len(rtrim(@grpcode))+2))
		Group By Substring(a.grpcode,1,len(rtrim(@grpcode))), Grpname  
		Having Abs(isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0)) > 0  
		  
		Union All  
		  
		Select Type = 'D', Grp=l.cltcode, Grpname=l.acname, Bal= Isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0)  
		From Account.dbo.ledger L, Account.dbo.acmast A  
		Where Vdt >= @fromdt + ' 00:00:00' And Vdt <= @todt + ' 23:59:59'  
		And L.cltcode = A.cltcode And A.grpcode = @grpcode  +rtrim(right('0000000000',11-len(rtrim(@grpcode))))   
		Group By L.cltcode, L.acname  
		Having Abs(isnull(sum(case When Drcr = 'd' Then Vamt Else -vamt End),0)) > 0  
		  
		Order By Type,grp, Grpname
	End

GO
