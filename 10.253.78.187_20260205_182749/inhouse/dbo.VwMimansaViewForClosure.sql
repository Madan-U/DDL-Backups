-- Object: VIEW dbo.VwMimansaViewForClosure
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

Create View VwMimansaViewForClosure
As
	SELECT 
	Distinct NISE_PARTY_CODE as Cl_Code,
		(
			SELECT CLIENT_CODE +','
			FROM Dmat.citrus_usr.tbl_client_master c with(nolock)
			WHERE c.NISE_PARTY_CODE= t1.NISE_PARTY_CODE
			FOR XML PATH('')
		)   DPIDMArk,
		(
			SELECT CLIENT_CODE +','
			FROM tbl_client_master c with(nolock)
			WHERE c.NISE_PARTY_CODE= t1.NISE_PARTY_CODE and [Status]='CLOSED'
			FOR XML PATH('')
		)   DPIDClose 
		
	FROM Dmat.citrus_usr.tbl_client_master t1 with(nolock)

GO
