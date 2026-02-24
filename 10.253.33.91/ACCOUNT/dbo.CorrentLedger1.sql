-- Object: PROCEDURE dbo.CorrentLedger1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.CorrentLedger1    Script Date: 20-Mar-01 11:43:33 PM ******/

/* this is used to keep the consistency of the records in the ledger1 table with  respect to the related entries in ledger table (in case of bank entries)*/
CREATE PROCEDURE   CorrentLedger1
 AS
insert into ledger1 (dd ,dddt ,reldt ,refno )
select 'c', vdt ,'1900-01-01 00:00:00.000' , refno
from ledger where vtyp=2  and refno like '%c%'
and refno not in
(select refno from ledger1 )
insert into ledger1 (dd ,dddt ,reldt ,refno )
select 'c', vdt ,'1900-01-01 00:00:00.000' , refno
from ledger where vtyp= 3   and refno like '%d%'
and refno not in
(select refno from ledger1 )
insert into ledger1 (dd ,dddt ,reldt ,refno )
select 'c', vdt ,'1900-01-01 00:00:00.000' , refno
from ledger where vtyp= 5 
and refno not in
(select refno from ledger1 )

GO
