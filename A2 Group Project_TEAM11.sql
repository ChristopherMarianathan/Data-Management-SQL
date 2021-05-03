########################################################################################################
# A2: Group Project
# Team : Fotios Psaroulis, Hanna Laticia Gerharter, Jaswanth Guntumadugu, Christopher Pramodh
######################################################################################################
# Part 1 : Profit and Loss Statement 
# Instructions
# 1) Intialize Database - Line 14
# 2) Drop view - Line 15 (customize to the view you have access to)
# 3) Choose year - Line 31
# 4) Create view - Line 16 (customize to the view you have access to)
# 5) Execute query to find P&L line items - Line 41
# 6) Execute query to find profit - Line 42
# 7) As 2019 is an incomplete year, to view data in 2019 please comment out line 19,33,34,37 
USE H_Accounting;
DROP VIEW cpramodh2019_view;
CREATE VIEW cpramodh2019_view AS 
SELECT ss.statement_section_order,
ss.statement_section_id,
je.debit_credit_balanced,
acc.profit_loss_section_id,
ss.statement_section,
FORMAT(SUM(IFNULL(jelt.credit,0)) - SUM(IFNULL(jelt.debit,0)),2) AS Amount,
ss.debit_is_positive
FROM journal_entry_line_item AS jelt
INNER JOIN journal_entry AS je 
ON jelt.journal_entry_id = je.journal_entry_id
INNER JOIN account AS acc
ON jelt.account_id = acc.account_id
INNER JOIN statement_section as ss
ON acc.profit_loss_section_id = ss.statement_section_id
WHERE YEAR(je.entry_date) = 2017  
AND jelt.company_id = 1
AND je.debit_credit_balanced = 1 
AND je.cancelled = 0
AND ss.is_balance_sheet_section = 0
AND ss.statement_section_id <> 0
AND je.closing_type = 0
GROUP BY acc.profit_loss_section_id
ORDER BY ss.statement_section_order;

SELECT * FROM cpramodh2019_view;
SELECT SUM(AMOUNT) AS profit_loss FROM cpramodh2019_view; # "-" is profit and "no sign" is loss

# Part 2 : Balance Sheet 
# Instructions
# 1) Drop view - Line 52 (customize to the view you have access to)
# 2) Choose year - Line 66
# 3) Create view - Line 53 (customize to the view you have access to)
# 4) Execute query to find B/S line items - Line 75
# 5) Execute query to find debit-credit balance - Line 76

DROP VIEW cpramodh2019_view;
CREATE VIEW cpramodh2019_view AS
SELECT ss.statement_section_order,
acc.balance_sheet_section_id,
ss.statement_section,
FORMAT(SUM(jelt.debit)	- SUM(jelt.credit),2) AS Amount,
ss.debit_is_positive
FROM journal_entry_line_item AS jelt
INNER JOIN journal_entry AS je 
ON jelt.journal_entry_id = je.journal_entry_id
INNER JOIN account AS acc
ON jelt.account_id = acc.account_id
INNER JOIN statement_section as ss
ON acc.balance_sheet_section_id = ss.statement_section_id
WHERE YEAR(je.entry_date) <= 2017
AND jelt.company_id = 1
AND je.debit_credit_balanced = 1 
AND je.cancelled = 0
AND ss.is_balance_sheet_section = 1
AND ss.statement_section_id <> 0
GROUP BY acc.balance_sheet_section_id
ORDER BY ss.statement_section_order;

SELECT * FROM cpramodh2019_view;
SELECT SUM(Amount) AS balance FROM cpramodh2019_view;