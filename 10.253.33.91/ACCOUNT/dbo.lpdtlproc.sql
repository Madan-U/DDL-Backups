-- Object: PROCEDURE dbo.lpdtlproc
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.lpdtlproc    Script Date: 20-Mar-01 11:43:34 PM ******/

/*this procedure gets  phone nos, short_name and tran_cat of client */
CREATE procedure lpdtlproc @clcode varchar(6)
 as 
select c1.Res_Phone1,Off_Phone1, c1.short_name,c2.tran_cat from 
MSAJAG.DBO.client1 c1,MSAJAG.DBO.client2 c2 where c1.cl_code=@clcode
and c2.cl_code=@clcode
return

GO
