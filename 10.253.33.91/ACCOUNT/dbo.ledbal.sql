-- Object: PROCEDURE dbo.ledbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ledbal    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.ledbal    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.ledbal    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.ledbal    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.ledbal    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.ledbal    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.ledbal    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.ledbal    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE ledbal
@vdt smalldatetime,
@partycode varchar(10)
 AS
select l.cltcode,amount=isnull(((select sum(l1.vamt) from ledger l1 where l1.drcr='d' and l.cltcode=l1.cltcode 
and l1.vdt <= @vdt + ' 23:59:59' 
group by l1.cltcode ,l1.drcr ) -
(select sum(l1.vamt) from ledger l1 where l1.drcr='c' and l.cltcode=l1.cltcode and l1.vdt <= @vdt + ' 23:59:59'
 group by l1.cltcode, l1.drcr)),0) from ledger l where l.vdt <= @vdt + '23:59:59' 
and l.cltcode=@partycode
group by l.cltcode

GO
