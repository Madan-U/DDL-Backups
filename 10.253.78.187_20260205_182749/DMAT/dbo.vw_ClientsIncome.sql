-- Object: VIEW dbo.vw_ClientsIncome
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




							CREATE VIEW [dbo].[vw_ClientsIncome]



AS


	SELECT DISTINCT ac1.PARTY_CODE,b.DESCRIPTION AS IncomeSlab,oc.DESCRIPTION AS Occupation,ac1.Db_ClientType AS [B2C/B2B]
	 --DATEDIFF(year, ac1.birthdate, getdate())Age

	from [196.1.115.159].Ispacescorecard.DBO.Angelclient1 ac1 



		JOIN ANAND1.msajag.dbo.CLIENT_MASTER_UCC_DATA a WITH(NOLOCK) 



		ON ac1.PARTY_CODE=a.PARTY_CODE



		LEFT JOIN ANAND1.msajag.dbo.CLIENT_STATIC_CODES b WITH(NOLOCK)  



		on a.gross_income=b.code collate database_default AND b.CATEGORY ='INCOMESLAB_NONIND' AND b.kra_type='CDSL' 



		LEFT JOIN ANAND1.msajag.dbo.CLIENT_STATIC_CODES oc WITH(NOLOCK)  



		on a.OCCUPATION=oc.code collate database_default AND oc.CATEGORY ='OCCUPATION' AND oc.kra_type='CDSL' 			



	--WHERE ActiveFrom_Broking>='2019-04-01' AND ActiveFrom_Broking<'2019-04-10'

GO
