-- Object: PROCEDURE dbo.rpt_accallpartyledvoucherdisp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 01/04/1980 1:40:38 AM ******/



/* report : Allpartyledger 
    filename :  voucherdisp.asp
*/
/* displays details of a voucher for a party for a date */
  
CREATE Procedure rpt_accallpartyledvoucherdisp
@vtyp smallint ,
@vno varchar (12),
@vdt varchar(12) ,
@booktype varchar(2)

as
select  vamt ,vtyp , vno , vdt , drcr , cltcode,acname,  lno ,drcrflag = (case when drcr='d' then 'Dr' else 'Cr' end) , 
nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  
				where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  
					where L.VTYP = L3.VTYP AND L.VNO = L3.VNO  AND l.lno = l3.naratno) 
		               end),'')
from account.dbo.ledger l
where vtyp=@vtyp
and vno= @vno  
and vdt like  ltrim(vdt) + '%'
and BookType = @booktype
order by drcr desc , lno

GO
