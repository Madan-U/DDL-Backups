-- Object: PROCEDURE dbo.add_area_UsingExists
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE add_area_UsingExists
(
      @area_code  varchar(20),
      @desc       varchar(50),
      @code_bran  varchar(10)
)
AS
DECLARE @Result int
BEGIN TRANSACTION
IF EXISTS
(
      SELECT
            NULL
      FROM
            area WITH (UPDLOCK)
      WHERE
            Areacode = @area_code 
 ) 
      BEGIN
            SELECT @Result = -1
      END
ELSE
      BEGIN
            INSERT INTO
                  area
            (
                  Areacode,
                  Description,
                  Branch_Code
            )
            VALUES
            (
                 @area_code,
                 @desc,
                 @code_bran
            )
            SELECT @Result = @@ERROR
      END
IF @Result <> 0
      BEGIN
	--SELECT 'AreaCode Already Exists !!! Please Use A Different AreaCode !!!'
	RAISERROR ('AreaCode Already Exists !!! Please Use A Different AreaCode !!!', 16, 1)
        ROLLBACK
      END
ELSE
      BEGIN
            COMMIT
      END
--RETURN @Result

GO
