-- Object: PROCEDURE dbo.GetledgerSpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 20-Mar-01 11:43:33 PM ******/

/*Returns the details for the specified voucher type*/
/*used in Journal Entery printing*/
CREATE Proc GetledgerSpP
@vtyp smallint,
@strtdt datetime,
@enddt datetime
AS
select acname,l.vno,l.drcr,l.vamt,l.refno,l.cltcode,l.balamt,l.vdt from ledger l 
where l.vtyp = @vtyp
and VDT >= @strtdt 
and  vdt<= @enddt
order by l.refno

GO
