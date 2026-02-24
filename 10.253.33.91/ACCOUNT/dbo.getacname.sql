-- Object: PROCEDURE dbo.getacname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.getacname    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.getacname    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.getacname    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.getacname    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.getacname    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.getacname    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.getacname    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.getacname    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE proc getacname 
@flag smallint,
@temp varchar(20)
As
If @Flag = 5  or @flag = 1
 BEGIN
  select distinct Acname,cltcode 
   from acmast
 END
Else
If @Flag = 2
 BEGIN
  select distinct cltcode 
  from acmast  
  order by cltcode
 END
Else
If @Flag = 3
 BEGIN
  select acname from acmast 
  where  cltcode like ltrim(@temp) 
 END
Else
If @Flag = 4
 BEGIN
  select cltcode from acmast 
  where  acname = ltrim(@temp)
 End
Else 
 If @Flag = 6 
  BEGIN
   select distinct Acname,cltcode 
   from acmast where accat='2' 
   or accat='1' 
   order by cltcode
     
  END
Else 
 If @Flag = 7
  BEGIN
   select isnull(max(receiptno),0)+1 from ledger1
  END
Else 
 If @Flag = 8
  BEGIN
   select acname,bnkname,brnname,vamt,ddno from ledger l, ledger1 l1 
   where l.drcr='c' and /*l1.refno=l.refno */ l1.vtyp=l.vtyp and l1.vno=l.vno and l1.lno=l.vno and l1.drcr=l.drcr
   and ddno like '%X'  and len(ddno)>1
  END

GO
