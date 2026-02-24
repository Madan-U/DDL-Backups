-- Object: PROCEDURE dbo.foaccbilldrcrproc1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.foaccbilldrcrproc1    Script Date: 5/7/01 5:53:30 PM ******/

/****** Object:  Stored Procedure dbo.foaccbilldrcrproc1    Script Date: 4/5/01 6:44:51 PM ******/

/****** Object:  Stored Procedure dbo.foaccbilldrcrproc1    Script Date: 20-Mar-01 11:43:33 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


/* this view stores the total debit  and credit amount for each settlement no and settlement type 
used in transferbill project*/
CREATE proc foaccbilldrcrproc1
(@settno varchar(10),@setttype varchar(2),@bdate as varchar(11)) as 

select sett_no ,sett_type,sell_buy,totalamount=sum(abs(amount))  from msajag.dbo.foaccbill 
where sett_no =@settno
and sett_type =@setttype 
and left(convert(varchar,billdate,109),11)=@bdate 
group by sett_no ,sett_type,sell_buy 
order by sell_buy

GO
