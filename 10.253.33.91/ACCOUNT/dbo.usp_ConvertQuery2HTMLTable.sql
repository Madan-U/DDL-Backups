-- Object: PROCEDURE dbo.usp_ConvertQuery2HTMLTable
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC dbo.usp_ConvertQuery2HTMLTable (@SQLQuery NVARCHAR(3000))
AS
BEGIN
   DECLARE @columnslist NVARCHAR (1000) = ''
   DECLARE @restOfQuery NVARCHAR (2000) = ''
   DECLARE @DynTSQL NVARCHAR (3000)
   DECLARE @FROMPOS INT

   SET NOCOUNT ON

   SELECT @columnslist += 'ISNULL (' + NAME + ',' + '''' + ' ' + '''' + ')' + ','
   FROM sys.dm_exec_describe_first_result_set(@SQLQuery, NULL, 0)

   SET @columnslist = left (@columnslist, Len (@columnslist) - 1)
   SET @FROMPOS = CHARINDEX ('FROM', @SQLQuery, 1)
   SET @restOfQuery = SUBSTRING(@SQLQuery, @FROMPOS, LEN(@SQLQuery) - @FROMPOS + 1)
   SET @columnslist = Replace (@columnslist, '),', ') as TD,')
   SET @columnslist += ' as TD'
   SET @DynTSQL = CONCAT (
         'SELECT (SELECT '
         , @columnslist
         ,' '
         , @restOfQuery
         ,' FOR XML RAW (''TR''), ELEMENTS, TYPE) AS ''TBODY'''
         ,' FOR XML PATH (''''), ROOT (''TABLE'')'
         )

   EXEC (@DynTSQL)
   SET NOCOUNT OFF
END

GO
