-- Object: PROCEDURE dbo.foinsAcMast
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foinsAcMast    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foinsAcMast    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foinsAcMast    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foinsAcMast    Script Date: 20-Mar-01 11:38:50 PM ******/



/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/



/*THE PROCEDURE INSERTS RECORD IN ACMAST TABLE WITH THE VALUES PASSED AS PARAMETERS FROM GRPMAST FOR SUNDRY DEBITORS OR CREDITORS*/
/*THE PROCEDURE IS USED IN SUBPROCEDURE 'cmdcltsave_Click' IN BSETRADECTL CONTROL*/
/*TABLES USED:
  READONLY TABLES:account.dbo.GRPMAST
  READWRITE TABLES:account.dbo.ACMAST*/
CREATE PROC foinsAcMast(@acname CHAR(35),@Longname CHAR(60),@actyp CHAR(10),@accat CHAR(10),@familycd CHAR(10),@cltcode VARCHAR(10),@accdtls CHAR(35)) AS      
  insert into account.dbo.acmast 
    select @ACNAME,@LONGNAME,@actyp,@accat,@familycd,@cltcode ,@accdtls ,GRPCODE
    from account.dbo.grpmast
    where grpname  like 'SUNDRY DEBTORS / CREDITORS'

GO
