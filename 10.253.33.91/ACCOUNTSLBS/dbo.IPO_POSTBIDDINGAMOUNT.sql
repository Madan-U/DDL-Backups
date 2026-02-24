-- Object: PROCEDURE dbo.IPO_POSTBIDDINGAMOUNT
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[IPO_POSTBIDDINGAMOUNT](
           @Cltcode       VARCHAR(10),
           @Vamt          MONEY,
           @Enteredby     VARCHAR(20),
           @Acname        VARCHAR(100),
           @Narration     VARCHAR(234),
           @Sessionid     VARCHAR(100),
           @Branchname    CHAR(10),
           @Costflag      VARCHAR(1),
           @Costrowid     INT,
           @IpoCtrlCode   VARCHAR(10),
           @IpoCtrlAcname VARCHAR(100))

AS

  SET NOCOUNT ON
  
  DECLARE  @VDT       VARCHAR(11),
           @SDTCUR    VARCHAR(11),
           @LDTCUR    VARCHAR(11),
           @VNO       VARCHAR(12),
           @ENTEREDAT DATETIME
                      
  SELECT @ENTEREDAT = GETDATE()
                      
  SELECT @VDT = LEFT(GETDATE(),11),
         @SDTCUR = LEFT(SDTCUR,11),
         @LDTCUR = LEFT(LDTCUR,11)
  FROM   PARAMETER
  WHERE  GETDATE() BETWEEN SDTCUR AND LDTCUR
                                      
  CREATE TABLE #VNO (
    VNO VARCHAR(12))
  
  INSERT INTO #VNO
  EXEC ACC_GENVNO_NEW
    @VDT ,
    '55' ,
    '01' ,
    @SDTCUR ,
    @LDTCUR
    
  SELECT TOP 1 @VNO = VNO
  FROM   #VNO
         
  BEGIN TRAN
  
  EXEC NEWACMULTIINSERT
    @Vtyp = 55 ,
    @Booktype = '01' ,
    @VNO = @VNO,
    @Lno = 1 ,
    @Vdt = @VDT ,
    @Edt = @VDT ,
    @Cltcode = @Cltcode ,
    @Drcr = 'D' ,
    @Vamt = @Vamt ,
    @Enteredby = @Enteredby ,
    @Cdt = @ENTEREDAT ,
    @Checkedby = @Enteredby ,
    @Pdt = @ENTEREDAT ,
    @Acname = @Acname ,
    @Narration = @Narration ,
    @Chequeinname = '' ,
    @Chqprinted = 0 ,
    @Accat = '4' ,
    @Bnkname = '' ,
    @Brnname = '' ,
    @Dd = '' ,
    @Ddno = '' ,
    @Dddt = '' ,
    @Reldt = '' ,
    @Relamt = @Vamt ,
    @Micrno = '' ,
    @Sessionid = @Sessionid ,
    @Branchname = @Branchname ,
    @Costflag = @Costflag ,
    @Costrowid = @Costrowid ,
    @Clearingmode = '' ,
    @Emode = 'A'
             
  EXEC NEWACMULTIINSERT
    @Vtyp = 55 ,
    @Booktype = '01' ,
    @VNO = @VNO ,
    @Lno = 2 ,
    @VDT = @VDT ,
    @EDT = @VDT ,
    @Cltcode = @IpoCtrlCode ,
    @Drcr = 'C' ,
    @Vamt = @Vamt ,
    @Enteredby = @Enteredby ,
    @Cdt = @ENTEREDAT ,
    @Checkedby = @Enteredby ,
    @Pdt = @ENTEREDAT ,
    @Acname = @IpoCtrlAcname ,
    @Narration = @Narration ,
    @Chequeinname = '' ,
    @Chqprinted = 0 ,
    @Accat = '3' ,
    @Bnkname = '' ,
    @Brnname = '' ,
    @Dd = '' ,
    @Ddno = '' ,
    @Dddt = '' ,
    @Reldt = '' ,
    @Relamt = @Vamt ,
    @Micrno = '' ,
    @Sessionid = @Sessionid ,
    @Branchname = 'ALL' ,
    @Costflag = @Costflag ,
    @Costrowid = @Costrowid ,
    @Clearingmode = '' ,
    @Emode = 'A'
             
  EXEC INSERTTOLEDGER2
    @Sessionid = @Sessionid ,
    @VNO = @VNO ,
    @branchflag = '1' ,
    @costcenterflag = '1' ,
    @costenable = 'A' ,
    @statusid = 'broker' ,
    @statusname = 'broker'
                  
  DELETE FROM TEMPLEDGER2
  WHERE       SESSIONID = @Sessionid
              AND VTYPE = '55'
              AND BOOKTYPE = '01'
                             
  DELETE FROM TEMPBILLDETAILS
  WHERE       SESSIONID =@Sessionid
              AND VTYPE = '55'
              AND BOOKTYPE = '01'
                             
  COMMIT

GO
