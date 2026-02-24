-- Object: PROCEDURE dbo.AcmastMultiCompSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 01/24/2002 12:11:25 PM ******/

/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 11/28/2001 12:23:39 PM ******/


/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 29-Sep-01 8:12:01 PM ******/

/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 7/8/01 3:22:47 PM ******/

/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.AcmastMultiCompSp    Script Date: 20-Mar-01 11:43:32 PM ******/

/*Created by vaishali  on 26/12/2000
Used in Acmastadd control to check the validity of entered account database
*/
CREATE PROCEDURE AcmastMultiCompSp 
@accdatabase as varchar(10)
 AS
select * from MSAJAG.DBO.multicompany where accountdb = @accdatabase

GO
