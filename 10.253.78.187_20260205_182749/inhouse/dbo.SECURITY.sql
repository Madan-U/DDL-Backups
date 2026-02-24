-- Object: VIEW dbo.SECURITY
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE VIEW [dbo].[SECURITY]
AS
SELECT 
sc_isincode = isin,
sc_nsecurity_code = '',
sc_book_basis = '',
sc_isinname = comp_name,
sc_company_code = '',
sc_company_name = isin_short_name,
sc_security_type = secu_type,
sc_security_subtype = '',
sc_issue = '',
sc_maturity_date = '',
sc_convert_date = '',
sc_face_value = '',
sc_convert_amount = '',
sc_transferagent = rta_id,
sc_agentname = rta_name,
sc_security_status = mkt_type,
sc_security_remark = isin_status,
sc_decimal_allow = '',
sc_reg_code = '',
sc_reg_name = '',
sc_bsecd = '',
sc_nsesym = '',
sc_nsesrs = '',
sc_attn = '',
sc_sl_balance = '',
sc_rate = '',
sc_ratedt = '',
sc_corporateaction = '',
mkrid = '',
mkrdt = '',
sc_sector = '',
sc_group = '',
sc_bsesymbol = ''
FROM VW_ISIN_MASTER WITH (NOLOCK)

GO
