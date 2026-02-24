-- Object: PROCEDURE dbo.VoucherTypeSelect
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.VoucherTypeSelect    Script Date: 01/04/1980 1:40:44 AM ******/



/****** Object:  Stored Procedure dbo.VoucherTypeSelect    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.VoucherTypeSelect    Script Date: 11/24/2001 10:30:11 AM ******/
Create Procedure VoucherTypeSelect 
As
Select vdesc,vtype  from vmast 
where dispflag not in ('X','M')
and  vtype not in ('16','17') 
order by vdesc

GO
