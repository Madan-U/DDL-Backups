-- Object: PROCEDURE dbo.CalEffectiveAmt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.CalEffectiveAmt    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE   CalEffectiveAmt   @advicedate   datetime ,
@effdate datetime,
@LimitAmt    money
 AS
 select  l.cltcode, l.acname, EffCrAmt  =  abs( balamt),
 creditAmt= isNULL( (SELECT ISNULL(SUM(VAMT),0)
   FROM LEDGER L1
   WHERE  L.CLTCODE=L1.CLTCODE  AND DRCR='C'   
    AND    EDT  > =  @effdate   
    and   vdt   <= @advicedate  ),0)
 from ledger l ,acmast a
 where   
vdt  =  (select    max(vdt)     from ledger l1 where l1.cltcode=l.cltcode 
  and  vdt  <=  @advicedate  )  
 and l.cltcode=a.cltcode and a.accat= '4'
and  l.balamt<0  
/* commented on 03/11/200
and l.acname not like  'M-%'  and  l.cltcode between '11000'  and '60000'
and l.cltcode not in ( 'CLI','30','40')*/
  and   abs( l.balamt) > = @limitamt
 order by l.cltcode,vdt,vtyp,vno1

GO
