-- Object: PROCEDURE dbo.spx_rekyc_bse_get_client_with_pan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- =============================================
-- Author:		Mitesh Parmar
-- Create date: 2023-01-30
-- Description:	Get PAN numbers of a client from code list
-- spx_rekyc_bse_get_client_with_pan 'M127008,P99400'
-- =============================================
CREATE PROCEDURE [dbo].[spx_rekyc_bse_get_client_with_pan]
(
	@codes varchar(max)
)
AS
BEGIN
	-- ===========================================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- ===========================================================
	SET NOCOUNT ON;

    create table #temp
	(
		code varchar(100)
	)

	insert into #temp (code)
	SELECT	value  
	--FROM	dbo.STRING_SPLIT(@codes, ',')  
	FROM	dbo.fn_Split(@codes, ',')  


	select	Party_code as CLIENT_CODE,
			pan_gir_no as PAN
	from	dbo.client_details C with(NoLock)
				inner join
			#temp t
					on t.code = c.Party_code

	drop table #temp

END

GO
