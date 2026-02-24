-- Object: PROCEDURE dbo.getgroupdata
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.getgroupdata    Script Date: 20-Mar-01 11:43:33 PM ******/

create proc getgroupdata
as
select grpname,grpcode from grpmast where 
         grpcode like 'A0000000000' or grpcode like 'N0000000000' 
         or grpcode like 'X0000000000' or  grpcode like 'L0000000000' 
         order by grpname

GO
