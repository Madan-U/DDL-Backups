-- Object: PROCEDURE dbo.CBO_GETDP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE    PROCEDURE [dbo].[CBO_GETDP]
(
	@bank_id VARCHAR(15) = '',
        @bank_name VARCHAR(25)='',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS

	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
   IF (@bank_id = '' OR @bank_id = '%')and(@bank_name = '' OR @bank_name = '%')
		BEGIN
			SELECT
				BankId,   
		                BankName,
		                address1,
		                address2,
		                city,
		                pincode,  
		                phone1,  
		                phone2, 
				phone3, 
				phone4, 
				fax1,  
				fax2,   
				email,   
				BankType 
			FROM
				BANK
			
			ORDER BY
				BankId 
		END

ELSE IF @bank_id <> ''
		BEGIN
			SELECT
				BankId,   
		                BankName,
		                address1,
		                address2,
		                city,
		                pincode,  
		                phone1,  
		                phone2, 
				phone3, 
				phone4, 
				fax1,  
				fax2,   
				email,   
				BankType 
			FROM
				BANK
			WHERE
				BankId LIKE @bank_id + '%'
			ORDER BY
				BankId
		END
	Else
                BEGIN
			SELECT
				BankId,   
		                BankName,
		                address1,
		                address2,
		                city,
		                pincode,  
		                phone1,  
		                phone2, 
				phone3, 
				phone4, 
				fax1,  
				fax2,   
				email,   
				BankType 
			FROM
				BANK
			WHERE
				BankName LIKE @bank_name + '%'
			ORDER BY
				BankName
		END

GO
