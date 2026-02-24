-- Object: PROCEDURE dbo.pr_select_mig_tabTemp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_select_mig_tabTemp
					(
						@pa_id      VARCHAR(250)
                 ,@pa_tab     VARCHAR(100)
                 ,@pa_from_dt VARCHAR(11)
                 ,@pa_to_dt   VARCHAR(11)
                 ,@pa_err     VARCHAR(250)   OUTPUT
                 ,@pa_ref_cur VARCHAR(8000)  OUTPUT
                 )
AS 
BEGIN
	SET NOCOUNT ON

	DECLARE 
		@SQL VARCHAR(1000)

		SET @pa_err = '0'
		SET @pa_ref_cur =  'Success'

		IF ISNULL(@pa_tab  ,'') <> ''
		BEGIN
			--- SET @SQL = 'SELECT *, ''M'' AS Flag  FROM ' + @pa_tab
			SET @SQL = 'SELECT 1 AS RowID, Areacode,Description,Branch_Code, ''M'' AS Dummy1, ''D'' As Dummy2, ''M'' AS Modified  FROM ' + @pa_tab
			SET @SQL = @SQL + ' UNION SELECT 2 , ''MADURAI'', ''MADURAI'', ''MADURAI'', '''', '''', ''N'' '
			SET @SQL = @SQL + ' UNION SELECT 3 , ''MADURAI'', ''MADURAI'', ''MADURAI'', '''', '''', ''D'' '

			EXEC(@SQL)
		END
	
	IF @@ERROR <> 0
	BEGIN
		SET @pa_err = @@ERROR
		SET @pa_ref_cur = 'Error occured' 	
	END

	SET NOCOUNT OFF
END

GO
