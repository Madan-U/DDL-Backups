-- Object: PROCEDURE dbo.proc_airflow_poc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC proc_airflow_poc
AS
	INSERT into temp_airflow 
	select top 1 * from TBL_TOT_SUMMARY

GO
