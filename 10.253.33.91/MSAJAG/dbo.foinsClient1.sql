-- Object: PROCEDURE dbo.foinsClient1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foinsClient1    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foinsClient1    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foinsClient1    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foinsClient1    Script Date: 20-Mar-01 11:38:50 PM ******/




/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/
/*THE PROCEDURE INSERTS RECORD IN CLIENT1 TABLE WITH THE VALUES PASSED AS PARAMETERS*/
/*THE PROCEDURE IS USED IN SUBPROCEDURE 'cmdcltsave_Click' IN BSETRADECTL CONTROL*/
/*TABLES USED:
  READONLY TABLES:
  READWRITE TABLES:CLIENT1*/
 
CREATE PROC foinsClient1(@CLCODE VARCHAR(6),@SNAME VARCHAR(21),@LNAME VARCHAR(50),@ADDR1 VARCHAR(40),@ADDR2 VARCHAR(40),@FAX VARCHAR(15)) AS
    
Insert client1(cl_code, short_name, Long_name ,l_address1, l_address2, confirm_fax)
    values (@CLCODE ,@SNAME ,@LNAME ,@ADDR1 ,@ADDR2 ,@FAX)

GO
