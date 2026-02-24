-- Object: PROCEDURE dbo.Add_client_proc_share_client_insert_multiclientdpid_tmp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Add_client_proc_share_client_insert_multiclientdpid_tmp

	@tmppartycode Varchar (10),
	@tmpclientdpid Varchar (16),
	@tmpdpid Varchar (15),
	@tmplongname Varchar (100),
	@tmpdepository Varchar (7),
	@tmppoa Varchar (1)

As

	Insert Into
		Tmp_client_details_multiclientdpid
	Values
		(
			@tmppartycode, 
			@tmpclientdpid, 
			@tmpdpid, 
			@tmplongname, 
			@tmpdepository, 
			@tmppoa
		)

GO
