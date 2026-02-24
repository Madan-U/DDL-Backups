-- Object: PROCEDURE dbo.PaymentCalAmt1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.PaymentCalAmt1    Script Date: 20-Mar-01 11:43:34 PM ******/

/*created on   01/12/2000
used in paymentadvice.it calculates  the balance amount and the amount to be paid to the client  */
CREATE PROCEDURE   PaymentCalAmt1   
@advicedate   datetime ,  
@tvdt datetime ,
@effdate datetime,
@LimitAmt    money
 AS
 select  l.cltcode, a.acname, EffCrAmt  =  abs(sum(CVamt) - Sum(DVamt)),
  creditAmt= isNULL( (SELECT ISNULL(SUM(VAMT),0)    
                            FROM LEDGER L1
                            WHERE  L.CLTCODE=L1.CLTCODE  AND DRCR='C'   
                            AND    EDT  > =  @effdate
                            and   vdt   <=  @advicedate ),0), 
 shortage = 0  into temppayadv
   from PartyBalAmt l ,acmast a
  where l.cltcode=a.cltcode and a.accat= '4' 
 group by l.cltcode, a.acname
 having abs(sum(DVamt) - Sum(CVamt)) > = @LimitAmt  and (sum(DVamt) - Sum(CVamt)) < 0
 order by l.cltcode 
 insert into payadv   select cltcode ,acname, @tvdt   ,effcramt - creditamt ,'',acname,'',0,effcramt,shortage  
 from temppayadv 
 where    effcramt - creditamt   > = @limitamt
 drop  table temppayadv
/*commented by sheetal */
/* used in paymentadvice.it calculates  the amount to be paid to the client  22/03/2000 */
/*
CREATE PROCEDURE   PaymentCalAmt   @advicedate   datetime ,  
@tvdt datetime ,
@effdate datetime,
@LimitAmt    money
 AS
 select  l.cltcode, l.acname, EffCrAmt  =  abs( balamt),
 creditAmt= isNULL( (SELECT ISNULL(SUM(VAMT),0)    
                                 FROM LEDGER L1
                                WHERE  L.CLTCODE=L1.CLTCODE  AND DRCR='C'   
                               AND    EDT  > =  @effdate   
                                 and   vdt   <= @advicedate  ),0), shortage = 0    into  temppayadv
  from ledger l ,acmast a
 where   
vdt  =  (select    max(vdt)     from ledger l1 where l1.cltcode=l.cltcode 
  and  vdt  <=  @advicedate  )  
 and l.cltcode=a.cltcode and a.accat= '4'
and l.balamt<0  */
/* commented on 03/11/2000
and l.acname not like  'M-%'  and  l.cltcode between '11000'  and '60000'
and l.cltcode not in ( 'CLI','30','40')*/
/*
  and   abs(balamt) > = @limitamt
 order by l.cltcode,vdt,vtyp,vno1 
select * from   temppayadv
insert into payadv   select cltcode ,acname, @tvdt   ,effcramt - creditamt ,'',acname,'',0,effcramt,shortage  from temppayadv 
where    effcramt - creditamt   > = @limitamt
drop  table temppayadv
*/

GO
