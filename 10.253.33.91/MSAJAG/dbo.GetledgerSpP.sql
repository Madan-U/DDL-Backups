-- Object: PROCEDURE dbo.GetledgerSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 2/5/01 12:06:13 PM ******/

/****** Object:  Stored Procedure dbo.GetledgerSpP    Script Date: 12/27/00 8:58:51 PM ******/

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
