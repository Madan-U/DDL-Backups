-- Object: PROCEDURE dbo.V2_SPLITSTRING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE V2_SPLITSTRING
                @SPLITSTRING VARCHAR(100),
                @DELIMITER   VARCHAR(3)
                
AS

/* Split the String and get splitted values in the result-set. Delimiter upto 3 characters long can be used for splitting */

  SET NOCOUNT ON
  
  DECLARE  @STRING         VARCHAR(100),
           @POSITION       INT,
           @START_LOCATION INT,
           @STRING_LENGTH  INT
                           
  SET @STRING = @SPLITSTRING
                
  SET @POSITION = 0
                  
  SET @START_LOCATION = 0
                        
  SET @STRING_LENGTH = LEN(@STRING)
                       
  CREATE TABLE [#SPLITTED] (
    [SPLITTED_VALUE] [VARCHAR](100)   NOT NULL)
  ON [PRIMARY]
  
  WHILE @STRING_LENGTH > 0
    BEGIN
    
      SET @POSITION = CHARINDEX(@DELIMITER,@STRING,@START_LOCATION)
                      
      IF @POSITION = 0
        BEGIN
          INSERT INTO #SPLITTED
          SELECT @STRING
                 
          SET @STRING_LENGTH = 0
                               
        END
      ELSE
        BEGIN
          INSERT INTO #SPLITTED
          SELECT LEFT(@STRING,@POSITION - 1)
                 
          SET @STRING = RIGHT(@STRING,@STRING_LENGTH - @POSITION)
                        
          SET @STRING_LENGTH = LEN(@STRING)
        END
        
    END
    
  SELECT *
  FROM   #SPLITTED
         
  DROP TABLE #SPLITTED

GO
