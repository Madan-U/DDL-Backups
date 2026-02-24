-- Object: PROCEDURE citrus_usr.Pr_Fetch_inward_types
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[Pr_Fetch_inward_types]
@pa_dptype varchar(4),
@pa_sliptype varchar(10)
as
begin
	if @pa_dptype = 'CDSL'
	begin
        IF @pa_sliptype='CRTE' -- FOR PLEDGE --'PLEDGE' 
		begin
			select cd='PLEDGE',descp='PLEDGE'
		end
        IF @pa_sliptype='UNPLEDGE' 
		begin
			select cd='UNPLEDGE',descp='UNPLEDGE'
		end
        IF @pa_sliptype='CONFISCATE' 
		begin
			select cd='CONFISCATE',descp='CONFISCATE'
		end
        IF @pa_sliptype='DEMAT' 
		begin
			select cd='DEMAT',descp='DEMAT'
		end
        IF @pa_sliptype='REMAT' 
		begin
			select cd='REMAT',descp='REMAT'
		end
        ELSE
        BEGIN
		SELECT CD,REPLACE(REPLACE(REPLACE(DESCP,'DIRECT PAY IN','NORMAL PAY IN'),'CM-CM (DEBIT)','INTERSETTLEMENT'),'OFFMARKET DEBIT (INTRA)','OFFMARKET DEBIT') DESCP FROM FN_GETSUBTRANSDTLS('INT_TRANS_TYPE_CDSL')
		--WHERE CD IN('EP-DR','EXCHPAYIN','INTDEP-DR','OF-DR','SETTLEMENT-DR')
		WHERE CD IN('EP-DR','INTDEP-DR','OF-DR','SETTLEMENT-DR','CM-CM')
		
		UNION
		select cd='CON-DR',descp='CDSL ON MARKET'
		UNION
		select cd='NON-DR',descp='NSDL ON MARKET'
ORDER BY DESCP
        END
	end
	else
	begin
		if @pa_sliptype = '901'
		begin
			select cd='011',descp='DEMAT REQUEST'
		end
		if @pa_sliptype = '902'
		begin
			select cd='021',descp='REMAT REQUEST'
		end
		if @pa_sliptype = '904_ACT' 
		begin
			select cd='033',descp='OFF MARKET/MARKET TRADE (INTRA DELIVERY)'
			UNION
			select cd='042',descp='OFF MARKET/MARKET TRADE (INTER DELIVERY)'
		end
		if @pa_sliptype = '904_P2C' 
		begin
			select cd='033',descp='MARKET TRADE (INTRA DELIVERY)'
			UNION
			select cd='042',descp='MARKET TRADE (INTER DELIVERY)'
		end
		if @pa_sliptype = '906' OR @pa_sliptype = '912'
		begin
			select cd='052',descp='DELIVERY OUT INSTRUCTION'
		end
		if @pa_sliptype = '907' 
		begin
			select cd='071',descp='INTER SETTLEMENT DELIVERY'
		end
		if @pa_sliptype = '907' 
		begin
			select cd='071',descp='INTER SETTLEMENT DELIVERY'
		end
		if @pa_sliptype = '925' 
		begin
			select cd='202',descp='INTER DEPOSITORY INSTRUCTION (DELIVERY)'
		end
		if @pa_sliptype = '934' 
		begin
			select cd='212',descp='POOL TO POOL TRANSFER'
		end
		if @pa_sliptype = '908'  
		begin
			select cd='091',descp='PLEDGE REQUEST'
		end
		if @pa_sliptype = '911'  
		begin
			select cd='092',descp='UNPLEDGE'
		end
		if @pa_sliptype = '910'  
		begin
			select cd='093',descp='INVOCATION'
		end
		if @pa_sliptype = '905_ACT'  
		begin
			select cd='0',descp='ACCOUNT TRANSFER(RECEIPT)'
		end
		if @pa_sliptype = '926'  
		begin
			select cd='0',descp='INTER DEPOSITORY(RECEIPT)'
		end

	end


end

GO
