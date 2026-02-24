-- Object: PROCEDURE dbo.USP_SaveUpdateException_T6T7
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE USP_SaveUpdateException_T6T7
@ExceptionID INT,
@AccessLevel VARCHAR(20),
@AccessCode VARCHAR(20),
@ValidFrom DATETIME,
@ValidTo DATETIME,
@Status CHAR(1),
@CreateBy VARCHAR(100),
@ModifyBy VARCHAR(100),
@Remarks VARCHAR(100),
-- @SQ_OFF_TYPE VARCHAR(100),
@statusMsg varchar(100) output
AS
BEGIN

declare @count int
exec USP_AccessCodeCheck @AccessLevel,@AccessCode,@count output
if @count =0
begin
set @statusMsg ='Entered ' + @AccessLevel + ' does not exist.'
return
end
else
begin
IF EXISTS (SELECT ExceptionID FROM SQuareUp_Exception_T6T7 WHERE ExceptionID = @ExceptionID)
BEGIN
UPDATE SQuareUp_Exception_T6T7
SET AccessLevel = @AccessLevel,
AccessCode = @AccessCode,
ValidFrom = @ValidFrom,
ValidTo = @ValidTo,
Status = @Status,
ModifyBy = @ModifyBy,
ModifyDt = getdate(),
Remarks =@Remarks,
SQ_OFF_TYPE= NULL -- @SQ_OFF_TYPE
WHERE ExceptionID = @ExceptionID

set @statusMsg = 'Updated Succesfully'
END
ELSE
BEGIN
INSERT INTO SQuareUp_Exception_T6T7(AccessLevel,AccessCode,ValidFrom,ValidTo,Status,CreateDt,CreateBy,SQ_OFF_TYPE,Remarks)
VALUES(@AccessLevel,@AccessCode,@ValidFrom,@ValidTo,@Status,getdate(),@CreateBy,NULL,@Remarks) /*@SQ_OFF_TYPE)*/

set @statusMsg = 'Inserted Succesfully'
END
end
END

GO
