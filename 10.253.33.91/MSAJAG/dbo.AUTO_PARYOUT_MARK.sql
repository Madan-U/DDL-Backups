-- Object: PROCEDURE dbo.AUTO_PARYOUT_MARK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC AUTO_PARYOUT_MARK ( @PARTY_CODE VARCHAR(10),@PROCESS_FLAG VARCHAR(1),@REF_SOURCE VARCHAR(25),@PROCESS_DATE DATETIME)
AS

SET @PROCESS_DATE = GETDATE()

INSERT INTO Client_AUTO_PARYOUT_MARK (PARTY_CODE,PROCESS_FLAG,REF_SOURCE,PROCESS_DATE)
SELECT @PARTY_CODE,@PROCESS_FLAG,@REF_SOURCE,@PROCESS_DATE

Declare @Client_Status varchar(2) ,@PAYOUT_FLAG VARCHAR(10)

select @Client_Status =count(*) FROM CLIENT_BROK_DETAILS WHERE SEGMENT ='CAPITAL' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND @PARTY_CODE=CL_CODE 

IF ISNULL(@Client_Status,'0')='0'
    BEGIN 
	 Select Remark = 'Client Not Registered in EQUITY Segment'
	 Return 
    End 

IF @PROCESS_FLAG ='Y'
  BEGIN 
	 SELECT @PAYOUT_FLAG =count(*) FROM CLIENT_BROK_DETAILS WHERE SEGMENT ='CAPITAL' AND Debit_Balance ='0' AND @PARTY_CODE=CL_CODE

	 IF ISNULL(@PAYOUT_FLAG,'0') >=1
		BEGIN 
		 Select Remark = 'Shares Auto Payout Already Exist'
		 Return 
		End 
  END 

IF @PROCESS_FLAG ='N'
  BEGIN 
	 SELECT @PAYOUT_FLAG =count(*) FROM CLIENT_BROK_DETAILS WHERE SEGMENT ='CAPITAL' AND Debit_Balance ='2' AND @PARTY_CODE=CL_CODE

	 IF ISNULL(@PAYOUT_FLAG,'0') >=1
		BEGIN 
		 Select Remark = 'Shares Auto Payout Already Deactivated'
		 Return 
		End 
  END 




IF @PROCESS_FLAG ='Y'
   BEGIN 
     UPDATE C SET  Debit_Balance ='0',Modifiedon =GETDATE() ,Modifiedby =@REF_SOURCE,Imp_Status ='0'
	 FROM CLIENT_BROK_DETAILS C WHERE   CL_CODE = @PARTY_CODE AND SEGMENT ='CAPITAL'

   SELECT Remark = 'Shares Auto Payout Activated'
   Return
   END
 
IF @PROCESS_FLAG ='N'
   BEGIN 
     UPDATE C SET  Debit_Balance ='2',Modifiedon =GETDATE() ,Modifiedby =@REF_SOURCE,Imp_Status ='0'
	 FROM CLIENT_BROK_DETAILS C WHERE   CL_CODE = @PARTY_CODE AND SEGMENT ='CAPITAL'

	 SELECT Remark = 'Shares Auto Payout Deactivated'
	 Return
   END

GO
