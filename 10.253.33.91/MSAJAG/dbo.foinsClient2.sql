-- Object: PROCEDURE dbo.foinsClient2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foinsClient2    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foinsClient2    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foinsClient2    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foinsClient2    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/
/*THE PROCEDURE INSERTS RECORD IN CLIENT2 TABLE WITH THE VALUES PASSED AS PARAMETERS*/
/*THE PROCEDURE IS USED IN SUBPROCEDURE 'cmdcltsave_Click' IN BSETRADECTL CONTROL*/
/*TABLES USED:
  READONLY TABLES:
  READWRITE TABLES:CLIENT2*/
CREATE PROC foinsClient2(@CLCODE VARCHAR(6),@EXCG CHAR(3),@TRANCAT CHAR(3),@SCRIPCAT CHAR(3),@PARTYCD CHAR(6),
         @MARGIN BIT,@TTAX BIT,@STAX BIT,@INSCHRG BIT,@SERCHRG BIT,@STDRATE BIT,@PTOP INT,@TABLENO CHAR(4),@DMTABLENO CHAR(4),@subtable varchar(2)) AS                

Insert into client2 (cl_code,exchange,tran_cat ,scrip_cat,party_code,margin, turnover_tax,sebi_turn_tax ,insurance_chrg,service_chrg,std_rate,p_to_p, table_no ,demat_tableno,sub_tableno)
 values   (@CLCODE , @EXCG , @TRANCAT , @SCRIPCAT , @PARTYCD ,@MARGIN,@TTAX,@STAX,@INSCHRG,@SERCHRG,@STDRATE,@PTOP,@TABLENO,@DMTABLENO,@subtable)

GO
